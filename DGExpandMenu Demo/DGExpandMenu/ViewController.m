//
//  ViewController.m
//  DGExpandMenu
//
//  Created by 段昊宇 on 16/7/2.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "ViewController.h"
#import "DGExpandMenuButton.h"

@interface ViewController ()
@property(nonatomic, strong) DGExpandMenuButton *ExpandMenuButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed: 18 / 255.f green: 80 / 255.f blue: 154 / 255.f alpha: 1];
    
    UIButton *btn1 = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn1 setImage: [UIImage imageNamed: @"cart"] forState: UIControlStateNormal];


    UIButton *btn2 = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn2 setImage: [UIImage imageNamed: @"setting"] forState: UIControlStateNormal];


    UIButton *btn3 = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn3 setImage: [UIImage imageNamed: @"user"] forState: UIControlStateNormal];
//    
//    UIButton *btn4 = [UIButton buttonWithType: UIButtonTypeCustom];
//    btn4.backgroundColor = [UIColor greenColor];
//    
//    UIButton *btn5 = [UIButton buttonWithType: UIButtonTypeCustom];
//    btn5.backgroundColor = [UIColor blueColor];

    _ExpandMenuButton = [[DGExpandMenuButton alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - 40, 360, 80, 80)
                                                            superView: self.view
                                                           andObjects: btn1, btn2, btn3, nil];
    
    UIButton *plus = [UIButton buttonWithType: UIButtonTypeCustom];
    [plus setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    plus.frame = CGRectMake(185, 200, 40, 40);
    [plus addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
    plus.tintColor = [UIColor whiteColor];
    
    [self.view addSubview: _ExpandMenuButton];
    [self.view addSubview: plus];
}

- (void)addButton {
    UIButton *btn5 = [UIButton buttonWithType: UIButtonTypeCustom];
    btn5.backgroundColor = [UIColor grayColor];
    
    [_ExpandMenuButton addOneButton:btn5];
    // [_ExpandMenuButton delLastButton]
}

@end
