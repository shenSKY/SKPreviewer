//
//  UIView+SKExtension.m
//  SKPreviewer
//
//  Created by 沈凯 on 2018/9/6.
//  Copyright © 2018年 Ssky. All rights reserved.
//

#import "UIView+SKExtension.h"

@implementation UIView (SKExtension)

- (void)setSk_x:(CGFloat)sk_x
{
    CGRect frame = self.frame;
    frame.origin.x = sk_x;
    self.frame = frame;
}

- (CGFloat)sk_x
{
    return self.frame.origin.x;
}

- (void)setSk_y:(CGFloat)sk_y
{
    CGRect frame = self.frame;
    frame.origin.y = sk_y;
    self.frame = frame;
}

- (CGFloat)sk_y
{
    return self.frame.origin.y;
}

- (void)setSk_width:(CGFloat)sk_width
{
    CGRect frame = self.frame;
    frame.size.width = sk_width;
    self.frame = frame;
}

- (CGFloat)sk_width
{
    return self.frame.size.width;
}

- (void)setSk_height:(CGFloat)sk_height
{
    CGRect frame = self.frame;
    frame.size.height = sk_height;
    self.frame = frame;
}

- (CGFloat)sk_height
{
    return self.frame.size.height;
}

- (void)setSk_origin:(CGPoint)sk_origin
{
    CGRect frame = self.frame;
    frame.origin = sk_origin;
    self.frame = frame;
}

- (CGPoint)sk_origin
{
    return self.frame.origin;
}

- (void)setSk_frameSize:(CGSize)sk_frameSize
{
    CGRect frame = self.frame;
    frame.size = sk_frameSize;
    self.frame = frame;
}

- (CGSize)sk_frameSize
{
    return self.frame.size;
}

- (void)setSk_center:(CGPoint)sk_center
{
    CGRect frame = self.frame;
    frame.origin.x = sk_center.x - frame.size.width * 0.5;
    frame.origin.y = sk_center.y - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGPoint)sk_center
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5, self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setSk_centerX:(CGFloat)sk_centerX
{
    CGPoint center = self.center;
    center.x = sk_centerX;
    self.center = center;
}

- (CGFloat)sk_centerX
{
    return self.center.x;
}

- (void)setSk_centerY:(CGFloat)sk_centerY
{
    CGPoint center = self.center;
    center.y = sk_centerY;
    self.center = center;
}

- (CGFloat)sk_centerY
{
    return self.center.y;
}
@end
