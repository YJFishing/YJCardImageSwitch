//
//  YJCardCell.m
//  YJCardImageSwitch
//
//  Created by 包宇津 on 2017/12/19.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "YJCardCell.h"

@implementation YJCardCell{
    UIImageView *_imageView;
    UILabel *_textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelH = self.bounds.size.height * 0.2f;
    CGFloat imageViewH = self.bounds.size.height - labelH;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageViewH)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewH, self.bounds.size.width, labelH)];
    _textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    _textLabel.font = [UIFont systemFontOfSize:22];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_textLabel];
    
}

- (void)setItem:(YJCardItem *)item {
    _imageView.image = [UIImage imageNamed:item.imageName];
    _textLabel.text = item.title;
}
@end
