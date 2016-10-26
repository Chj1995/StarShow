//
//  SFSInfotainmentModel.h
//  StarFashionShow
//
//  Created by qianfeng on 16/10/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWBaseModel.h"
@interface SFSInfotainmentModel : SWBaseModel

/**
 图片
 */
@property(nonatomic,strong)NSString *pic;

/**
 标题
 */
@property(nonatomic,strong)NSString *title;

/**
 Id
 */
@property(nonatomic,strong)NSString *picId;

/**
 阅读次数
 */
@property(nonatomic,strong)NSNumber *readnum;

@end
