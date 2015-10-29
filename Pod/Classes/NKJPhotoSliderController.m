//
//  NKJPhotoSliderController.m
//  Pods
//
//  Created by nakajijapan on 4/13/15.
//
//

#import "NKJPhotoSliderController.h"
#import "NKJPhotoSliderImageView.h"

typedef enum : NSUInteger {
    NKJPhotoSliderControllerScrollModeNone = 0,
    NKJPhotoSliderControllerScrollModeVertical,
    NKJPhotoSliderControllerScrollModeHorizontal,
    NKJPhotoSliderControllerScrollModeRotating
} NKJPhotoSliderControllerScrollMode;

typedef enum : NSUInteger {
    NKJPhotoSliderControllerUsingImageTypeNone = 0,
    NKJPhotoSliderControllerUsingImageTypeURL,
    NKJPhotoSliderControllerUsingImageTypeImage
} NKJPhotoSliderControllerUsingImageType;

@interface NKJPhotoSliderController()
<
    UIScrollViewDelegate,
    NKJPhotoSliderImageViewDelegate,
    UIViewControllerTransitioningDelegate,
    NKJPhotoSliderZoomingAnimatedTransitioning
>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSArray *imageURLs;
@property (nonatomic) NSArray *images;
@property (nonatomic) NSMutableArray *imageViews;
@property (nonatomic) NKJPhotoSliderControllerUsingImageType usingImageType;
@property (nonatomic) CGPoint scrollPreviewPoint;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) NKJPhotoSliderControllerScrollMode scrollMode;
@property (nonatomic) BOOL scrollInitalized;
@property (nonatomic) BOOL closeAnimating;
@property (nonatomic) UIVisualEffectView *effectView;
@property (nonatomic) NSInteger previousPage;

@end

@implementation NKJPhotoSliderController

- (id)initWithImageURLs:(NSArray *)imageURLs;
{
    self = [super init];
    if (self) {
        self.imageURLs = imageURLs;
        self.usingImageType = NKJPhotoSliderControllerUsingImageTypeURL;
        [self setup];
    }
    
    return self;
}

- (id)initWithImages:(NSArray *)images;
{
    self = [super init];
    if (self) {
        self.images = images;
        self.usingImageType = NKJPhotoSliderControllerUsingImageTypeImage;
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.visiblePageControl = YES;
    self.visibleCloseButton = YES;
    self.scrollInitalized = NO;
    self.closeAnimating = NO;
    self.backgroundColor = [UIColor blackColor];
    self.imageViews = [NSMutableArray array];
    self.currentPage = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // for iOS7
    if ([UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortrait &&
        [UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortraitUpsideDown) {
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGSize size = self.view.bounds.size;
        bounds.size.width = size.height;
        bounds.size.height = size.width;
        self.view.bounds = bounds;
        
    } else {
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.backgroundColor = self.backgroundColor;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self.view addSubview:self.backgroundView];
    } else {
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.effectView.frame = self.view.bounds;
        [self.view addSubview:self.effectView];
        
        [self.effectView addSubview:self.backgroundView];
    }
    
    // scrollview setting for Item
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = false;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self layoutScrollView];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * [self imageResources].count,
                                             CGRectGetHeight(self.view.bounds) * 3.f);
    
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGRect frame = self.view.bounds;
    frame.origin.y = height;
    
    for (id imageResource in [self imageResources]) {
        
        NKJPhotoSliderImageView *imageView = [[NKJPhotoSliderImageView alloc] initWithFrame:frame];
        [self.scrollView addSubview:imageView];
        
        if (self.usingImageType == NKJPhotoSliderControllerUsingImageTypeURL) {
            [imageView loadImage:(NSURL *)imageResource];
        } else {
            imageView.imageView.image = (UIImage *)imageResource;
        }
        frame.origin.x += width;
        imageView.delegate = self;
        [self.imageViews addObject:imageView];
    }
    
    // Page Control
    if (self.visiblePageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        self.pageControl.numberOfPages = [self imageResources].count;
        self.pageControl.currentPage = 0;
        self.pageControl.userInteractionEnabled = false;
        [self.view addSubview:self.pageControl];
        [self layoutPageControl];
    }
    
    // Close Button
    if (self.visibleCloseButton) {
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        NSString *imagePath = [[self resourceBundle] pathForResource:@"NKJPhotoSliderControllerClose"
                                                              ofType:@"png"];
        
        [self.closeButton setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.imageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:self.closeButton];
        [self layoutCloseButton];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    self.scrollMode = NKJPhotoSliderControllerScrollModeNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds) * self.currentPage, CGRectGetHeight(self.scrollView.bounds));
    self.scrollInitalized = YES;
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.view removeFromSuperview];
    }];
}


