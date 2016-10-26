//
//  SWWardrobeMasterPicsView.h
//  StarWardrobes
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 跳转到帖子详情的回调
 */
typedef void(^SWWardrobeMasterPicsViewChangeToDetailCallBack)(NSInteger picId);

@interface SWWardrobeMasterPicsView : UIView

/**
 跳转到帖子详情的回调
 */
@property(nonatomic,copy)SWWardrobeMasterPicsViewChangeToDetailCallBack wardrobeMasterPicsViewChangeToDetailCallBack;
-(void)setWardrobeMasterPicsViewChangeToDetailCallBack:(SWWardrobeMasterPicsViewChangeToDetailCallBack)wardrobeMasterPicsViewChangeToDetailCallBack;

@property(nonatomic,strong)NSArray *picsArray;

@end
