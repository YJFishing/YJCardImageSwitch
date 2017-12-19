//
//  ViewController.m
//  YJCardImageSwitch
//
//  Created by 包宇津 on 2017/12/19.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "ViewController.h"
#import "YJCardSwtichView.h"

@interface ViewController () <YJCardSwitchViewDelegte> {
    YJCardSwtichView *_cardSwitch;
    UIImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"图片浏览";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一张" style:UIBarButtonItemStylePlain target:self action:@selector(switchPrevious)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一张" style:UIBarButtonItemStylePlain target:self action:@selector(switchNext)];
    [self addImageView];
    [self addCardSwitch];
}
- (void)switchPrevious {
    NSInteger index = _cardSwitch.selectedIndex - 1;
    index = index < 0 ? 0 : index;
    [_cardSwitch switchToIndex:index animated:YES];
    
}

- (void)switchNext {
    NSInteger index = _cardSwitch.selectedIndex + 1;
    index = index > _cardSwitch.items.count - 1 ? _cardSwitch.items.count -1 : index;
    [_cardSwitch switchToIndex:index animated:YES];
}

- (void)addImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_imageView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = _imageView.bounds;
    [_imageView addSubview:effectView];
}

- (void)addCardSwitch {
    //初始化数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DataPropertyList" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *items = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        YJCardItem *item = [[YJCardItem alloc] init];
        [item setValuesForKeysWithDictionary:dic];
        [items addObject:item];
    }
    _cardSwitch = [[YJCardSwtichView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _cardSwitch.items = items;
    _cardSwitch.delegate = self;
    _cardSwitch.pagingEnabled = YES;
    _cardSwitch.selectedIndex = 3;
    [self.view addSubview:_cardSwitch];
}

- (void)YJCardSwitchViewDidSelectAt:(NSInteger)index {
    NSLog(@"选中了:%ld",(long)index);
    YJCardItem *item = _cardSwitch.items[index];
    _imageView.image = [UIImage imageNamed:item.imageName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