#pragma mark - Constraints

- (void)layoutCloseButton
{
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"closeButton": self.closeButton};
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[closeButton(52)]" options:0 metrics:nil views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[closeButton(52)]|" options:0 metrics:nil views:views]];
}

- (void)layoutPageControl
{
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"pageControl": self.pageControl};
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-22-|" options:0 metrics:nil views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControl]|" options:0 metrics:nil views:views]];
}

- (void)layoutScrollView
{
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"scrollView": self.scrollView};
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.previousPage = self.currentPage;

    self.scrollPreviewPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.scrollInitalized) {
        [self generateCurrentPage];
        return;
    }
    
    NKJPhotoSliderImageView *imageView = self.imageViews[self.currentPage];
    
    if (imageView.scrollView.zoomScale > 1.0) {
        [self generateCurrentPage];
        self.scrollView.scrollEnabled = NO;
        return;
    }
    
    if (self.scrollMode == NKJPhotoSliderControllerScrollModeRotating) {
        return;
    }
    
    CGFloat offsetX = fabs(scrollView.contentOffset.x - self.scrollPreviewPoint.x);
    CGFloat offsetY = fabs(scrollView.contentOffset.y - self.scrollPreviewPoint.y);
    
    if (self.scrollMode == NKJPhotoSliderControllerScrollModeNone) {
        if (offsetY > offsetX) {
            self.scrollMode = NKJPhotoSliderControllerScrollModeVertical;
        } else {
            self.scrollMode = NKJPhotoSliderControllerScrollModeHorizontal;
        }
    }
    
    if (self.scrollMode == NKJPhotoSliderControllerScrollModeVertical) {
        
        CGFloat offsetHeight = fabs(scrollView.frame.size.height - scrollView.contentOffset.y);
        CGFloat alpha = 1.f - (fabs(offsetHeight) / (scrollView.frame.size.height / 2.f));
        
        self.backgroundView.alpha = alpha;
        
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = self.scrollPreviewPoint.x;
        scrollView.contentOffset = contentOffset;
        
        CGFloat screenHeight = self.view.bounds.size.height;
        
        if (self.scrollView.contentOffset.y > screenHeight * 1.4f) {
            [self closePhotoSliderWithUp:YES];
        } else if (self.scrollView.contentOffset.y < screenHeight * 0.6f) {
            [self closePhotoSliderWithUp:NO];
        }
        
    } else if (self.scrollMode == NKJPhotoSliderControllerScrollModeHorizontal) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.y = self.scrollPreviewPoint.y;
        scrollView.contentOffset = contentOffset;
    }
    
    // Update current page index.
    [self generateCurrentPage];

}


