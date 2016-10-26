//
//  SWPostDetailModelTwoFrame.h
//  PostDetail
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWPostDetailModelTwo.h"
#import <CoreGraphics/CoreGraphics.h>

@interface SWPostDetailModelTwoFrame : NSObject

@property (nonatomic, strong)SWPostDetailModelTwo *modelTwo;

/**
 描述
 */
@property(nonatomic)CGRect textRect;

/**
 图片
 */
@property(nonatomic)CGRect picUrlRect;

/**
 *  cell的高度
 */
@property (nonatomic) CGFloat cellHeight;


@end
