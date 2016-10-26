//
//  SFSReachPeopleViewController.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSReachPeopleViewController.h"
#import "NSString+Size.h"
#import "HttpRequest.h"
#import "SWWardrobeMasterModel.h"
#import "SWWardrobeMasterCell.h"
#import "ADModel.h"
#import "MJRefresh.h"
#import "SWNavigationBarView.h"
#import "SWPostDetailViewController.h"
#import "AFNetworkReachabilityManager.h"

/**
 背景颜色
 */
#define kBackColor [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
@interface SFSReachPeopleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentWardrobeMasterPage;
    
    UIButton *button;
    UILabel *label;
}
@property(nonatomic,weak)UITableView *tableView;

/**
 数据源
 */
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation SFSReachPeopleViewController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tb = [[UITableView alloc] initWithFrame:self.view.bounds];
        tb.delegate = self;
        tb.dataSource = self;
        tb.rowHeight = 180;
        [self.view addSubview:tb];
        
        [tb registerClass:[SWWardrobeMasterCell class] forCellReuseIdentifier:@"cell"];
        
        tb.mj_header = [self header];
        tb.mj_footer = [self foot];
        
        _tableView = tb;
    }
    
    return _tableView;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark - 刷新
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentWardrobeMasterPage = 0;
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
        _currentWardrobeMasterPage += 18;
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
    
    _currentWardrobeMasterPage = 0;
    [self setupButtonAndLabel];
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            
            /**
             请求网络数据
             */
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
    [self requestDataFromNetWorking];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        label.text = @"数据加载失败，再试试";
    });
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - 请求网络数据
-(void)requestDataFromNetWorking
{
    NSMutableString *wardrobeMasterUrlStr = [NSMutableString stringWithString:@"http://api-v2.mall.hichao.com/forum/star?ga=%2Fforum%2Fstar&"];
    [wardrobeMasterUrlStr appendFormat:@"flag=%ld",_currentWardrobeMasterPage];
    
    [HttpRequest GET:wardrobeMasterUrlStr paramters:nil success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self handleDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
        [self setupFailRequestDataFromNetWorking];
    }];
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    if (_currentWardrobeMasterPage == 0) {
        
        [self.dataSource removeAllObjects];
    }
    
    NSArray *items = responseObject[@"data"][@"items"];
    
    for (NSDictionary *dic in items) {
        
        SWWardrobeMasterModel *model = [[SWWardrobeMasterModel alloc] init];
        NSDictionary *dic2 = dic[@"component"];
        model.userAvatar = dic2[@"userAvatar"];
        model.userName = dic2[@"userName"];
        model.userTypeName = dic2[@"userTypeName"];
        
        NSArray *pics = dic2[@"pics"];
        
        for (NSDictionary *dic3 in pics)
        {
            ADModel *admodel = [[ADModel alloc] init];
            admodel.picUrl = dic3[@"component"][@"picUrl"];
            admodel.picId = dic3[@"component"][@"action"][@"id"];
            [model.pics addObject:admodel];
        }
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWWardrobeMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.model = self.dataSource[indexPath.row];
    [cell setWardrobeMasterCellChangeToDetailViewCtrlCallback:^(NSInteger picId) {
       
        [self changeToPostDetailViewControllerWithPicId:picId];
    }];
    return cell;
}

#pragma mark - 切换到帖子详情
-(void)changeToPostDetailViewControllerWithPicId:(NSInteger)picId
{
    SWPostDetailViewController *postDetailViewController = [[SWPostDetailViewController alloc] init];
    
    postDetailViewController.picId = picId;
    
    [self.navigationController pushViewController:postDetailViewController animated:YES];
}

@end
