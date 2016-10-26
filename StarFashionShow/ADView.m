//
//  ADView.m
//  ADView
//
//  Created by qianfeng on 16/9/23.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "ADView.h"
#import "ADCell.h"

@interface ADView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    //页数点
    UIPageControl *pageControl;
    //滚动到的行数
    NSInteger num;
    
}
@property(nonatomic,weak)UICollectionView *ADCollectionView;

@property(nonatomic,strong)NSTimer *timer;

@end
@implementation ADView
#pragma mark - 懒加载
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _ADDataSource = [NSMutableArray array];
    }
    return self;
}
-(UICollectionView *)ADCollectionView
{
    if (!_ADCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        //横向滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //设置Cell的大小
        layout.itemSize = self.frame.size;
        
        //清空行距
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        //关闭下滑线
        collectionView.showsHorizontalScrollIndicator = NO;
        
        //关闭弹簧效果
        collectionView.bounces = NO;
        
        //开启翻页模式
        collectionView.pagingEnabled = YES;
        
        collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:collectionView];
        
        [self bringSubviewToFront:pageControl];
        
        [collectionView registerClass:[ADCell class] forCellWithReuseIdentifier:@"ADCell"];
        
        _ADCollectionView = collectionView;
        
    }
    return _ADCollectionView;
}
/**
 *  创建页数
 *
 */
-(void)creatPageControl
{
    [pageControl removeFromSuperview];
    
    pageControl = [[UIPageControl alloc]init];
    pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    pageControl.tag = 1000;
    
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:pageControl];
}

#pragma mark - setter方法
-(void)setADDataSource:(NSMutableArray *)ADDataSource
{
    [_ADDataSource removeAllObjects];
    [_ADDataSource addObjectsFromArray:ADDataSource];
  
    if (_ADDataSource.count == 0)
    {
        return;
    }
    [_ADDataSource addObject:ADDataSource.firstObject];
    
    //1.刷新
    [self.ADCollectionView reloadData];
    
}

#pragma mark - 创建定时器
-(void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeImageView) userInfo:nil repeats:YES];
}
#pragma mark - 切换图片
-(void)changeImageView
{
    num++;
    
    if (num >= _ADDataSource.count - 1)
    {
        num = 0;
        //当滚动到最后一张图片时，回滚到开头不采用动画
        [self scrollToItem:num animated:NO];
    }else
    {
        //滚动到指定的图片
        [self scrollToItem:num animated:YES];
    }
}

#pragma mark - 滚动到指定的图片
-(void)scrollToItem:(NSInteger)index animated:(BOOL)animated
{
    
    if (_ADDataSource.count < 2) {
        return;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.ADCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    pageControl.numberOfPages = _ADDataSource.count - 1;
    
    return _ADDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ADCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADCell" forIndexPath:indexPath];
    
    cell.adModel = _ADDataSource[indexPath.item];
    
    return cell;
}

#pragma mark - 滚动时会触发
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.ADCollectionView.contentOffset;
    
    NSInteger page = offset.x / CGRectGetWidth(self.ADCollectionView.frame);
    
    pageControl.currentPage = page;
    
    num = page;
    
    if (page >= _ADDataSource.count - 1)
    {
        [self scrollToItem:0 animated:NO];
    }
}
-(void)requestNetWorkingWith:(NSInteger)picId
{
    if (_requestNetWorkingCallback) {
        
        _requestNetWorkingCallback(picId);
    }
}
#pragma mark - 选中触发
/**
 选中触发
 
 @param collectionView <#collectionView description#>
 @param indexPath      <#indexPath description#>
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak ADView *weekSelf = self;
    
    ADModel *model = _ADDataSource[indexPath.item];
    
    NSInteger picId = [model.picId integerValue];
    
    [weekSelf requestNetWorkingWith:picId];
    
}
@end
