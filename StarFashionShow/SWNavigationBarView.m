//
//  SWNavigationBarView.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/30.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWNavigationBarView.h"
#import "NSString+Size.h"
#import "SFSConfig.h"

@interface SWNavigationBarView ()
{
    UIView *titleView;
}

@end
@implementation SWNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setupView];
    }
    return self;
}

/**
 创建导航栏视图
 */
-(void)setupView
{
   titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 50)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleView];
    
    //返回按钮
    UIImage *btnImage = [UIImage imageNamed:@"back_button"];
    CGSize imageSize = btnImage.size;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, titleView.frame.size.height/2 - imageSize.width/2, imageSize.width, imageSize.height);
    [backBtn setImage:btnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    //底部线条
    UIImageView *bkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1,kScreenWidth, 1)];
    bkImageView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bkImageView];
}

/**
 设置主题名

 @param title         <#title description#>
 @param titleFontSize <#titleFontSize description#>
 */
-(void)setupTitleLableWithTitle:(NSString *)title TitleSize:(CGFloat)titleFontSize
{
    CGSize titleSize = [title sizeWithFontSize:titleFontSize maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(titleView.frame.size.width/2 - titleSize.width/2, titleView.frame.size.height/2 - titleSize.height/2, titleSize.width, titleSize.height);
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
    [titleView addSubview:titleLabel];
    
    
}
-(void)goToBack
{
    if (_navigationBarViewGoToBackCallback) {
        
        _navigationBarViewGoToBackCallback();
    }
}

@end
