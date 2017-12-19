//
//  YJCardSwtichView.h
//  YJCardImageSwitch
//
//  Created by 包宇津 on 2017/12/19.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJCardItem.h"
@protocol YJCardSwitchViewDelegte <NSObject>
@optional

- (void)YJCardSwitchViewDidSelectAt:(NSInteger)index;

@end

@interface YJCardSwtichView : UIView

//当前选中的item
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
//数据源
@property (nonatomic, strong) NSArray<YJCardItem *> *items;
@property (nonatomic, weak) id<YJCardSwitchViewDelegte> delegate;
@property (nonatomic, assign) BOOL pagingEnabled;

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;
@end
