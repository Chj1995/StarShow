//
//  SWGoodsModel.h
//  StarWardrobes
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWGoodsModel : NSObject

/**
 图片id
 */
@property(nonatomic,strong)NSString *picId;
/**
 图片
 */
@property(nonatomic,strong)NSString *pics;
/**
 内容
 */
@property(nonatomic,strong)NSString *content;
/**
 用户图标
 */
@property(nonatomic,strong)NSString *userAvatar;
/**
 用户名
 */
@property(nonatomic,strong)NSString *username;
/**
 收藏数
 */
@property(nonatomic,strong)NSString *collect_count;
/**
 图片宽度
 */
@property(nonatomic,strong)NSString *width;
/**
 图片高度
 */
@property(nonatomic,strong)NSString *height;

@end
