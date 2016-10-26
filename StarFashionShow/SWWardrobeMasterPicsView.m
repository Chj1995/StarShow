//
//  SWWardrobeMasterPicsView.m
//  StarWardrobes
//
//  Created by qianfeng on 16/9/27.
//  Copyright © 2016年 CHJ. All rights reserved.
//

#import "SWWardrobeMasterPicsView.h"
#import "ADCell.h"
#import "SFSConfig.h"
#import "ADModel.h"

@interface SWWardrobeMasterPicsView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,weak)UICollectionView *collectionView;

@end
@implementation SWWardrobeMasterPicsView
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UICollectionView *collectionVeiw = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        collectionVeiw.dataSource = self;
        collectionVeiw.delegate = self;
        collectionVeiw.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:collectionVeiw];
        
        [collectionVeiw registerClass:[ADCell class] forCellWithReuseIdentifier:@"cell"];
        
        _collectionView = collectionVeiw;
    }
    return _collectionView;
}
-(void)setPicsArray:(NSArray *)picsArray
{
    _picsArray = picsArray;
    
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _picsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.adModel = _picsArray[indexPath.item];
    return cell;
}
#pragma mark - cell的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 20)/3, self.frame.size.height);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADModel *mode = _picsArray[indexPath.item];
    
    if (_wardrobeMasterPicsViewChangeToDetailCallBack) {
        
        _wardrobeMasterPicsViewChangeToDetailCallBack([mode.picId integerValue]);
    }
    
}

@end
