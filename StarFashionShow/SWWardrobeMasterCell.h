//
//  SWWardrobeMasterCell.h
//  StarWardrobes
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWWardrobeMasterModel.h"


/**
 跳转到帖子详情界面的回调
 */
typedef void(^SWWardrobeMasterCellChangeToDetailViewCtrlCallback)(NSInteger picId);
@interface SWWardrobeMasterCell : UITableViewCell

@property(nonatomic,strong)SWWardrobeMasterModel *model;
/**
 跳转到帖子详情界面的回调
 */
@property(nonatomic,copy)SWWardrobeMasterCellChangeToDetailViewCtrlCallback wardrobeMasterCellChangeToDetailViewCtrlCallback;
-(void)setWardrobeMasterCellChangeToDetailViewCtrlCallback:(SWWardrobeMasterCellChangeToDetailViewCtrlCallback)wardrobeMasterCellChangeToDetailViewCtrlCallback;

@end
