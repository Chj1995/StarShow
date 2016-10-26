//
//  ADToolView.m
//  ADToolView
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "ADToolView.h"
#import "ADToolCell.h"
#import "ADToolModel.h"

//按钮的宽度
#define kitemWidth (self.frame.size.width - kitemSpace * 4)/3.0

//按钮距离父视图左右的距离
#define kitemPadding 10
//按钮之间的空隙
#define kitemSpace 5

@interface ADToolView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,weak)UICollectionView *ADToolCollectionView;

@end

@implementation ADToolView
#pragma mark - 懒加载
-(UICollectionView *)ADToolCollectionView
{
    if (!_ADToolCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        //cell距离父视图上下左右的距离
        layout.sectionInset = UIEdgeInsetsMake(0, kitemPadding, 0, kitemPadding);
        
        layout.minimumLineSpacing = kitemSpace;
        layout.minimumInteritemSpacing = kitemSpace;
        
        layout.sectionInset = UIEdgeInsetsMake(0, kitemSpace, 0, kitemSpace);
        
        //设置Cell的大小
        layout.itemSize = CGSizeMake(kitemWidth, (self.frame.size.height - kitemSpace)/2);
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        //关闭下滑线
        collectionView.showsHorizontalScrollIndicator = NO;
        
        //关闭弹簧效果
        collectionView.bounces = NO;
        
        collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:collectionView];
        
        [collectionView registerClass:[ADToolCell class] forCellWithReuseIdentifier:@"ADToolCell"];
        
        _ADToolCollectionView = collectionView;
        
    }
    return _ADToolCollectionView;
}
#pragma mark - setter方法
-(void)setADToolArray:(NSArray *)ADToolArray
{
    _ADToolArray = ADToolArray;
    
    [self.ADToolCollectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _ADToolArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADToolCell" forIndexPath:indexPath];
    
    cell.adtoolModel = _ADToolArray[indexPath.item];
    
    return cell;
}
#pragma mark - 跳转到标签页面的回调
-(void)requestFromNetWorkingWithPicId:(NSInteger)picId
{
    if (_adToolViewRequestDataFromNetWorkingCallback) {
        
        _adToolViewRequestDataFromNetWorkingCallback(picId);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak ADToolView *weekSelf  = self;
    
    ADToolModel *model = _ADToolArray[indexPath.item];
    
    [weekSelf requestFromNetWorkingWithPicId:[model.picId integerValue]];
}

@end
