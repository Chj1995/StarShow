//
//  ADCell.m
//  ADView
//
//  Created by qianfeng on 16/9/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "ADCell.h"
#import "UIImageView+WebCache.h"


@interface ADCell ()
{
    UIImageView *imageView;
}

@end

@implementation ADCell

-(void)setAdModel:(ADModel *)adModel
{
    [imageView removeFromSuperview];
    
    _adModel = adModel;

    imageView = [[UIImageView alloc] init];

    imageView.frame = self.bounds;
    [self.contentView addSubview:imageView];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:adModel.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
}

@end
