//
//  SWPostDetailViewController.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/28.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWPostDetailViewController.h"
#import "NSString+Size.h"
#import "HttpRequest.h"
#import "SWPostDetailModelOne.h"
#import "SWPostDetailModelTwo.h"
#import "SWPostDetailModelTwoFrame.h"
#import "SWPostDetailCellOne.h"
#import "SWPostDetailCellTwo.h"
#import "MJRefresh.h"
#import "SWNavigationBarView.h"
#import "AFNetworkReachabilityManager.h"

/**
 背景颜色
 */
#define kBackColor [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
@interface SWPostDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //背景图
    UIView *subView;
    //导航栏
    SWNavigationBarView *navigationBarView;
    
    UIButton *button;
    UILabel *label;
}

@property(nonatomic,weak)UITableView *tableView;

/**
 数据源
 */
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation SWPostDetailViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBarView.frame)+1, subView.frame.size.width, subView.frame.size.height - CGRectGetMaxY(navigationBarView.frame)) style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [subView addSubview:tableView];
        
        [tableView registerClass:[SWPostDetailCellOne class] forCellReuseIdentifier:@"postDetailCellOne"];
        [tableView registerClass:[SWPostDetailCellTwo class] forCellReuseIdentifier:@"postDetailCellTwo"];
        
        tableView.mj_header = [self header];
        
        _tableView = tableView;
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
/**
 下拉刷新
 */
- (MJRefreshNormalHeader *)header
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestDataFromNetWorking];
    }];
    
    //隐藏上次刷新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    return header;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupButtonAndLabel];
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable) {
            
            /**
             请求最新界面物品网络数据
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
    
    __weak SWPostDetailViewController *weekSelf = self;
    
    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    subView.backgroundColor = kBackColor;
    [self.view addSubview:subView];
    
    navigationBarView = [[SWNavigationBarView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 50)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [navigationBarView setNavigationBarViewGoToBackCallback:^{
        
        [weekSelf goToBack];
    }];
    [navigationBarView setupTitleLableWithTitle:@"帖子详情" TitleSize:19];
    [subView addSubview:navigationBarView];
    
}
#pragma mark - 按钮点击事件
-(void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 请求网络数据
-(void)requestDataFromNetWorking
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://api-v2.mall.hichao.com/forum/post-new?ga=%2Fforum%2Fpost-new&"];
    [urlStr appendFormat:@"id=%ld",self.picId];
    
    [HttpRequest GET:urlStr paramters:nil success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        [self handleDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
        [self setupFailRequestDataFromNetWorking];
    }];
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    [self.dataSource removeAllObjects];
    
    NSDictionary *data = responseObject[@"response"][@"data"];
    
    SWPostDetailModelOne *modelOne = [SWPostDetailModelOne modelWithDictionAry:data[@"user"]];
    
    modelOne.title = data[@"title"];
    [self.dataSource addObject:modelOne];
    
    NSArray *items = data[@"items"];
    
    for (int i = 0; i < items.count; i+=2) {
        
        SWPostDetailModelTwo *modelTwo = [[SWPostDetailModelTwo alloc] init];
        
        if (items[i][@"component"][@"text"]) {
            
            modelTwo.text = items[i][@"component"][@"text"];
            if (i < items.count - 1)
            {
                modelTwo.picUrl = items[i+1][@"component"][@"picUrl"];
                modelTwo.picWidth = items[i+1][@"height"];
                modelTwo.picHeight = items[i+1][@"width"];
            }
        }else
        {
            modelTwo.picUrl = items[i][@"component"][@"picUrl"];
            modelTwo.picWidth = items[i][@"height"];
            modelTwo.picHeight = items[i][@"width"];
            
            if (i < items.count - 1)
            {
                modelTwo.text = items[i+1][@"component"][@"text"];
            }
        }
        
        SWPostDetailModelTwoFrame *modelTwoFrame = [[SWPostDetailModelTwoFrame alloc] init];
        modelTwoFrame.modelTwo = modelTwo;
        [self.dataSource addObject:modelTwoFrame];
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
    
    UITableViewCell *cell;
    
    if (indexPath.item == 0) {
        
        SWPostDetailCellOne *postDetailCellOne = [tableView dequeueReusableCellWithIdentifier:@"postDetailCellOne"];
        postDetailCellOne.selectionStyle = UITableViewCellSelectionStyleNone;
        postDetailCellOne.model = self.dataSource[indexPath.item];
        cell = postDetailCellOne;
    }else
    {
        SWPostDetailCellTwo *postDetailCellTwo = [tableView dequeueReusableCellWithIdentifier:@"postDetailCellTwo"];
        postDetailCellTwo.modelTwoFrame = self.dataSource[indexPath.item];
        postDetailCellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = postDetailCellTwo;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        return 70;
    }
    
    SWPostDetailModelTwoFrame *modelTwoFrame = self.dataSource[indexPath.item];
    return modelTwoFrame.cellHeight;
}

@end
