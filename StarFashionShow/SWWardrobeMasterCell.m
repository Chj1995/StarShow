//
//  SWWardrobeMasterCell.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWWardrobeMasterCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"
#import "SFSConfig.h"
#import "SWWardrobeMasterPicsView.h"

@interface SWWardrobeMasterCell ()
{
    //用户图标
    UIImageView *userIcon;
    //用户昵称
    UILabel *userNameLabel;
    //用户职业
    UILabel *userTypeNameLabel;
    //关注按钮
    UIButton *attentionButton;
    //设置用户图片
    SWWardrobeMasterPicsView *picsView;
   
}

@end
@implementation SWWardrobeMasterCell

-(void)setModel:(SWWardrobeMasterModel *)model
{
    [userIcon removeFromSuperview];
    [userNameLabel removeFromSuperview];
    [userTypeNameLabel removeFromSuperview];
    [attentionButton removeFromSuperview];
    [picsView removeFromSuperview];
    
    _model = model;
    
    //1.设置用户图标
    [self setUserIcon];
    
    //2.设置用户昵称
    [self setupUserName];
    
    //3.设置用户职业
    [self setupuserTypeName];
    
    
    //4.设置用户图片
    [self setupPics];
}

/**
 1.设置用户图标
 */
-(void)setUserIcon
{
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10 , 30, 30)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg",_model.userAvatar]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [userIcon sd_setImageWithURL:[NSURL URLWithString:_model.userAvatar] placeholderImage:[UIImage imageWithData:data]];
        });
    });
    userIcon.layer.cornerRadius = 15;
    userIcon.clipsToBounds = YES;
    [self.contentView addSubview:userIcon];
}
/**
 2.设置用户昵称
 */
-(void)setupUserName
{
    CGSize userNameSize = [_model.userName sizeWithFontSize:15 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.frame = CGRectMake(CGRectGetMaxX(userIcon.frame)+5, CGRectGetMinY(userIcon.frame) - userNameSize.height/2, userNameSize.width, 20);
    userNameLabel.font = [UIFont systemFontOfSize:15];
    userNameLabel.text = _model.userName;
    userNameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:userNameLabel];
}

/**
 3.设置用户职业
 */
-(void)setupuserTypeName
{
    CGSize userTypeNameSize = [_model.userTypeName sizeWithFontSize:13 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    userTypeNameLabel = [[UILabel alloc] init];
    userTypeNameLabel.frame = CGRectMake(CGRectGetMaxX(userIcon.frame)+5, CGRectGetMaxY(userIcon.frame) - userTypeNameSize.height/2, userTypeNameSize.width, 20);
    userTypeNameLabel.font = [UIFont systemFontOfSize:13];
    userTypeNameLabel.text = _model.userTypeName;
    userTypeNameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:userTypeNameLabel];
}

/**
 5.设置用户图片
 */
-(void)setupPics
{
    __weak SWWardrobeMasterCell *weekSelf = self;
    
    CGFloat width = kScreenWidth - 20;
    CGFloat height = 110;
    picsView = [[SWWardrobeMasterPicsView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(userIcon.frame) + 20, width, height)];
    picsView.backgroundColor = [UIColor redColor];
    picsView.picsArray = _model.pics;
    [picsView setWardrobeMasterPicsViewChangeToDetailCallBack:^(NSInteger picId) {
       
        [weekSelf cellImagesCallBackWithPicId:picId];
    }];
    [self.contentView addSubview:picsView];
}
#pragma mark - 关注按钮的点击事件
-(void)cellImagesCallBackWithPicId:(NSInteger)picId
{
    if (_wardrobeMasterCellChangeToDetailViewCtrlCallback) {
        
        _wardrobeMasterCellChangeToDetailViewCtrlCallback(picId);
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
