//
//  SFSBaseTabBarViewController.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSBaseTabBarViewController.h"
#import "SFSConfig.h"



@interface SFSBaseTabBarViewController ()

@end

@implementation SFSBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kAppTintColor} forState:UIControlStateSelected];
    
    self.tabBar.translucent = NO;
    
    [self initChildrenController];
}

-(void)initChildrenController
{
    NSArray *ctrlNames = @[@"SFSReachPeopleViewController",
                           @"SFSFashionCycleViewController",
                           @"SFSLatestViewController",
                           @"SFSInfotainmentViewController"];
    
    NSArray *titles = @[@"达人",@"时尚圈",@"最新",@"娱乐资讯"];
    
    NSArray *normalImageNames = @[@"buttom_class",
                                  @"buttom_home",
                                  @"buttom_bbs",
                                  @"buttom_massage"];
    
    NSArray *selectedImageNames = @[@"buttom_class_on",
                                    @"buttom_home_on",
                                    @"buttom_bbs_on",
                                    @"buttom_massage_on"];
    
    [ctrlNames enumerateObjectsUsingBlock:^(NSString *ctrlName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *ctrl = [[NSClassFromString(ctrlName) alloc] init];
        ctrl.title = titles[idx];
        ctrl.tabBarItem.image = [UIImage imageNamed:normalImageNames[idx]];
        ctrl.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNames[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addChildViewController:ctrl];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
