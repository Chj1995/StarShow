//
//  SWPostDetailModelTwoFrame.m
//  PostDetail
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWPostDetailModelTwoFrame.h"
#import "NSString+Size.h"
#import "SFSConfig.h"


@interface SWPostDetailModelTwoFrame ()

@end
@implementation SWPostDetailModelTwoFrame

-(void)setModelTwo:(SWPostDetailModelTwo *)modelTwo
{
    _modelTwo = modelTwo;
    
    CGSize textSize = [_modelTwo.text sizeWithFontSize:15 maxSize:CGSizeMake(kScreenWidth-20, MAXFLOAT)];
    
    
    CGFloat width = [_modelTwo.picWidth floatValue];
    CGFloat height = [_modelTwo.picHeight floatValue];
    
    CGFloat picHeight = kScreenWidth * (width/height);
    _textRect = CGRectMake(10, 0, textSize.width, textSize.height);
    _picUrlRect = CGRectMake(0, CGRectGetMaxY(_textRect)+5, kScreenWidth, picHeight);

    if (modelTwo.picUrl) {
        
        _cellHeight = CGRectGetMaxY(_picUrlRect);
    }else
    {
        _cellHeight = CGRectGetMaxY(_textRect);
    }
    
    
}

@end
