//
//  DGExpandMenuButton.m
//  DGExpandMenu
//
//  Created by 段昊宇 on 16/7/2.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "DGExpandMenuButton.h"

@interface DGExpandMenuButton()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<NSValue *> *endPositons;
@property (nonatomic, strong) UIButton *mainButton;
@property (nonatomic, strong) UIButton *rmainButton;
@property (assign) CGPoint originPoint;
@property (assign) CGRect originFrame;

@property (assign) CGFloat angle;

@property (assign) DGExpandState menuState;

@end

@implementation DGExpandMenuButton

#pragma mark - Override
- (instancetype) initWithFrame: (CGRect)frame
                     superView: (UIView *)superView
                    andObjects: (UIButton *) btn, ... {
    if (self = [super initWithFrame: [UIScreen mainScreen].bounds]) {
        
        self.angle = 60.f;
        self.menuState = DGExpandClose;
        
        
        self.mainButton.frame = self.rmainButton.frame = self.originFrame = frame;;
        self.originPoint = self.mainButton.center;
        
        _buttons = [NSMutableArray arrayWithObject: btn];
        va_list list;
        va_start(list, btn);
        while (YES) {
            UIButton *btnx = va_arg(list, UIButton *);
            if (!btnx) break;
            [_buttons addObject: [NSKeyedUnarchiver unarchiveObjectWithData: [NSKeyedArchiver archivedDataWithRootObject: btnx]]];
        }
        va_end(list);
        
        for (UIButton *btn in _buttons) {
            btn.frame = frame;
            btn.center = _mainButton.center;
            
            btn.layer.cornerRadius = btn.frame.size.width / 2.f;
            btn.layer.masksToBounds = YES;
            
            [self addSubview: btn];
        }
        
        [self addSubview: self.mainButton];
        [self addSubview: self.rmainButton];
        
        [self.mainButton addTarget: self
                            action: @selector(expandMenu)
                  forControlEvents: UIControlEventTouchUpInside];
        [self.rmainButton addTarget: self
                             action: @selector(closeMenu)
                   forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Out Interface
- (void) addOneButton: (UIButton *) btn{
    if (self.buttons.count < [self calcMaxBtnNumber]) {
        btn.frame = self.originFrame;
        btn.center = _mainButton.center;
        
        btn.layer.cornerRadius = btn.frame.size.width / 2.f;
        btn.layer.masksToBounds = YES;
        
        [self.buttons addObject:btn];
        [self insertSubview:btn belowSubview:self.mainButton];
        
        if (self.menuState == DGExpandOpen) {
            btn.alpha = 0;
            [self singleBtnAppear: btn];
        }
    } else {
        NSLog(@"按钮已经超出上限负载。");
    }
}

#pragma mark - Animations: Begin & End & Add
- (void) expandMenu {
    self.endPositons = [NSMutableArray array];
    [UIView animateWithDuration: 0.6
                          delay: 0
         usingSpringWithDamping: 0.7f
          initialSpringVelocity: 25
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _mainButton.center = _rmainButton.center = CGPointMake(_originPoint.x, _originPoint.y + 20);
                         _mainButton.transform = _rmainButton.transform = CGAffineTransformMakeScale(0.85, 0.85);
                         _mainButton.alpha = 0;
                         _rmainButton.alpha = 1;
                         for (int i = 0; i < [self calcMaxBtnNumber]; ++ i) {
                             int ind = i;
                             if (ind != 0) {
                                 if (ind % 2 == 1) ind = (ind + 1) / 2;
                                 else ind = - (ind / 2);
                             }
                             CGPoint p = CGPointMake(self.buttons[0].center.x, self.buttons[0].center.y - 85);
                             CGPoint lp;
                             lp = [self rotateWithCenter: CGPointMake(_originPoint.x, _originPoint.y + 20) Point: p angle: self.angle / 180.f * M_PI * ind];
                             
                             [self.endPositons addObject: [NSValue valueWithCGPoint: lp]];
                         }
                         
                         int cnt = 0;
                         for (UIButton *btn in _buttons) {
                             btn.center = [[self.endPositons objectAtIndex:cnt] CGPointValue];
                             cnt ++;
                             if (cnt == [self calcMaxBtnNumber]) break;
                         }
                     }
                     completion:^(BOOL finished) {
                         self.menuState = DGExpandOpen;
                     }];
    [UIView animateWithDuration: 0.4
                     animations: ^{
                         self.backgroundColor = [UIColor colorWithRed:50 / 255.f green:39 / 255.f blue:39 / 255.f alpha:1];
                     }];
}

- (void) closeMenu {
    [UIView animateWithDuration: 0.6
                          delay: 0
         usingSpringWithDamping: 1
          initialSpringVelocity: 0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _mainButton.center = _rmainButton.center = CGPointMake(_mainButton.center.x, _mainButton.center.y - 20);
                         _mainButton.transform = _rmainButton.transform = CGAffineTransformMakeScale(1, 1);
                         _mainButton.alpha = 1;
                         _rmainButton.alpha = 0;
                         
                         for (UIButton *btn in _buttons) {
                             btn.center = _originPoint;
                         }
                         
                         self.backgroundColor = DGExpandMenuBgColor;
                     }
                     completion:^(BOOL finished) {
                         self.menuState = DGExpandClose;
                     }];
}

- (void) singleBtnAppear: (UIButton *) btn {
    [UIView animateWithDuration: 0.6
                          delay: 0
         usingSpringWithDamping: 0.7f
          initialSpringVelocity: 25
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         btn.center = [[self.endPositons objectAtIndex: ((long)[self.buttons count] - 1)] CGPointValue];
                         btn.alpha = 1;
                     }
                     completion:nil];
}

#pragma mark - Algorithm
- (CGPoint) rotateWithCenter: (CGPoint)O Point: (CGPoint) P angle: (CGFloat)alpha {
    CGFloat x1 = P.x, y1 = P.y;
    CGFloat x2 = O.x, y2 = O.y;
    return CGPointMake((x1 - x2) * cos(alpha) - (y1 - y2) * sin(alpha) + x2,
                       (y1 - y2) * cos(alpha) + (x1 - x2) * sin(alpha) + y2);
}

- (int) calcMaxBtnNumber {
    return (int)(360.f / self.angle);
}

#pragma mark - Lazy Init
- (UIButton *)mainButton {
    if (!_mainButton){
        _mainButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_mainButton setImage: [UIImage imageNamed: @"menu"] forState: UIControlStateNormal];
    }
    return _mainButton;
}

- (UIButton *)rmainButton {
    if (!_rmainButton) {
        _rmainButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_rmainButton setImage: [UIImage imageNamed: @"close"] forState: UIControlStateNormal];
        _rmainButton.alpha = 0;
    }
    return _rmainButton;
}

- (UIView *) hitTest: (CGPoint)point withEvent: (UIEvent *)event {
    UIView *subView = [super hitTest:point withEvent:event];
    return subView == self ? nil : subView;
}

@end
