//
//  SFSInfotainmentDetailModel.h
//  StarFashionShow
//
//  Created by qianfeng on 16/10/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWBaseModel.h"
@interface SFSInfotainmentDetailModel : SWBaseModel

/**
 图片
 */
@property(nonatomic,strong)NSString *img;

/**
 标题
 */
@property(nonatomic,strong)NSString *title;

/**
 头像
 */
@property(nonatomic,strong)NSString *avator;

/**
 昵称
 */
@property(nonatomic,strong)NSString *username;

/**
 发布时间
 */
@property(nonatomic,strong)NSString *publish_time;

/**
 内容图片
 */
@property(nonatomic,strong)NSString *src;

/**
 内容图片高度
 */
@property(nonatomic,strong)NSNumber *height;

/**
 内容图片宽度
 */
@property(nonatomic,strong)NSNumber *width;

@end
