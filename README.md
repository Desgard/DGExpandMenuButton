![](http://7xwh85.com1.z0.glb.clouddn.com/background.png)
## Description

The *ExpandMenuButton* inspired by the prototype in dribbble([here](https://dribbble.com/shots/2793664-Expanding-Menu) is the link). Thanks to the prototype author - [*Pablo Stanley*](https://dribbble.com/pablostanley).

## Screenshot

<img src="/Screenshot/DGExpandMenu-o.gif" alt="img" width="260px">


## Usage

### Initialize e.g

```Objective-C
UIButton *btn1 = [UIButton buttonWithType: UIButtonTypeCustom];
[btn1 setImage: [UIImage imageNamed: @"cart"] forState: UIControlStateNormal];

UIButton *btn2 = [UIButton buttonWithType: UIButtonTypeCustom];
[btn2 setImage: [UIImage imageNamed: @"setting"] forState: UIControlStateNormal];

UIButton *btn3 = [UIButton buttonWithType: UIButtonTypeCustom];
[btn3 setImage: [UIImage imageNamed: @"user"] forState: UIControlStateNormal];

DGExpandMenuButton *ExpandMenuButton = [[DGExpandMenuButton alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - 40, 360, 80, 80) superView: self.view  andObjects: btn1, btn2, btn3, nil];

[self.view addSubview: ExpandMenuButton];
```

### Implement  

#### `- (void)addOneButton:(UIButton *)btn;`

The method can let you to add a new button freedomly and smoothly. It will check the menu status to judge whether the new button needs a *animation*. 

##### e.g

```Objective-C
- (void)viewDidLoad {
    // ...
    UIButton *plus = [UIButton buttonWithType: UIButtonTypeCustom];
    [plus setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    plus.frame = CGRectMake(185, 200, 40, 40);
    [plus addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: plus];
}

- (void)addButton {
    UIButton *btn5 = [UIButton buttonWithType: UIButtonTypeCustom];
    btn5.backgroundColor = [UIColor grayColor];
    [_ExpandMenuButton addOneButton:btn5];
}
```

| ```[_ExpandMenuButton addOneButton:btn];``` | <img src="/Screenshot/DGExpandMenu.gif" alt="img" width="260px"> |
| --- | --- |

#### `- (void)delLastButton;`

The method can let you to delete the last button in the menu, smoothly and quickly. And this interface is a internal method with gesture - Swip Down.

##### e.g

| ```[_expandMenuButton delLastButton];``` | <img src="/Screenshot/DGExpandMenuDel.gif" alt="img" width="260px"> |
| --- | --- |


#### `- (void)rotateAllButton;`

When the menu buttons has been to the max number, you can trigger this function to rotate all buttons.

##### e.g


| ```[_expandMenuButton rotateAllButton];``` | <img src="/Screenshot/DGExpandMenuRot.gif" alt="img" width="260px"> |
| --- | --- |

#### `- (void)showButtonIndex;`

This function can show the index of every buttons. You will use it when using function behind, if you like.

#### `- (void)turnedFrom:(int)indA to:(int)indB `

You can exchange position the buttons' position by this function. And you need to know the index of the button by `showButtonIndex` function.

##### e.g

| ```[_ExpandMenuButton turnedFrom:val1 to:val2];``` | <img src="/Screenshot/DGExpandMenuExc.gif" alt="img" width="260px"> |
| --- | --- |


## Next Feature

If you want to add some special feature, you can start a `pull request` or a `issue` to tell me the good idea!

## The MIT License (MIT)

Copyright (c) 2016 Desgard_Duan.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.



