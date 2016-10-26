//
//  SWPostDetailModel.h
//  StarWardrobes
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWBaseModel.h"
@interface SWPostDetailModelOne : SWBaseModel

/**
 用户图标
 */
@property(nonatomic,strong)NSString *userAvatar;

/**
 用户名
 */
@property(nonatomic,strong)NSString *username;

/**
 用户ID
 */
@property(nonatomic,strong)NSString *userId;

/**
 发布时间
 */
@property(nonatomic,strong)NSString *datatime;

/**
 title
 */
@property(nonatomic,strong)NSString *title;

@end
