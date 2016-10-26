//
//  SFSFashionCycleViewController.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSFashionCycleViewController.h"
#import "HttpRequest.h"
#import "ADModel.h"
#import "ADToolModel.h"
#import "SWGoodsModel.h"
#import "SWHeaderView.h"
#import "SWFashionGoodsCell.h"
#import "MJRefresh.h"
#import "SWGoodsModel.h"
#import "SWPostDetailViewController.h"
#import "SWTagViewController.h"
#import "AFNetworkReachabilityManager.h"

//item之间的距离
#define kitemSpace 5
@interface SFSFashionCycleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _currentPage;
    
    UIButton *button;
    UILabel *label;
    
}
@property(nonatomic,weak)UICollectionView *collectionView;

/**
 广告栏数据
 */
@property(nonatomic,strong)NSMutableArray *adDataSourceArray;
/**
 工具栏数据
 */
@property(nonatomic,strong)NSMutableArray *adToolArray;
/**
 推荐物品数据
 */
@property(nonatomic,strong)NSMutableArray *goodsArray;

@end

@implementation SFSFashionCycleViewController
#pragma mark - 懒加载
-(NSMutableArray *)adDataSourceArray
{
    if (!_adDataSourceArray) {
        
        _adDataSourceArray = [NSMutableArray array];
    }
    return _adDataSourceArray;
}
-(NSMutableArray *)adToolArray
{
    if (!_adToolArray) {
        
        _adToolArray = [NSMutableArray array];
    }
    return _adToolArray;
}
-(NSMutableArray *)goodsArray
{
    if (!_goodsArray) {
        
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        UICollectionView *collectionVeiw = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        collectionVeiw.backgroundColor = [UIColor whiteColor];
        collectionVeiw.showsVerticalScrollIndicator = NO;
        collectionVeiw.dataSource = self;
        collectionVeiw.delegate = self;
        
        [self.view addSubview:collectionVeiw];
        
        //注册cell
        [collectionVeiw registerClass:[SWFashionGoodsCell class] forCellWithReuseIdentifier:@"GoodsCell"];
        
        //注册表头
        [collectionVeiw registerClass:[SWHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SWHeaderView"];
        
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
        [self requestADDataFromNetWorking];
        [self requestChooseViewGoodsDataFromNetWorking];
        
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
        [self requestChooseViewGoodsDataFromNetWorking];
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
    
    [self setupButtonAndLabel];
    _currentPage = 0;
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            
            /**
             请求网络数据
             */
            [self requestADDataFromNetWorking];
            [self requestChooseViewGoodsDataFromNetWorking];
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
     请求网络数据
     */
    [self requestADDataFromNetWorking];
    [self requestChooseViewGoodsDataFromNetWorking];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        label.text = @"数据加载失败，再试试";
    });
}
#pragma mark - 请求网络数据
-(void)requestADDataFromNetWorking
{
    //广告栏
    NSDictionary *paramters = @{@"gn":@"mxyc_adr",
                                @"gsv":@"4.4.4",
                                @"gi":@"99000566557828",
                                @"token":@"",
                                @"p":@"MI 4C",
                                @"gv":@"700",
                                @"gc":@"hichao",
                                @"gos":@"7.0.0",
                                @"gf":@"android",
                                @"gs":@"1080x1920",
                                @"access_token":@""};
    
    [HttpRequest GET:@"http://api-v2.mall.hichao.com/forum/banner?ga=%2Fforum%2Fbanner" paramters:paramters success:^(id responseObject) {
       
        [self handleDataObjectWithOnject:responseObject];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    //工具栏
    [HttpRequest GET:@"http://api-v2.mall.hichao.com/forum/tag-recommend?ga=%2Fforum%2Ftag-recommend" paramters:nil success:^(id responseObject) {
        
        [self handleToolDataObjectWithOnject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 请求推荐界面物品数据
 */
-(void)requestChooseViewGoodsDataFromNetWorking
{
    //推荐界面物品数据
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://api-v2.mall.hichao.com/forum/recommend-list?ga=%2Fforum%2Frecommend-list&flag="];
    [urlStr appendFormat:@"flag=%ld",_currentPage];
    
    [HttpRequest GET:urlStr paramters:nil success:^(id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self handleGoodsDataObjectWithOnject:responseObject];
        
    } failure:^(NSError *error) {
        
        [self setupFailRequestDataFromNetWorking];
    }];
}
#pragma mark - 封装数据
//广告栏
-(void)handleDataObjectWithOnject:(id)responseObject
{
    [self.adDataSourceArray removeAllObjects];
    
    NSArray *items = responseObject[@"data"][@"items"];
    
    for (NSDictionary *dic in items)
    {
        ADModel *adModel = [[ADModel alloc]init];
        
        adModel.picUrl = dic[@"component"][@"picUrl"];
        adModel.picId = dic[@"component"][@"action"][@"id"];
        
        [self.adDataSourceArray addObject:adModel];
    }
}
//工具栏
-(void)handleToolDataObjectWithOnject:(id)responseObject
{
    [self.adToolArray removeAllObjects];
    
    NSArray *items = responseObject[@"response"][@"data"][@"items"];
    
    for (NSDictionary *dic  in items) {
        
        ADToolModel *model = [[ADToolModel alloc] init];
        model.picUrl = dic[@"component"][@"picUrl"];
        model.title = dic[@"component"][@"title"];
        model.picId = dic[@"component"][@"action"][@"id"];
        [self.adToolArray addObject:model];
    }
}
//物品
-(void)handleGoodsDataObjectWithOnject:(id)responseObject
{
    if (_currentPage == 0) {
        
        [self.goodsArray removeAllObjects];
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
        if (model.content != nil) {
            
            [self.goodsArray addObject:model];
        }
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
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWFashionGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCell" forIndexPath:indexPath];
    cell.goodsModel = _goodsArray[indexPath.item];
    return cell;
}
#pragma mark - cell的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWGoodsModel *model = _goodsArray[indexPath.item];
    
    CGFloat picHeight = [model.height integerValue];
    
    CGFloat width = (self.view.frame.size.width - kitemSpace*3)/2;
    CGFloat height = picHeight;
    return CGSizeMake(width, height + 40);
}
#pragma mark - 设置段头
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        //表头
        SWHeaderView  *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SWHeaderView" forIndexPath:indexPath];
        
        headView.adArray = self.adDataSourceArray;
        headView.adToolArray  =self.adToolArray;
        /**
         跳转到帖子详情的回调
         */
        [headView setHeaderViewRequestDataFromNetWorkingCallback:^(NSInteger picId) {
            
            [self changeToPostDetailViewControllerWithPicId:picId];
            
        }];
        /**
         跳转到标签界面的回调
         */
        [headView setHeaderViewChangeToTagViewCtrlCallback:^(NSInteger picId) {
            
            [self changeToTagViewCtrlWithPicId:picId];
        }];
        return headView;
    }
    return nil;
}
/**
 *  表头高度
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 290);
}
/**
 选中触发
 
 @param collectionView <#collectionView description#>
 @param indexPath      <#indexPath description#>
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SWGoodsModel *model = _goodsArray[indexPath.row];
    
    [self changeToPostDetailViewControllerWithPicId:[model.picId integerValue]];
    
}

#pragma mark - 切换到帖子详情
-(void)changeToPostDetailViewControllerWithPicId:(NSInteger)picId
{
    SWPostDetailViewController *postDetailViewController = [[SWPostDetailViewController alloc] init];
    
    postDetailViewController.picId = picId;
    
    [self.navigationController pushViewController:postDetailViewController animated:YES];
}
#pragma mark - 切换到标签界面
-(void)changeToTagViewCtrlWithPicId:(NSInteger)picId
{
    SWTagViewController *tagViewCtroller = [[SWTagViewController alloc] init];
    tagViewCtroller.picId = picId;
    [self.navigationController pushViewController:tagViewCtroller animated:YES];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