- (void)generateCurrentPage
{
    NSInteger page = (NSInteger)roundf(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);

    if (page < 0) {
        page = 0;
    } else if (page >= [self imageResources].count) {
        page = [self imageResources].count - 1;
    }

    self.currentPage = page;
    
    if (self.visiblePageControl) {
        if (self.pageControl != nil) {
            self.pageControl.currentPage = self.currentPage;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollMode == NKJPhotoSliderControllerScrollModeVertical) {
        
        CGPoint velocity = [[scrollView panGestureRecognizer] velocityInView:scrollView];
        
        if (velocity.y < -500.f) {

            self.scrollView.frame = scrollView.frame;
            [self closePhotoSliderWithUp:YES];

        } else if (velocity.y > 500.f) {

            self.scrollView.frame = scrollView.frame;
            [self closePhotoSliderWithUp:NO];

        }
    }
}

- (void)closePhotoSliderWithUp:(BOOL)up
{
    if (self.closeAnimating) {
        return;
    }
    self.closeAnimating = YES;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat movedHeight = 0.f;
    
    if ([self.delegate respondsToSelector:@selector(photoSliderControllerWillDismiss:)]) {
        [self.delegate photoSliderControllerWillDismiss:self];
    }
    
    if (up) {
        movedHeight = -screenHeight;
    } else {
        movedHeight = screenHeight;
    }
    
    [UIView animateWithDuration:0.4
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         self.scrollView.frame = CGRectMake(0.f, movedHeight, screenWidth, screenHeight);
                         self.backgroundView.alpha = 0.f;
                         self.closeButton.alpha = 0.f;
                         self.view.alpha = 0.f;

                     }
                     completion:^(BOOL finished) {

                         [self dissmissViewControllerAnimated:NO];
                         self.closeAnimating = NO;

                     }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // If page index has changed - reset zoom scale for previous image.
    if (self.previousPage != self.currentPage) {
        
        NKJPhotoSliderImageView *imageView = self.imageViews[self.previousPage];
        imageView.scrollView.zoomScale = imageView.scrollView.minimumZoomScale;

    }
    
    self.scrollMode = NKJPhotoSliderControllerScrollModeNone;
}

#pragma mark - Button Actions

- (void)closeButtonDidTap:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(photoSliderControllerWillDismiss:)]) {
        [self.delegate photoSliderControllerWillDismiss:self];
    }
    
    [self dissmissViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)dissmissViewControllerAnimated:(BOOL)animated
{
    [self dismissViewControllerAnimated:animated completion:^{
        
        if ([self.delegate respondsToSelector:@selector(photoSliderControllerDidDismiss:)]) {
            [self.delegate photoSliderControllerDidDismiss:self];
        }
        
    }];
}

- (NSBundle *)resourceBundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"NKJPhotoSliderController" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    return bundle;
}

#pragma mark - UITraitEnvironment

// Deprecated Method(from iOS8)
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self traitCollectionDidChange:nil];
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    self.scrollMode = NKJPhotoSliderControllerScrollModeRotating;
    
    CGRect contentViewBounds = self.view.bounds;
    CGFloat height = CGRectGetHeight(contentViewBounds);
    
    // Background View
    self.backgroundView.frame = contentViewBounds;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        self.effectView.frame = contentViewBounds;
    }
    
    // Scroll View
    self.scrollView.contentSize = CGSizeMake(
                                             CGRectGetWidth(contentViewBounds) * (CGFloat)[self imageResources].count,
                                             CGRectGetHeight(contentViewBounds) * 3.0f
                                             );
    
    self.scrollView.frame = contentViewBounds;
    
    // ImageViews
    CGRect frame = CGRectMake(0.f,
                              CGRectGetHeight(contentViewBounds),
                              CGRectGetWidth(contentViewBounds),
                              CGRectGetHeight(contentViewBounds));
    
    for (NSInteger i = 0; i < self.scrollView.subviews.count; i++) {
        
        NKJPhotoSliderImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = frame;
        frame.origin.x += contentViewBounds.size.width;
        imageView.scrollView.frame = contentViewBounds;
    }
    
    self.scrollView.contentOffset = CGPointMake((CGFloat)self.currentPage * CGRectGetWidth(contentViewBounds), height);
    self.scrollMode = NKJPhotoSliderControllerScrollModeNone;
}

#pragma mark - NKJPhotoSliderZoomingAnimatedTransitioning

- (UIImageView *)transitionSourceImageView
{
    NKJPhotoSliderImageView *zoomingImageView = self.imageViews[self.currentPage];
    return zoomingImageView.imageView;
}

- (CGRect)transitionDestinationImageViewFrame
{
    return self.view.frame;
}

#pragma mark - NKJPhotoSliderImageViewDelegate

- (void) photoSliderImageViewDidEndZooming:(NKJPhotoSliderImageView *)imageView atScale:(CGFloat)scale
{
    if (scale <= 1.0) {
        self.scrollView.scrollEnabled = YES;
    } else {
        self.scrollView.scrollEnabled = NO;
    }
}

#pragma mark - Private Method

- (NSArray *)imageResources
{
    if (self.usingImageType == NKJPhotoSliderControllerUsingImageTypeURL) {
        return self.imageURLs;
    } else if (self.usingImageType == NKJPhotoSliderControllerUsingImageTypeImage) {
        return self.images;
    }
    
    return nil;
}

@end
