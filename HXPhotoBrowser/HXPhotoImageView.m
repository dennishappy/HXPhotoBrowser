//
//  HXPhotoImageView.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoImageView.h"
#import "HXPhotoBrowserMacro.h"

@interface HXPhotoImageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *processView;

@end

@implementation HXPhotoImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setScrollView];
        [self setEffectView];
        [self setProcessView];
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageView;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    return center;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    _scrollView.maximumZoomScale = kHXPhotoBrowserZoomMax;
    _imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (void)setScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.minimumZoomScale = kHXPhotoBrowserZoomMin;
    _scrollView.maximumZoomScale = kHXPhotoBrowserZoomMax;
    _scrollView.zoomScale = kHXPhotoBrowserZoomMin;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = width / 4 * 3;

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - height) / 2, width, height)];
    [_scrollView addSubview:_imageView];
}


- (void)setEffectView{
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_effectView];
    _effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
}

- (void)setProcessView{
    _processView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kHXPhotoBrowserProcessHeight)];
    [self addSubview:_processView];
    _processView.backgroundColor = [UIColor whiteColor];
}

- (void)finishProcess{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.alpha = 0;
        self.processView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.effectView removeFromSuperview];
        self.effectView = nil;
        [self.processView removeFromSuperview];
        self.processView = nil;
    }];
}

- (void)setReceivedSize:(CGFloat)receivedSize{
    _receivedSize = receivedSize;
    CGRect frame = CGRectMake(0, 0, receivedSize / _expectedSize * SCREEN_WIDTH, kHXPhotoBrowserProcessHeight);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.processView.frame = frame;
        }];
    });
    
}


@end
