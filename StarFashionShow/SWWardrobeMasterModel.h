//
//  SWWardrobeMasterModel.h
//  StarWardrobes
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWBaseModel.h"
@interface SWWardrobeMasterModel : SWBaseModel

/**
 用户头像
 */
@property(nonatomic,copy)NSString *userAvatar;
/**
 用户名
 */
@property(nonatomic,copy)NSString *userName;
/**
 用户职业
 */
@property(nonatomic,copy)NSString *userTypeName;
/**
 用户图片
 */
@property(nonatomic,strong)NSMutableArray *pics;

/**
 图片Id
 */
@property(nonatomic,strong)NSString *picId;

@end
