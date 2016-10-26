//
//  postDetailCellOne.h
//  PostDetail
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPostDetailModelOne.h"



/**
 跳转到登录界面的回调
 */
typedef void(^SWPostDetailCellOneChnageToLoginViewCtrlCallback)(void);

@interface SWPostDetailCellOne : UITableViewCell

@property(nonatomic,strong)SWPostDetailModelOne *model;

/**
 跳转到登录界面的回调
 */
@property(nonatomic,copy)SWPostDetailCellOneChnageToLoginViewCtrlCallback postDetailCellOneChnageToLoginViewCtrlCallback;
-(void)setPostDetailCellOneChnageToLoginViewCtrlCallback:(SWPostDetailCellOneChnageToLoginViewCtrlCallback)postDetailCellOneChnageToLoginViewCtrlCallback;

@end
