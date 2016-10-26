//
//  ADToolView.h
//  ADToolView
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 跳转到标签页面的回调
 */
typedef void(^ADToolViewRequestDataFromNetWorkingCallback)(NSInteger picId);

@interface ADToolView : UIView
/**
 跳转到标签页面的回调
 */
@property(nonatomic,copy)ADToolViewRequestDataFromNetWorkingCallback adToolViewRequestDataFromNetWorkingCallback;
-(void)setAdToolViewRequestDataFromNetWorkingCallback:(ADToolViewRequestDataFromNetWorkingCallback)adToolViewRequestDataFromNetWorkingCallback;


@property(nonatomic,strong)NSArray *ADToolArray;
@end
