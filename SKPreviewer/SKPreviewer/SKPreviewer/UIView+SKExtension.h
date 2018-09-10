//
//  UIView+SKExtension.h
//  SKPreviewer
//
//  Created by 沈凯 on 2018/9/6.
//  Copyright © 2018年 Ssky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SKExtension)
@property (assign, nonatomic) CGFloat sk_x;
@property (assign, nonatomic) CGFloat sk_y;
@property (assign, nonatomic) CGFloat sk_width;
@property (assign, nonatomic) CGFloat sk_height;
@property (assign, nonatomic) CGPoint sk_origin;
@property (assign, nonatomic) CGSize sk_frameSize;
@property (assign, nonatomic) CGPoint sk_center;
@property (assign, nonatomic) CGFloat sk_centerX;
@property (assign, nonatomic) CGFloat sk_centerY;
@end
