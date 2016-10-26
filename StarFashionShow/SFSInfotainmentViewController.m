//
//  SFSInfotainmentViewController.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSInfotainmentViewController.h"
#import "HttpRequest.h"
#import "SFSInfotainmentModel.h"
#import "SFSConfig.h"
#import "SFSInfotainmentCell.h"
#import "SFSInfotainmentDetailViewController.h"
#import "MJRefresh.h"
#import "AFNetworkReachabilityManager.h"

@interface SFSInfotainmentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentPage;
    NSInteger _currentTs;
    UIButton *button;
    UILabel *label;
}

@property(nonatomic,weak)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *listDataSource;

@end

@implementation SFSInfotainmentViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [tableView registerClass:[SFSInfotainmentCell class] forCellReuseIdentifier:@"cell"];
        //刷新
        tableView.mj_header = [self header];
        tableView.mj_footer = [self foot];
        
        _tableView = tableView;
    }
    return _tableView;
}
-(NSMutableArray *)listDataSource
{
    if (!_listDataSource) {
        
        _listDataSource = [NSMutableArray array];
    }
    return _listDataSource;
}
#pragma mark - 刷新
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentPage = 1;
        _currentTs = 0;
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
        
        _currentPage++;
        _currentTs = 1477295435;
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
    
    _currentPage = 1;
    _currentTs = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupButtonAndLabel];
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            
            /**
             请求网络数据
             */
            //请求网络数据
            [self requestDataFromNetWorking];
        }else
        {
            [self setupFailNetWorking];
        }
        
    }];
    [manager startMonitoring];
    
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
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

#pragma mark - 请求网络数据
-(void)requestDataFromNetWorking
{
    [HttpRequest GET:[NSString stringWithFormat:@"http://api.app.happyjuzi.com/article/list/channel?id=26&page=%ld&ts=%ld&startup=0&uid=4033812942430866&res=1080x1920&pf=android&accesstoken=c05ab7a9dd7b9251051a0eb240dd79c1&mac=0c-1d-af-d9-f0-5b&ver=3.4&net=wifi&channel=yingyongbao",_currentPage,_currentTs] paramters:nil success:^(id responseObject) {
        
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
    if (_currentPage == 1) {
        
        [self.listDataSource removeAllObjects];
    }
    NSArray *list = responseObject[@"data"][@"list"];
    
    for (NSDictionary *dic in list)
    {
        SFSInfotainmentModel *model = [SFSInfotainmentModel modelWithDictionAry:dic];
        
        [self.listDataSource addObject:model];
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
    
    return self.listDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFSInfotainmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.listDataSource[indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kInfotainmentCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFSInfotainmentModel *model = self.listDataSource[indexPath.row];
    
    [self changeToInfotainmentDetailViewControllerWithPicId:model.picId];
}
#pragma mark - 界面跳转
-(void)changeToInfotainmentDetailViewControllerWithPicId:(NSString *)picId
{
    SFSInfotainmentDetailViewController *infotainmentDetailViewController = [[SFSInfotainmentDetailViewController alloc] init];
    infotainmentDetailViewController.picId = picId;
    [self.navigationController pushViewController:infotainmentDetailViewController animated:YES];
}

@end
