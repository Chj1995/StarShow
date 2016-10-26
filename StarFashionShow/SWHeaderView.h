//
//  SWHeaderView.h
//  StarWardrobes
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 跳转到标签界面的回调
 */
typedef void(^SWHeaderViewChangeToTagViewCtrlCallback)(NSInteger picId);
/**
 跳转到帖子详情界面，请求数据的回调
 */
typedef void(^SWHeaderViewRequestDataFromNetWorkingCallback)(NSInteger picId);

@interface SWHeaderView : UICollectionReusableView

/**
 跳转到标签界面的回调
 */
@property(nonatomic,copy)SWHeaderViewChangeToTagViewCtrlCallback headerViewChangeToTagViewCtrlCallback;
-(void)setHeaderViewChangeToTagViewCtrlCallback:(SWHeaderViewChangeToTagViewCtrlCallback)headerViewChangeToTagViewCtrlCallback;

/**
 跳转到帖子详情界面，请求数据的回调
 */
@property(nonatomic,copy)SWHeaderViewRequestDataFromNetWorkingCallback headerViewRequestDataFromNetWorkingCallback;
-(void)setHeaderViewRequestDataFromNetWorkingCallback:(SWHeaderViewRequestDataFromNetWorkingCallback)headerViewRequestDataFromNetWorkingCallback;

/**
 广告栏数组
 */
@property(nonatomic,strong)NSArray *adArray;
/**
 工具栏数组
 */
@property(nonatomic,strong)NSArray *adToolArray;


@end
