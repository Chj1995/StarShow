//
//  SWFashionGoodsCell.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWFashionGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"

@interface SWFashionGoodsCell ()
{
    //物品图片
    UIImageView *imageView;
    //物品描述
    UILabel *contentLabel;
    //用户图标
    UIImageView *userIcon;
    //用户昵称
    UILabel *userNameLabel;
    //收藏数
    UIButton *collectButton;
}
@end
@implementation SWFashionGoodsCell

-(void)setGoodsModel:(SWGoodsModel *)goodsModel
{
    [imageView removeFromSuperview];
    [contentLabel removeFromSuperview];
    [userIcon removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [collectButton removeFromSuperview];
    
    _goodsModel = goodsModel;
    
    //1.物品图片
    [self setGoodsImage];
    
    //2.物品描述
    [self setGoodsContent];
  
    //3.用户头像
    [self setUserIcon];
    
    //4.用户昵称
    [self setUserName];
    
    //5.收藏数
    [self setCollectCount];
}

/**
 1.物品图片
 */
-(void)setGoodsImage
{
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.pics] placeholderImage:[UIImage imageNamed:@"photo"]];
    
    [self.contentView addSubview:imageView];
}

/**
 2.物品描述
 */
-(void)setGoodsContent
{
    contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(5, self.frame.size.height - 40, self.frame.size.width - 5, 20);
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.text = _goodsModel.content;
    [self.contentView addSubview:contentLabel];;
}

/**
 3.用户图标
 */
-(void)setUserIcon
{
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(contentLabel.frame), 20, 20)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",_goodsModel.userAvatar]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [userIcon sd_setImageWithURL:[NSURL URLWithString:_goodsModel.userAvatar] placeholderImage:[UIImage imageWithData:data]];
        });
    });
    userIcon.layer.cornerRadius = 10;
    userIcon.clipsToBounds = YES;
    [self.contentView addSubview:userIcon];
}

/**
 4.用户昵称
 */
-(void)setUserName
{
    CGSize userNameSize = [_goodsModel.username sizeWithFontSize:13 maxSize:CGSizeMake(80, MAXFLOAT)];
    
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.frame = CGRectMake(CGRectGetMaxX(userIcon.frame)+2, CGRectGetMinY(userIcon.frame), userNameSize.width, 20);
    userNameLabel.font = [UIFont systemFontOfSize:13];
    userNameLabel.text = _goodsModel.username;
    userNameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:userNameLabel];

}

/**
 5.收藏数
 */
-(void)setCollectCount
{
    CGSize collectSize = [_goodsModel.collect_count sizeWithFontSize:13 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UIImage *image = [UIImage imageNamed:@"buttom_community_like"];
    CGSize imageSize = image.size;
    
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonWidth = collectSize.width + imageSize.width;
    CGFloat buttonHeight = 20;
    collectButton.frame = CGRectMake(self.frame.size.width - buttonWidth - 5, CGRectGetMinY(userNameLabel.frame), buttonWidth, buttonHeight);
    collectButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [collectButton setTitle:_goodsModel.collect_count forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"buttom_community_like"] forState:UIControlStateNormal];
    [collectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:collectButton];
}
@end
