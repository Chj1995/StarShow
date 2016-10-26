//
//  ADToolModel.h
//  ADToolView
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADToolModel : NSObject

/**
 图片
 */
@property(nonatomic,copy)NSString *picUrl;

/**
 标题
 */
@property(nonatomic,copy)NSString *title;

/**
 图片id
 */
@property(nonatomic,copy)NSString *picId;

@end
