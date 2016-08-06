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
@property (nonatomic, strong) NSMutableArray<UIButton *> *indexNum;
@property (nonatomic, copy) UIButton *mainButton;
@property (nonatomic, copy) UIButton *rmainButton;
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

- (void) delLastButton {
    if (self.buttons.count > 0) {
        UIButton *btn = [self.buttons objectAtIndex: self.buttons.count - 1];
        [self.buttons removeObjectAtIndex: [self.buttons count] - 1];
        [self singleBtnExit:btn];
    } else {
        NSLog(@"Menu中没有按钮");
    }
}

- (void) rotateAllButton {
    if (self.buttons.count == [self calcMaxBtnNumber]) {
        
        int cnt = (int)[self.buttons count] - 1;
        int index[360], windex[360];
        memset(index, -1, sizeof(index));
        int l = 0, r = cnt;
        for (int i = 0; i <= cnt; ++ i) {
            if (i == 0) {
                index[i] = 0;
                l = 1;
                continue;
            }
            if (i % 2) index[i] = r --;
            else index[i] = l ++;
        }
        
        for (int i = 0; i < (int)[self.buttons count]; ++ i) {
            windex[i] = (index[i] + 1) % (self.buttons.count);
        }
        
        NSMutableArray<UIButton *> *newButtons = [NSMutableArray array];
        for (int i = 0; i < (int)[self.buttons count]; ++ i) {
            for (int j = 0; j < (int)[self.buttons count]; ++ j) {
                if (windex[i] == index[j]) {
                    [newButtons addObject:self.buttons[j]];
                }
            }
        }
        self.buttons = newButtons;
        if (self.menuState == DGExpandOpen) {
            [self rotateAnimation: YES];
        }
    }
}

- (void) turnedLeftBy:(int)ind {
    if (ind < (int)[self.buttons count]) {
        int cnt = (int)[self.buttons count] - 1;
        int index[360], windex[360];
        memset(index, -1, sizeof(index));
        int l = 0, r = cnt;
        for (int i = 0; i <= cnt; ++ i) {
            if (i == 0) {
                index[i] = 0;
                l = 1;
                continue;
            }
            if (i % 2) index[i] = r --;
            else index[i] = l ++;
        }
        for (int i = 0; i < (int)[self.buttons count]; ++ i) {
            if (index[i] == ind) {
                windex[i] = index[i] - 1;
                if (windex[i] < 0) {
                    windex[i] = (int)[self.buttons count] - 1;
                }
            } else if (index[i] == ind - 1) {
                windex[i] = (index[i] + 1) % (int)[self.buttons count];
            } else {
                windex[i] = index[i];
            }
        }
        
        NSMutableArray<UIButton *> *newButtons = [NSMutableArray array];
        for (int i = 0; i < (int)[self.buttons count]; ++ i) {
            for (int j = 0; j < (int)[self.buttons count]; ++ j) {
                if (windex[i] == index[j]) {
                    [newButtons addObject:self.buttons[j]];
                }
            }
        }
        self.buttons = newButtons;
        
        if (self.menuState == DGExpandOpen) {
            [self tureAnimation];
        }
    }
}

- (void)turnedFrom:(int)indA to:(int)indB {
    if (indA < (int)[self.buttons count] && indB < (int)[self.buttons count]) {
        int cnt = (int)[self.buttons count] - 1;
        int index[360], windex[360];
        memset(index, -1, sizeof(index));
        int l = 0, r = cnt;
        for (int i = 0; i <= cnt; ++ i) {
            if (i == 0) {
                index[i] = 0;
                l = 1;
                continue;
            }
            if (i % 2) index[i] = r --;
            else index[i] = l ++;
        }
        for (int i = 0; i < (int)[self.buttons count]; ++ i) {
            if (index[i] == indA) {
                l = i;
            }
            if (index[i] == indB) {
                r = i;
            }
            windex[i] = index[i];
        }
        int swap = windex[l];
        windex[l] = windex[r];
        windex[r] = swap;
        
        NSMutableArray<UIButton *> *newButtons = [NSMutableArray array];
        for (int i = 0; i < (int)[self.buttons count]; ++ i) {
            for (int j = 0; j < (int)[self.buttons count]; ++ j) {
                if (windex[i] == index[j]) {
                    [newButtons addObject:self.buttons[j]];
                }
            }
        }
        self.buttons = newButtons;
        
        if (self.menuState == DGExpandOpen) {
            [self tureAnimation];
        }
    }
}

