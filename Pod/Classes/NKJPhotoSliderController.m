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
} NKJPhotoSliderControllerScrollMode;

@interface NKJPhotoSliderController()<UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSArray *imageURLs;
@property (nonatomic) NSArray *images;
@property (nonatomic) CGPoint scrollPreviewPoint;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) NKJPhotoSliderControllerScrollMode scrollMode;
@property (nonatomic) BOOL scrollInitalized;
@property (nonatomic) BOOL closeAnimating;
@end

@implementation NKJPhotoSliderController

- (id)initWithImageURLs:(NSArray *)imageURLs;
{
    self = [super init];
    if (self) {
        self.imageURLs = imageURLs;
        self.visiblePageControl = YES;
        self.visibleCloseButton = YES;
        self.scrollInitalized = NO;
        self.closeAnimating = NO;
    }
    
    return self;
}

- (id)initWithImages:(NSArray *)images;
{
    self = [super init];
    if (self) {
        self.images = images;
        self.visiblePageControl = YES;
        self.visibleCloseButton = YES;
        self.scrollInitalized = NO;
        self.closeAnimating = NO;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;

    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.backgroundColor = [UIColor blackColor];

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self.view addSubview:self.backgroundView];
    } else {
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = self.view.bounds;
        [self.view addSubview:effectView];
        
        [effectView addSubview:self.backgroundView];
    }
    
    // layout
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
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

    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * self.imageURLs.count,
                                             CGRectGetHeight(self.view.bounds) * 3.f);
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGRect frame = self.view.bounds;
    frame.origin.y = height;
    
    if (self.imageURLs.count > 0) {
        for (NSURL *imageURL in self.imageURLs) {
            NKJPhotoSliderImageView *imageView = [[NKJPhotoSliderImageView alloc] initWithFrame:frame];
            [self.scrollView addSubview:imageView];
            [imageView loadImage:imageURL];
            frame.origin.x += width;
        }
    } else {
        for (UIImage *image in self.images) {
            NKJPhotoSliderImageView *imageView = [[NKJPhotoSliderImageView alloc] initWithFrame:frame];
            [self.scrollView addSubview:imageView];
            imageView.imageView.image = image;
            frame.origin.x += width;
        }
    }
    
    // pagecontrol
    if (self.visiblePageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.view.bounds) - 44.f, CGRectGetWidth(self.view.bounds), 22.f)];
        self.pageControl.numberOfPages = self.imageURLs.count > 0 ? self.imageURLs.count : self.images.count;
        self.pageControl.currentPage = 0;
        self.pageControl.userInteractionEnabled = false;
        [self.view addSubview:self.pageControl];
    }
    
    if (self.visibleCloseButton) {
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 32 - 8, 8, 32, 32)];
        
        NSString *imagePath = [[self resourceBundle] pathForResource:@"NKJPhotoSliderControllerClose"
                                                              ofType:@"png"];
        
        [self.closeButton setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.imageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:self.closeButton];
    }

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    self.scrollMode = NKJPhotoSliderControllerScrollModeNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds) * self.index, CGRectGetHeight(self.scrollView.bounds));
    self.scrollInitalized = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollPreviewPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.scrollInitalized) {
        [self generateCurrentPage];
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
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if (self.scrollView.contentOffset.y > screenHeight * 1.4) {
            [self closePhotoSliderWithUp:true];
        } else if (self.scrollView.contentOffset.y < screenHeight * 0.6) {
            [self closePhotoSliderWithUp:false];
        }
        
    } else if (self.scrollMode == NKJPhotoSliderControllerScrollModeHorizontal) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.y = self.scrollPreviewPoint.y;
        scrollView.contentOffset = contentOffset;
    }
    
    [self generateCurrentPage];

}

- (void)generateCurrentPage
{
    if (self.visiblePageControl) {
        if (fmod(self.scrollView.contentOffset.x, self.scrollView.frame.size.width) == 0.0) {
            if (self.pageControl != nil) {
                self.pageControl.currentPage = (NSInteger)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
            }
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
        [self.delegate photoSliderControllerDidDismiss:self];
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
        
        if ([self respondsToSelector:@selector(photoSliderControllerDidDismiss:)]) {
            [self.delegate photoSliderControllerDidDismiss:self];
        }

    }];
}

- (NSBundle *)resourceBundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"NKJPhotoSliderController"
                                                           ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    return bundle;
}

@end
