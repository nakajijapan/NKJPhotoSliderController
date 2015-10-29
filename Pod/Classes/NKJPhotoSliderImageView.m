//
//  NKJPhotoSliderImageView.m
//  Pods
//
//  Created by nakajijapan on 4/12/15.
//
//

#import "NKJPhotoSliderImageView.h"
#import "NKJPhotoSliderProgressView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NKJPhotoSliderImageView () <UIScrollViewDelegate>
@property (nonatomic) NKJPhotoSliderProgressView *progressView;
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
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    // for zoom
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.bounces = true;
    self.scrollView.delegate = self;
    
    // image
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = true;

    self.userInteractionEnabled = true;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    // progress view
    self.progressView = [[NKJPhotoSliderProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    self.progressView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    self.progressView.hidden = YES;
    [self addSubview:self.progressView];
    
    UITapGestureRecognizer *doubleTabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTabGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTabGesture];
    
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleHeight |
                                      UIViewAutoresizingFlexibleBottomMargin;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
     // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2.f);
    } else {
        frameToCenter.origin.x = 0.f;
    }
    
         // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2.f);
    } else {
        frameToCenter.origin.y = 0.f;
    }
    
    // Center
    if (!CGRectEqualToRect(self.imageView.frame, frameToCenter)) {
        self.imageView.frame = frameToCenter;
    }

}


- (void)loadImage:(NSURL *)imageURL
{
    self.progressView.hidden = NO;
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:imageURL
                                          andPlaceholderImage:nil
                                                      options:SDWebImageCacheMemoryOnly
                                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                         CGFloat progress = receivedSize / expectedSize;
                                                         [self.progressView animateCurveToProgress:progress];
                                                     }
                                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                        self.progressView.hidden = YES;
                                                        
                                                        if (error == nil) {
                                                            [self layoutImageView:image];
                                                        }
                                                    }];
}

- (void)setImage:(UIImage *)image
{
    [self layoutImageView:image];
}

- (void)layoutImageView:(UIImage *)image
{
    
    CGRect frame = CGRectZero;
    frame.origin = CGPointZero;
    
    CGFloat height = image.size.height * (self.bounds.size.width / image.size.width);
    CGFloat width = image.size.width * (self.bounds.size.height / image.size.height);
    
    if (image.size.width > image.size.height) {
        frame.size = CGSizeMake(self.bounds.size.width, height);
        if (height >= self.bounds.size.height) {
            frame.size = CGSizeMake(width, self.bounds.size.height);
        }
    } else {
        frame.size = CGSizeMake(width, self.bounds.size.height);
        if (width >= self.bounds.size.width) {
            frame.size = CGSizeMake(self.bounds.size.width, height);
        }
    }
    
    self.imageView.frame = frame;
    self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)layoutImageView
{
    if (self.imageView.image) {
        [self layoutImageView:self.imageView.image];
    }
}

- (void)didDoubleTap:(UIGestureRecognizer *)sender
{
    CGFloat scale = 0.0;
    if (self.scrollView.zoomScale == 1.0) {
        scale = 2.f;
        
        CGPoint touchPoint = [sender locationInView:self];
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1.f, 1.f) animated:YES];
        
    } else {
        [self.scrollView setZoomScale:0.f animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.delegate respondsToSelector:@selector(photoSliderImageViewDidEndZooming:atScale:)]) {
        [self.delegate photoSliderImageViewDidEndZooming:self atScale:scale];
    }
}

@end
