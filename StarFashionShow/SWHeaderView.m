//
//  SWHeaderView.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWHeaderView.h"
#import "ADView.h"
#import "ADToolView.h"
#import "NSString+Size.h"

@interface SWHeaderView ()
{
    ADView *adView;
    ADToolView *adToolView;
    
}
@end
@implementation SWHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        __weak SWHeaderView *weekSelf = self;
        //广告栏
        adView = [[ADView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 160)];
        [adView creatPageControl];
        [adView createTimer];
        
        //跳转到帖子详情的回调
        [adView setRequestNetWorkingCallback:^(NSInteger picId) {
            [weekSelf requestDataFromNetWorkingCallbackWithPicId:picId];
        }];
        [self addSubview:adView];
        
        //工具栏
        adToolView = [[ADToolView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adView.frame), self.frame.size.width, 120)];
        //跳转到标签界面的回调
        [adToolView setAdToolViewRequestDataFromNetWorkingCallback:^(NSInteger picId) {
            [weekSelf changToTagViewCtrlWithPicId:picId];
        }];
        [self addSubview:adToolView];
    }
    return self;
}
#pragma mark - 跳转到帖子详情的回调
-(void)requestDataFromNetWorkingCallbackWithPicId:(NSInteger )picId
{
    if (_headerViewRequestDataFromNetWorkingCallback) {
        
        _headerViewRequestDataFromNetWorkingCallback(picId);
    }
}
#pragma mark - 跳转到标签界面的回调
-(void)changToTagViewCtrlWithPicId:(NSInteger )picId
{
    if (_headerViewChangeToTagViewCtrlCallback) {
        
        _headerViewChangeToTagViewCtrlCallback(picId);
    }
}

#pragma mark - setter方法
-(void)setAdArray:(NSArray *)adArray
{
    _adArray = adArray;
    
    adView.ADDataSource = (NSMutableArray *)_adArray;
}
-(void)setAdToolArray:(NSArray *)adToolArray
{
    _adToolArray = adToolArray;
    
    adToolView.ADToolArray = adToolArray;
}

@end
