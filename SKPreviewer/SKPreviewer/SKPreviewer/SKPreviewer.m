//
//  SKPreviewer.m
//  SKPreviewer
//
//  Created by 沈凯 on 2018/9/6.
//  Copyright © 2018年 Ssky. All rights reserved.
//

#import "SKPreviewer.h"
#import "UIView+SKExtension.h"
#import <Photos/Photos.h>

@interface SKPreviewer ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *fromTheImageView;
@end

@implementation SKPreviewer

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

+ (void)previewFromImageView:(UIImageView *)imageView container:(UIView *)container
{
    [[[SKPreviewer alloc]init]previewFromImageView:imageView container:container];
}

- (void)previewFromImageView:(UIImageView *)imageView container:(UIView *)container
{
    self.fromTheImageView = imageView;
    self.fromTheImageView.hidden = YES;
    [container addSubview:self];
    
    self.containerView.sk_origin = CGPointZero;
    self.containerView.sk_width = self.sk_width;
    
    UIImage *image = self.fromTheImageView.image;
    
    if (image.size.height / image.size.width > self.sk_height / self.sk_width) {
        self.containerView.sk_height = floor(image.size.height / image.size.width / self.sk_width);
    }else {
        CGFloat height = image.size.height / image.size.width * self.sk_width;
        if (height < 1.0 || isnan(height)) {
            height = self.sk_height;
        }
        height = floor(height);
        self.containerView.sk_height = height;
        self.containerView.sk_centerY = self.sk_height / 2;
    }
    
    if (self.containerView.sk_height > self.sk_height && self.containerView.sk_height - self.sk_height <= 1) {
        self.containerView.sk_height = self.sk_height;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.sk_height, MAX(self.containerView.sk_height, self.sk_height));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    
    if (self.containerView.sk_height <= self.sk_height) {
        self.scrollView.alwaysBounceVertical = NO;
    }else {
        self.scrollView.alwaysBounceVertical = YES;
    }
    
    CGRect fromRect = [self.fromTheImageView convertRect:self.fromTheImageView.bounds toView:self.containerView];
    self.imageView.frame = fromRect;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    
    [UIView animateWithDuration:0.18 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.imageView.frame = self.containerView.bounds;
        self.imageView.transform = CGAffineTransformMakeScale(1.01, 1.01);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.10 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(1.00, 1.00);
        } completion:nil];
    }];
}

#pragma mark 设置
- (void)setup
{
    self.frame = [[UIScreen mainScreen]bounds];
    self.backgroundColor = UIColor.clearColor;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singelTap:)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
    self.background = [[UIView alloc]initWithFrame:self.frame];
    self.background.backgroundColor = [UIColor blackColor];
    [self addSubview:self.background];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.maximumZoomScale = 3.0;
    [self.scrollView setMultipleTouchEnabled:YES];
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.containerView = [[UIView alloc]init];
    [self.scrollView addSubview:self.containerView];
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [[UIColor alloc]initWithWhite:1.0 alpha:0.5];
    [self.containerView addSubview:self.imageView];
}

#pragma mark GestureRecognizer
- (void)singelTap:(UITapGestureRecognizer *)recognizer {
//    返回
    [self dismiss];
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
//    放大点击区域
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }else {
        CGPoint touchPoint = [recognizer locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat x = self.sk_width / newZoomScale;
        CGFloat y = self.sk_height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - x / 2, touchPoint.y - y / 2, x, y) animated:YES];
    }
}

- (void)longPress:(UITapGestureRecognizer *)recognizer {
//    长按保存图片至相册
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIImage *image = self.fromTheImageView.image;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                保存图片至相册
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",success ? @"保存成功" : @"保存失败");
                });
            }];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [alert addAction:cancel];
    
        [[self currentViewController] presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark 返回
- (void)dismiss {
    [UIView animateWithDuration:0.18 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect fromRect = [self.fromTheImageView convertRect:self.fromTheImageView.bounds toView:self.containerView];
        self.imageView.contentMode = self.fromTheImageView.contentMode;
        self.imageView.frame = fromRect;
        self.background.alpha = 0.01;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.10 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.fromTheImageView.hidden = NO;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark 获取当前控制器
- (UIViewController *)currentViewController
{
    UIResponder *responder = self.nextResponder;
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = (UIViewController *)responder;
            return controller;
        }else {
            responder = [responder nextResponder];
        }
    }
    return nil;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = self.containerView;
    CGFloat offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    
}
@end
