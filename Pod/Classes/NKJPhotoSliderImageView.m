//
//  NKJPhotoSliderImageView.m
//  Pods
//
//  Created by nakajijapan on 4/12/15.
//
//

#import "NKJPhotoSliderImageView.h"

@interface NKJPhotoSliderImageView () <UIScrollViewDelegate>
@end

@implementation NKJPhotoSliderImageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.bounces = true;
    self.scrollView.delegate = self;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = true;

    self.userInteractionEnabled = true;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *doubleTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTabGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTabGesture];
}

- (void)didDoubleTap:(UIGestureRecognizer *)sender
{
    if (self.scrollView.zoomScale == 1.0) {
        [self.scrollView setZoomScale:2.0 animated:YES];
    } else {
        [self.scrollView setZoomScale:0.0 animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