- (void)showButtonIndex {
    if (self.menuState == DGExpandOpen) {
        self.menuState = DGExpandShowIndex;
        int cnt = (int)[self.buttons count] - 1;
        int index[360];
        memset(index, -1, sizeof(index));
        int l = 0, r = cnt;
        for (int i = 0; i <= cnt; ++ i) {
            if (i == 0) {
                index[i] = 0;
                l = 1;
                continue;
            }
            if (i % 2) index[i] = r --;
            else index[i] = l ++;
        }

        self.indexNum = [NSMutableArray array];
        for (int i = 0; i < (int)[self.buttons count]; ++ i) {
            UIButton *ind = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            ind.frame = self.rmainButton.frame;
            [ind setTitle:[NSString stringWithFormat:@"%d", index[i]] forState:UIControlStateNormal];
            ind.titleLabel.font = [UIFont systemFontOfSize:40];
            ind.tintColor = [UIColor whiteColor];
            ind.backgroundColor = [UIColor clearColor];
            ind.alpha = 0;
            [self.indexNum addObject:ind];
            [self addSubview:ind];
            
        }
        [self showIndexAnimation];
    }
}

#pragma mark - Animations: Begin & End & Add & Change
- (void) expandMenu {
    if (self.buttons.count == 0) return;
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

- (void) singleBtnExit: (UIButton *) btn {
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         btn.transform = CGAffineTransformMakeScale(5, 5);
                         btn.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [btn removeFromSuperview];
                     }];
}

- (void) rotateAnimation: (BOOL)needSpring {
    if (needSpring) {
        [UIView animateWithDuration: 1.2
                              delay: 0
             usingSpringWithDamping: 0.7f
              initialSpringVelocity: 10
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             int cnt = 0;
                             for (UIButton *btn in _buttons) {
                                 btn.center = [[self.endPositons objectAtIndex:cnt] CGPointValue];
                                 cnt ++;
                                 if (cnt == [self calcMaxBtnNumber]) break;
                             }
                         }
                         completion:^(BOOL finished) {
                             [self resetAnimation];
                         }];
    } else {
        [UIView animateWithDuration: 0.3
                              delay: 0
             usingSpringWithDamping: 0.7f
              initialSpringVelocity: 8
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             int cnt = 0;
                             for (UIButton *btn in _buttons) {
                                 btn.center = [[self.endPositons objectAtIndex:cnt] CGPointValue];
                                 cnt ++;
                                 if (cnt == [self calcMaxBtnNumber]) break;
                             }
                         }
                         completion:^(BOOL finished) {
                             [self resetAnimation];
                         }];

    }
}

- (void) resetAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        for (UIButton *btn in _buttons) {
            btn.transform = CGAffineTransformMakeScale(1, 1);
            btn.alpha = 1;
            self.rmainButton.alpha = 1;
            [self sendSubviewToBack:self.rmainButton];
        }
    }];
}

- (void) tureAnimation {
    [UIView animateWithDuration: 0.3
                          delay: 0
         usingSpringWithDamping: 0.7f
          initialSpringVelocity: 10
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         int cnt = 0, flag = 0;
                         for (UIButton *btn in _buttons) {
                             double x = btn.center.x, y = btn.center.y;
                             double tox = [[self.endPositons objectAtIndex:cnt] CGPointValue].x, toy = [[self.endPositons objectAtIndex:cnt] CGPointValue].y;
                             if (x != tox || y != toy) {
                                 if (flag % 2 == 0) {
                                     btn.transform = CGAffineTransformMakeScale(0.7, 0.7);
                                     [self sendSubviewToBack:btn];
                                     btn.alpha = 0.6;
                                     self.rmainButton.alpha = 0;
                                     flag ++;
                                 } else {
                                     btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                     flag ++;
                                 }
                             }
                             cnt ++;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         [self rotateAnimation: NO];
                     }];
}

- (void) showIndexAnimation {
    if (self.buttons.count == 0) return;
    if (self.menuState == DGExpandClose) return;
    int cnt = 0;
    for (UIButton *btn in _indexNum) {
        btn.center = [[self.endPositons objectAtIndex:cnt] CGPointValue];
        cnt ++;
        if (cnt == [self calcMaxBtnNumber]) break;
        btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
    }
    
    [UIView animateWithDuration: 0.6
                          delay: 0
         usingSpringWithDamping: 0.7f
          initialSpringVelocity: 25
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         for (UIButton *btn in _indexNum) {
                             btn.alpha = 1;
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         }
                         for (UIButton *btn in _buttons) {
                             btn.alpha = 0.3;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.4
                                          animations:^{
                                              for (UIButton *btn in _indexNum) {
                                                  btn.alpha = 0;
                                                  btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
                                              }
                                          }
                                          completion:^(BOOL finished) {
                                              for (UIButton *btn in _indexNum) {
                                                  [btn removeFromSuperview];
                                              }
                                              self.menuState = DGExpandOpen;
                                              [self resetAnimation];
                                          }];
                     }];
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
        
        UISwipeGestureRecognizer *swipeGestureRecognizer;
        swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(delLastButton)];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [_rmainButton addGestureRecognizer:swipeGestureRecognizer];
    }
    return _rmainButton;
}

- (UIView *) hitTest: (CGPoint)point withEvent: (UIEvent *)event {
    UIView *subView = [super hitTest:point withEvent:event];
    return subView == self ? nil : subView;
}

@end
