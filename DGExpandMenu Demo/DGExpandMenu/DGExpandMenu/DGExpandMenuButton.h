//
//  DGExpandMenuButton.h
//  DGExpandMenu
//
//  Created by 段昊宇 on 16/7/2.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#define DGExpandMenuBgColor [UIColor colorWithRed:50 / 255.f green:39 / 255.f blue:39 / 255.f alpha:0]

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DGExpandState) {
    DGExpandClose = 0,
    DGExpandOpen = 1
};

@interface DGExpandMenuButton : UIView

- (instancetype) initWithFrame: (CGRect)frame
                     superView: (UIView *)superView
                    andObjects: (UIButton *) btn, ...;

- (void) addOneButton: (UIButton *) btn;
- (void) delLastButton;
- (void) rotateAllButton;

@end
