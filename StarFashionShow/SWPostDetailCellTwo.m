//
//  postDetailCellTwo.m
//  PostDetail
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWPostDetailCellTwo.h"
#import "SWPostDetailModelTwo.h"
#import "UIImageView+WebCache.h"

@interface SWPostDetailCellTwo ()
{
    UILabel *textLabel;
    
    UIImageView *imageView;
    
    SWPostDetailModelTwo *modelTwo;
}


@end
@implementation SWPostDetailCellTwo

-(void)setModelTwoFrame:(SWPostDetailModelTwoFrame *)modelTwoFrame
{
    [textLabel removeFromSuperview];
    [imageView removeFromSuperview];
    
    _modelTwoFrame = modelTwoFrame;
    
    modelTwo = modelTwoFrame.modelTwo;
    
    //1.设置text
    [self setupText];
    
    if (modelTwo.picUrl) {
        //2.设置图片
        [self setupPic];
    }
    
}

/**
 1.设置text
 */
-(void)setupText
{
    textLabel = [[UILabel alloc] init];
    textLabel.frame = _modelTwoFrame.textRect;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.text = modelTwo.text;
    [self.contentView addSubview:textLabel];
}

/**
 创建图片
 */
-(void)setupPic
{
    imageView = [[UIImageView alloc]init];
    imageView.frame = _modelTwoFrame.picUrlRect;
    [imageView sd_setImageWithURL:[NSURL URLWithString:modelTwo.picUrl] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:imageView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
