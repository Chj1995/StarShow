//
//  ADModel.h
//  星橱
//
//  Created by qianfeng on 16/9/5.
//  Copyright © 2016年 陈辉金. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADModel : NSObject

/**
 *  图片
 */
@property(nonatomic,copy)NSString *picUrl;

/**
 图片id
 */
@property(nonatomic,copy)NSString *picId;

/**
 图片宽度
 */
@property(nonatomic,copy)NSString *picWidth;

/**
 图片高度
 */
@property(nonatomic,copy)NSString *picHeight;

@end
