//
//  YJSwitchFlowLayout.m
//  YJCardImageSwitch
//
//  Created by 包宇津 on 2017/12/19.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "YJSwitchFlowLayout.h"

//居中时候卡片宽度与屏幕宽度比例
static float CardWidthScale = 0.7f;
static float CardHeightScale = 0.8f;

@implementation YJSwitchFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
}

- (CGFloat)collectionInset {
    return self.collectionView.bounds.size.width/2.0f - [self cellWidth] / 2.0f;
}

//卡片宽度
- (CGFloat)cellWidth {
    return self.collectionView.bounds.size.width * CardWidthScale;
}

//卡片间隔
- (CGFloat)cellMargin {
    return (self.collectionView.bounds.size.width - [self cellWidth]) / 7;
}

- (CGFloat)minimumLineSpacing {
    return [self cellMargin];
}

- (CGSize)itemSize {
    return CGSizeMake([self cellWidth], self.collectionView.bounds.size.height * CardHeightScale);
}
//设置缩放动画效果
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //扩大控制范围,防止出现闪屏现象
    CGRect bigRect = rect;
    bigRect.size.width = rect.size.width + 2 * [self cellWidth];
    bigRect.origin.x = rect.origin.x - [self cellWidth];
    
    NSArray *arr = [self getCopyOfAttributes:[super layoutAttributesForElementsInRect:bigRect]];
    //屏幕中心
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0f;
    //cell缩放
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        CGFloat distance = fabs(attribute.center.x - centerX);
        CGFloat apartScale = distance/self.collectionView.bounds.size.width;
        CGFloat scale = fabs(apartScale * M_PI_4);
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
//防止报错，先复制attributes
- (NSArray *)getCopyOfAttributes:(NSArray *)attributes {
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}
@end
