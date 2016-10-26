//
//  SFSLatestViewController.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSLatestViewController.h"
#import "SWFashionGoodsCell.h"
#import "MJRefresh.h"
#import "SWGoodsModel.h"
#import "HttpRequest.h"
#import "SWPostDetailViewController.h"
#import "AFNetworkReachabilityManager.h"

@interface SFSLatestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _curentPage;
    
    UIButton *button;
    UILabel *label;
}

@property(nonatomic,weak)UICollectionView *collectionView;

/**
 最新物品数据
 */
@property(nonatomic,strong)NSMutableArray *goodsLatestArray;

@end

@implementation SFSLatestViewController
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        UICollectionView *collectionVeiw = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        collectionVeiw.dataSource = self;
        collectionVeiw.delegate = self;
        
        [self.view addSubview:collectionVeiw];
        
        collectionVeiw.backgroundColor = [UIColor whiteColor];
        
        [collectionVeiw registerClass:[SWFashionGoodsCell class] forCellWithReuseIdentifier:@"GoodsCell"];
        
        collectionVeiw.mj_header = [self header];
        collectionVeiw.mj_footer = [self foot];
        
        _collectionView = collectionVeiw;
    }
    return _collectionView;
}
-(NSMutableArray *)goodsLatestArray
{
    if (!_goodsLatestArray) {
        
        _goodsLatestArray = [NSMutableArray array];
    }
    return _goodsLatestArray;
}
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _curentPage = 0;
        [self requestLatestViewGoodsDataFromNetWorking];
    }];
    
    //隐藏上次刷新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return header;
}
/**
 上拉刷新
 */
-(MJRefreshBackNormalFooter *)foot
{
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _curentPage += 18;
        [self requestLatestViewGoodsDataFromNetWorking];
        
    }];
    
    [foot setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [foot setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return foot;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _curentPage = 0;
    
    [self setupButtonAndLabel];
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            
            /**
             请求最新界面物品网络数据
             */
            [self requestLatestViewGoodsDataFromNetWorking];
        }else
        {
            [self setupFailNetWorking];
        }
        
    }];
    [manager startMonitoring];
    
}
#pragma mark - 创建按钮和label
-(void)setupButtonAndLabel
{
    //创建重新加载按钮
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 150, 30);
    button.center  = self.view.center;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:button];
    
    //设置提示label
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(button.frame) - 40, self.view.frame.size.width, 20)];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"正在加载数据....";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
}
#pragma mark - 网络请求失败的界面
/**
 没有网络情况下
 */
-(void)setupFailNetWorking
{
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    //设置边框
    [button.layer setBorderWidth:0.5];
    [button.layer setBorderColor:[UIColor orangeColor].CGColor];
    label.text = @"没有网络，请打开网络。。。";
}
/**
 有网络，请求失败情况下
 */
-(void)setupFailRequestDataFromNetWorking
{
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    //设置边框
    [button.layer setBorderWidth:0.5];
    [button.layer setBorderColor:[UIColor orangeColor].CGColor];
    label.text = @"别着急，网有点慢，再试试";
}
-(void)buttonClick
{
    label.text = @"请稍等，正在加载数据。。。";
    /**
     请求最新界面物品网络数据
     */
    [self requestLatestViewGoodsDataFromNetWorking];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        label.text = @"数据加载失败，再试试";
    });
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
/**
 请求最新界面物品数据
 */
-(void)requestLatestViewGoodsDataFromNetWorking
{
    //最新界面
    NSMutableString *latestUrlStr = [NSMutableString stringWithString:@"http://api-v2.mall.hichao.com/forum/thread/new?ga=%2Fforum%2Fthread%2Fnew&"];
    [latestUrlStr appendFormat:@"flag=%ld",_curentPage];
    
    [HttpRequest GET:latestUrlStr paramters:nil success:^(id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self handleLatestDataObjectWithOnject:responseObject];
        
    } failure:^(NSError *error) {
        
        [self setupFailRequestDataFromNetWorking];
    }];
}
/**
 最新界面
 */
-(void)handleLatestDataObjectWithOnject:(id)responseObject
{
    if (_curentPage == 0) {
        
        [self.goodsLatestArray removeAllObjects];
    }
    
    NSArray *goodsArray = responseObject[@"response"][@"data"][@"items"];
    
    for (NSDictionary *dic in goodsArray) {
        
        SWGoodsModel *model = [[SWGoodsModel alloc] init];
        
        model.width = dic[@"weight"];
        model.height = dic[@"height"];
        
        model.pics = dic[@"component"][@"pics"];
        model.content = dic[@"component"][@"content"];
        model.collect_count = dic[@"component"][@"collect_count"];
        model.userAvatar = dic[@"component"][@"user"][@"userAvatar"];
        model.username = dic[@"component"][@"user"][@"username"];
        model.picId = dic[@"component"][@"action"][@"id"];
        [self.goodsLatestArray addObject:model];
    }
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsLatestArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWFashionGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCell" forIndexPath:indexPath];
    
    cell.goodsModel = _goodsLatestArray[indexPath.item];
    
    return cell;
}
#pragma mark - cell的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWGoodsModel *model = _goodsLatestArray[indexPath.item];
    
    CGFloat width = (self.view.frame.size.width - 15)/2;
    
    CGFloat height = [model.height integerValue];
    
    return CGSizeMake(width, height + 40);
}
/**
 选中触发
 
 @param collectionView <#collectionView description#>
 @param indexPath      <#indexPath description#>
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWGoodsModel *model = self.goodsLatestArray[indexPath.row];
    
    [self changeToPostDetailViewControllerWithPicId:[model.picId integerValue]];
    
}
#pragma mark - 切换到帖子详情
-(void)changeToPostDetailViewControllerWithPicId:(NSInteger)picId
{
    SWPostDetailViewController *postDetailViewController = [[SWPostDetailViewController alloc] init];
    
    postDetailViewController.picId = picId;
    
    [self.navigationController pushViewController:postDetailViewController animated:YES];
}

@end
