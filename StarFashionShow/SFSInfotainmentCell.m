//
//  SFSInfotainmentCell.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSInfotainmentCell.h"
#import "SFSConfig.h"
#import "NSString+Size.h"
#import "UIImageView+WebCache.h"
@interface SFSInfotainmentCell ()
{
    UIView *subView;
    UILabel *titleLabel;
    UIImageView *picImageView;
    UIImageView *signImageView;
    UILabel *signLabel;
    UIImageView *readImageView;
    UILabel *readLabel;
}
@end
@implementation SFSInfotainmentCell
-(void)setModel:(SFSInfotainmentModel *)model
{
    [subView removeFromSuperview];
    
    _model = model;
    //子视图
    [self setupSubView];
    //标题
    [self setupTitleLabel];
    //标志图片
    [self setupSignImageView];
    //阅读
    [self setupReadImageViewAndLabel];
    //图片
    [self setupPicImageView];
}

/**
 子视图
 */
-(void)setupSubView
{
    subView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, kInfotainmentCellHeight - 10)];
    subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subView];
}

/**
 标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10 - kInfotainmentCellHeight - 17, kInfotainmentCellHeight - 40)];
    titleLabel.numberOfLines = 4;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = _model.title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [subView addSubview:titleLabel];
}

/**
 标志图片
 */
-(void)setupSignImageView
{
    signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame) + 5, 25, 15)];
    signImageView.image = [UIImage imageNamed:@"new"];
    [subView addSubview:signImageView];
    
    signLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(titleLabel.frame)+2, 60, 20)];
    signLabel.text = @"娱乐资讯";
    signLabel.textColor = [UIColor lightGrayColor];
    signLabel.font = [UIFont systemFontOfSize:14];
    [subView addSubview:signLabel];
}

/**
 阅读图片和次数
 */
-(void)setupReadImageViewAndLabel
{
    readImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3, CGRectGetMaxY(titleLabel.frame)+2, 20, 20)];
    readImageView.image = [UIImage imageNamed:@"icon_feed_read"];
    [subView addSubview:readImageView];
    
    readLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(readImageView.frame) + 5, CGRectGetMaxY(titleLabel.frame)+2, 80, 20)];
    readLabel.font = [UIFont systemFontOfSize:14];
    readLabel.textColor = [UIColor lightGrayColor];
    readLabel.text = [NSString stringWithFormat:@"%@",_model.readnum];
    [subView addSubview:readLabel];
}
/**
 图片
 */
-(void)setupPicImageView
{
    CGFloat picWidth = kInfotainmentCellHeight + 7;
    CGFloat picHeight = kInfotainmentCellHeight - 5 - 5;
    picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - picWidth - 10, 0, picWidth, picHeight)];
    NSRange rang = [_model.pic rangeOfString:@"!"];
    NSString *picName = [_model.pic substringToIndex:rang.location];
    [picImageView sd_setImageWithURL:[NSURL URLWithString:picName] placeholderImage:[UIImage imageNamed:@"photo"]];
    [subView addSubview:picImageView];
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
