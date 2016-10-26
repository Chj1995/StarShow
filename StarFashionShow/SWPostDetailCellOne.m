//
//  postDetailCellOne.m
//  PostDetail
//
//  Created by qianfeng on 16/9/29.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWPostDetailCellOne.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"
#import "SFSConfig.h"

@interface SWPostDetailCellOne ()
{
    //用户图标
    UIImageView *userIcon;
    //用户昵称
    UILabel *userNameLabel;
    //发布时间
    UILabel *dataTimeLabel;
    //关注按钮
    UIButton *attentionButton;
}

@end
@implementation SWPostDetailCellOne
-(void)setModel:(SWPostDetailModelOne *)model
{
    [userIcon removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [dataTimeLabel removeFromSuperview];
    [attentionButton removeFromSuperview];
    
    _model = model;
    
    //1.设置用户图标
    [self setUserIcon];
    
    //2.设置用户昵称
    [self setupUserName];
    
    //3.设置发布时间
    [self setupdataTime];
    
    //4.设置关注按钮
//    [self setupAttentionButton];

    
}
/**
 1.设置用户图标
 */
-(void)setUserIcon
{
    
    CGFloat userIconWidth = 40;
    CGFloat userIconHeight = 40;
    
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 , userIconWidth, userIconHeight)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",_model.userAvatar]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userAvatar] placeholderImage:[UIImage imageWithData:data]];
        });
    });
    userIcon.layer.cornerRadius = userIconWidth/2;
    userIcon.clipsToBounds = YES;
    [self.contentView addSubview:userIcon];
}
/**
 2.设置用户昵称
 */
-(void)setupUserName
{
    CGSize userNameSize = [_model.username sizeWithFontSize:15 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.frame = CGRectMake(CGRectGetMaxX(userIcon.frame)+5, CGRectGetMinY(userIcon.frame) + userNameSize.height/4, userNameSize.width, 20);
    userNameLabel.font = [UIFont systemFontOfSize:15];
    userNameLabel.text = _model.username;
    userNameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:userNameLabel];
}

/**
 3.设置发布时间
 */
-(void)setupdataTime
{
    CGSize userTypeNameSize = [_model.datatime sizeWithFontSize:13 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    dataTimeLabel = [[UILabel alloc] init];
    dataTimeLabel.frame = CGRectMake(CGRectGetMaxX(userIcon.frame)+5, CGRectGetMaxY(userIcon.frame) - userTypeNameSize.height/1.5, userTypeNameSize.width, 20);
    dataTimeLabel.font = [UIFont systemFontOfSize:13];
    dataTimeLabel.text = _model.datatime;
    dataTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:dataTimeLabel];
}

/**
 4.设置关注按钮
 */
-(void)setupAttentionButton
{
    
    NSString *buttonLabelText = @"+关注";
    CGSize buttonLabelSize = [buttonLabelText sizeWithFontSize:14 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat width = buttonLabelSize.width+10;
    CGFloat height = buttonLabelSize.height;
    attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.frame = CGRectMake(kScreenWidth - width * 1.5, CGRectGetMinY(userIcon.frame) + height/2, width, height);
    attentionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [attentionButton setTitleColor:kAppTintColor forState:UIControlStateNormal];
    [attentionButton setTitle:buttonLabelText forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(setupAttentionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:attentionButton];
}
-(void)setupAttentionButtonClick
{
    if (_postDetailCellOneChnageToLoginViewCtrlCallback) {
        
        _postDetailCellOneChnageToLoginViewCtrlCallback();
    }
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
