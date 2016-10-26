//
//  SFSInfotainmentDetailCell.m
//  StarFashionShow
//
//  Created by qianfeng on 16/10/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SFSInfotainmentDetailCell.h"
#import "SFSConfig.h"
#import "UIImageView+WebCache.h"
@interface SFSInfotainmentDetailCell ()
{
    UIImageView *titleImageView;
    UIImageView *srcImageView;
    UILabel *titleLabel;
    UILabel *descLabel;
}
@end
@implementation SFSInfotainmentDetailCell

-(void)setModel:(SFSInfotainmentDetailModel *)model
{
    [titleImageView removeFromSuperview];
    [titleLabel removeFromSuperview];
    [descLabel removeFromSuperview];
    [srcImageView removeFromSuperview];
    
    _model = model;
    
    if (_model.img.length != 0)
    {//标题
        [self setupTitleImageView];
        [self setupTitleLabel];
        [self setupDescLabel];
    }
    
    if (_model.src.length != 0)
    {
        //内容
        [self setupSrcImageView];
    }
}

/**
 标题图片
 */
-(void)setupTitleImageView
{
    titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/1.5)];
    NSRange rang = [_model.img rangeOfString:@"!"];
    NSString *picName = [_model.img substringToIndex:rang.location];
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:picName] placeholderImage:[UIImage imageNamed:@"photo"]];
    titleImageView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:titleImageView];
}

/**
 标题
 */
-(void)setupTitleLabel
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleImageView.frame) + 5, kScreenWidth - 20, 60)];
    titleLabel.text = _model.title;
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
}

/**
 描述
 */
-(void)setupDescLabel
{
    descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 5, kScreenWidth - 20, 20)];
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.text = [NSString stringWithFormat:@"%@   %@",_model.username,_model.publish_time];
    descLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:descLabel];
}

/**
 内容图片
 */
-(void)setupSrcImageView
{
    CGFloat picWidth = _model.width.floatValue;
    CGFloat picHeight = _model.height.floatValue;
    
    srcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 20, kScreenWidth * (picHeight/picWidth) - 10)];
    NSRange rang = [_model.src rangeOfString:@"!"];
    NSString *picName = [_model.src substringToIndex:rang.location];
    [srcImageView sd_setImageWithURL:[NSURL URLWithString:picName] placeholderImage:[UIImage imageNamed:@"photo"]];
    [self.contentView addSubview:srcImageView];
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
