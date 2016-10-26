//
//  ADToolCell.m
//  ADToolView
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "ADToolCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"

@interface ADToolCell ()
{

    UIImageView *imageView;
    UILabel *descLabel;
    
}

@end
@implementation ADToolCell


-(void)setAdtoolModel:(ADToolModel *)adtoolModel
{
    [imageView removeFromSuperview];
    [descLabel removeFromSuperview];
    
    _adtoolModel = adtoolModel;
    
    
    //1.创建图片
    [self setupImageView];
    
    //2.创建文本标签
    [self setupDescLabel];
    
}
-(void)setupImageView
{
    imageView = [[UIImageView alloc] init];
    
    imageView.frame = self.bounds;
    [self.contentView addSubview:imageView];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:_adtoolModel.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
}
-(void)setupDescLabel
{
    descLabel = [[UILabel alloc] init];
    
    CGSize descSize = [_adtoolModel.title sizeWithFontSize:15 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    descLabel.frame  =CGRectMake(CGRectGetMaxX(imageView.frame)/2 - descSize.width/2, CGRectGetMaxY(imageView.frame) - 22, descSize.width, 20);
    descLabel.text = _adtoolModel.title;
    descLabel.font = [UIFont systemFontOfSize:15];
    descLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:descLabel];
}
@end
