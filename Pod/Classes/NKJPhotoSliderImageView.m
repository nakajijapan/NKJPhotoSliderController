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
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
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
                                                    }];
}

- (void)didDoubleTap:(UIGestureRecognizer *)sender
{
    CGFloat scale = 0.0;
    if (self.scrollView.zoomScale == 1.0) {
        scale = 2.f;
    } else {
        scale = 1.f;
    }

    [self.scrollView setZoomScale:scale animated:YES];

}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
