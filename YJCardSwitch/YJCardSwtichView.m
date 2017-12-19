//
//  YJCardSwtichView.m
//  YJCardImageSwitch
//
//  Created by 包宇津 on 2017/12/19.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "YJCardSwtichView.h"
#import "YJSwitchFlowLayout.h"
#import "YJCardCell.h"

@interface YJCardSwtichView()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *_collectionView;
    CGFloat _dragStartX;
    CGFloat _dragEndX;
}

@end

@implementation YJCardSwtichView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    [self addCollectionView];
}

- (void)addCollectionView {
    [self addSubview:[UIView new]];
    YJSwitchFlowLayout *flowLayout = [[YJSwitchFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[YJCardCell class] forCellWithReuseIdentifier:NSStringFromClass([YJCardCell class])];
    _collectionView.userInteractionEnabled = true;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
}

#pragma mark -setter
- (void)setItems:(NSArray<YJCardItem *> *)items {
    _items = items;
    [_collectionView reloadData];
}

//cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    CGFloat dragMinDistance = self.bounds.size.width / 20.0f;
    if (_dragStartX - _dragEndX >= dragMinDistance) {
        _selectedIndex += 1;
    }else if (_dragEndX - _dragStartX >= dragMinDistance) {
        _selectedIndex -= 1;
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex < 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex > maxIndex ? maxIndex : _selectedIndex;
    [self scrollToCenter];
}

- (void)scrollToCenter {
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self performDelegateMethod];
}

- (void)performDelegateMethod {
    if (_delegate && [_delegate respondsToSelector:@selector(YJCardSwitchViewDidSelectAt:)]) {
        [_delegate YJCardSwitchViewDidSelectAt:_selectedIndex];
    }
}

#pragma mark -CollectionViewDelegate
//在不使用分页滚动的情况下需要手动计算当前选中位置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pagingEnabled)
        return;
    if (!_collectionView.visibleCells.count) {
        return;
    }
    if (!scrollView.isDragging) {
        return;
    }
    CGRect currentRect = _collectionView.bounds;
    currentRect.origin.x = _collectionView.contentOffset.x;
    for (YJCardCell *cardCell in _collectionView.visibleCells) {
        if (CGRectContainsRect(currentRect, cardCell.frame)) {
            NSInteger index = [_collectionView indexPathForCell:cardCell].row;
            if (index != _selectedIndex) {
                _selectedIndex = index;
            }
        }
    }
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pagingEnabled) {
        return;
    }
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self scrollToCenter];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJCardCell *cardCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJCardCell class]) forIndexPath:indexPath];
    cardCell.item = _items[indexPath.row];
    return cardCell;
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self performDelegateMethod];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self switchToIndex:selectedIndex animated:false];
}
@end
