//
//  ADView.h
//  ADView
//
//  Created by qianfeng on 16/9/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 选中图片跳转到帖子详情的回调
 */
typedef void(^ADViewRequestNetWorkingCallback)(NSInteger picId);

@interface ADView : UIView

/**
 选中图片跳转到帖子详情的回调
 */
@property(nonatomic,copy)ADViewRequestNetWorkingCallback requestNetWorkingCallback;
-(void)setRequestNetWorkingCallback:(ADViewRequestNetWorkingCallback)requestNetWorkingCallback;

/**
 数据源
 */
@property(nonatomic,strong)NSMutableArray *ADDataSource;

/**
 *  创建页数
 *
 */
-(void)creatPageControl;
/**
 *  创建定时器
 *
 */
-(void)createTimer;

@end
