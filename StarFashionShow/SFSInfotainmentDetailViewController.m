//
//  SFSInfotainmentDetailViewController.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSInfotainmentDetailViewController.h"
#import "SWNavigationBarView.h"
#import "HttpRequest.h"
#import "SFSInfotainmentDetailModel.h"
#import "SFSInfotainmentDetailCell.h"
#import "SFSConfig.h"
#import "AFNetworkReachabilityManager.h"

@interface SFSInfotainmentDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SWNavigationBarView *navigationBarView;
    
    UIButton *button;
    UILabel *label;
}

@property(nonatomic,weak)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation SFSInfotainmentDetailViewController
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight - 70) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //注册cell
        [tableView registerClass:[SFSInfotainmentDetailCell class] forCellReuseIdentifier:@"cell"];
        
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
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //自定义导航栏
    [self setupNavigationBar];
    
    [self setupButtonAndLabel];
    //判断有无网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status != AFNetworkReachabilityStatusNotReachable)
        {
            
            //请求网络数据
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
#pragma mark - 请求网络数据
-(void)requestDataFromNetWorking
{
    [HttpRequest GET:[NSString stringWithFormat:@"http://api.app.happyjuzi.com/article/detail?id=%@&uid=4033812942430866&res=1080x1920&pf=android&accesstoken=c05ab7a9dd7b9251051a0eb240dd79c1&mac=0c-1d-af-d9-f0-5b&ver=3.4&net=wifi&channel=yingyongbao",self.picId] paramters:nil success:^(id responseObject) {
        
        [self handleDataWithObject:responseObject];
        
    } failure:^(NSError *error) {
        
        [self setupFailRequestDataFromNetWorking];
    }];
}
#pragma mark - 封装数据
-(void)handleDataWithObject:(id)responseObject
{
    NSDictionary *info = responseObject[@"data"][@"info"];
    SFSInfotainmentDetailModel *model = [SFSInfotainmentDetailModel modelWithDictionAry:info];
    model.avator = info[@"author"][@"avator"];
    model.username = info[@"author"][@"username"];
    [self.dataSource addObject:model];
                                         
    NSArray *IMGArray = responseObject[@"data"][@"resources"][@"IMG"];
   
    for (NSDictionary *dic in IMGArray)
    {
        SFSInfotainmentDetailModel *detailModel = [SFSInfotainmentDetailModel modelWithDictionAry:dic];
        [self.dataSource addObject:detailModel];
    }
    [self.tableView reloadData];
}
#pragma mark - 创建自定义导航栏
/**
 1.创建自定义导航栏
 */
-(void)setupNavigationBar
{
    
    __weak SFSInfotainmentDetailViewController *weekSelf = self;
    
    navigationBarView = [[SWNavigationBarView alloc] initWithFrame:CGRectMake(0,20, self.view.frame.size.width, 50)];
    navigationBarView.backgroundColor = [UIColor whiteColor];
    [navigationBarView setNavigationBarViewGoToBackCallback:^{
        
        [weekSelf goToBack];
    }];
    [navigationBarView setupTitleLableWithTitle:@"帖子详情" TitleSize:19];
    [self.view addSubview:navigationBarView];
    
}
#pragma mark - 按钮点击事件
-(void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    SFSInfotainmentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height;
    
    if (indexPath.row == 0) {
        
        height = kScreenWidth/1.5 + 100;
        
    }
    else
    {
        SFSInfotainmentDetailModel *detailModel = self.dataSource[indexPath.row];
        
        CGFloat picWidth = detailModel.width.floatValue;
        CGFloat picHeight = detailModel.height.floatValue;
        
        height = kScreenWidth * (picHeight/picWidth);
    }
    return height;
}
@end
