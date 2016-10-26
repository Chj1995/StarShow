//
//  SWTagViewController.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWTagViewController.h"
#import "NSString+Size.h"
#import "HttpRequest.h"
#import "SWFashionGoodsCell.h"
#import "MJRefresh.h"
#import "SWGoodsModel.h"
#import "SWPostDetailViewController.h"
#import "SWNavigationBarView.h"
#import "AFNetworkReachabilityManager.h"

/**
 背景颜色
 */
#define kBackColor [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]

@interface SWTagViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    //背景图
    UIView *subView;
    //导航栏
    SWNavigationBarView *navigationBarView;
    
    NSInteger _currentPage;
    
    UIButton *button;
    UILabel *label;
}
/**
 数据源
 */
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,weak)UICollectionView *collectionView;

@end

@implementation SWTagViewController
#pragma mark - 懒加载
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        UICollectionView *collectionVeiw = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBarView.frame)+1, subView.frame.size.width, subView.frame.size.height - CGRectGetMaxY(navigationBarView.frame)) collectionViewLayout:layout];
        
        collectionVeiw.dataSource = self;
        collectionVeiw.delegate = self;
        
        collectionVeiw.backgroundColor = [UIColor whiteColor];
        
        [collectionVeiw registerClass:[SWFashionGoodsCell class] forCellWithReuseIdentifier:@"GoodsCell"];
        [subView addSubview:collectionVeiw];
        
        collectionVeiw.mj_header = [self header];
        collectionVeiw.mj_footer = [self foot];
        
        _collectionView = collectionVeiw;
    }
    return _collectionView;
}
#pragma mark - 刷新
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 0;
        [self requestDataFromNetWorking];
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
        
        _currentPage += 18;
        [self requestDataFromNetWorking];
    }];
    
    [foot setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [foot setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [foot setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return foot;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _currentPage = 0;
    
    //1.创建导航栏
    [self setupNavigationBar];
    
    [self setupButtonAndLabel];
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            
            //2.请求网络数据
            [self requestDataFromNetWorking];
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
    
    [subView addSubview:button];
    
    //设置提示label
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(button.frame) - 40, self.view.frame.size.width, 20)];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"正在加载数据....";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [subView addSubview:label];
    
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
    [self requestDataFromNetWorking];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        label.text = @"数据加载失败，再试试";
    });
}
#pragma mark - 创建自定义导航栏
/**
 1.创建自定义导航栏
 */
-(void)setupNavigationBar
{
    
    __weak SWTagViewController *weekSelf = self;
    
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    subView.backgroundColor = kBackColor;
    [self.view addSubview:subView];
    
    navigationBarView = [[SWNavigationBarView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 50)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [navigationBarView setNavigationBarViewGoToBackCallback:^{
        
        [weekSelf goToBack];
    }];
    
    [subView addSubview:navigationBarView];}
#pragma mark - 创建导航栏标题
/**
 创建导航栏标题
 */
-(void)setupNavigationTitleWithTilte:(NSString *)title
{
    //标题
    [navigationBarView setupTitleLableWithTitle:[NSString stringWithFormat:@"#%@",title] TitleSize:16];
}
#pragma mark - 请求网络数据
-(void)requestDataFromNetWorking
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://api-v2.mall.hichao.com/forum/tag/get-new?ga=%2Fforum%2Ftag%2Fget-new&recommend=1&flag=&"];
    [urlStr appendFormat:@"flag=%ld",_currentPage];
    [urlStr appendFormat:@"&tag_id=%ld",self.picId];
    
    [HttpRequest GET:urlStr paramters:nil success:^(id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        [self handleDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
       
        [self setupFailRequestDataFromNetWorking];
        
    }];
    
    //获取主题名
    NSMutableString *urlStr2 = [NSMutableString stringWithString:@"http://api-v2.mall.hichao.com/forum/tag/get-new?ga=%2Fforum%2Ftag%2Fget-new&recommend=1&flag=&flag="];
    [urlStr2 appendFormat:@"&tag_id=%ld",self.picId];
    
    [HttpRequest GET:urlStr2 paramters:nil success:^(id responseObject) {
        [self setupNavigationTitleWithTilte:responseObject[@"response"][@"data"][@"tagHead"][@"title"]];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    if (_currentPage == 0) {
        
        [self.dataSource removeAllObjects];
    }
    
    NSArray *goodsArray = responseObject[@"response"][@"data"][@"items"];
    
    for (NSDictionary *dic in goodsArray) {
        
        SWGoodsModel *model = [[SWGoodsModel alloc] init];
        
        model.width = dic[@"width"];
        model.height = dic[@"height"];
        
        model.pics = dic[@"component"][@"pics"];
        model.content = dic[@"component"][@"content"];
        model.collect_count = dic[@"component"][@"collect_count"];
        model.userAvatar = dic[@"component"][@"user"][@"userAvatar"];
        model.username = dic[@"component"][@"user"][@"username"];
        model.picId = dic[@"component"][@"action"][@"id"];
        
        [self.dataSource addObject:model];
    }
    [self.collectionView reloadData];
}

#pragma mark - 按钮点击事件
-(void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWFashionGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCell" forIndexPath:indexPath];
    
    cell.goodsModel = self.dataSource[indexPath.item];
    
    return cell;
}
#pragma mark - cell的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWGoodsModel *model = self.dataSource[indexPath.item];
    
    CGFloat width = (self.view.frame.size.width - 15)/2;
    
    CGFloat height = [model.height integerValue];
    
    return CGSizeMake(width, height + 40);
}
#pragma mark - UICollectionViewDelegate
/**
 点击时触发
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWGoodsModel *model = self.dataSource[indexPath.row];
    
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
