//
//  NKJPhotoSliderController.m
//  Pods
//
//  Created by nakajijapan on 4/13/15.
//
//

#import "NKJPhotoSliderController.h"
#import "NKJPhotoSliderCollectionViewCell.h"

typedef enum : NSUInteger {
    NKJPhotoSliderControllerScrollModeNone = 0,
    NKJPhotoSliderControllerScrollModeVertical,
    NKJPhotoSliderControllerScrollModeHorizontal,
} NKJPhotoSliderControllerScrollMode;

@interface NKJPhotoSliderController()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *imageURLs;
@property (nonatomic) CGPoint scrollPreviewPoint;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) NKJPhotoSliderControllerScrollMode scrollMode;
@end

@implementation NKJPhotoSliderController

- (id)initWithImageURLs:(NSArray *)imageURLs;
{
    self = [super init];
    if (self) {
        self.imageURLs = imageURLs;
        self.visiblePageControl = YES;
        self.visibleCloseButton = YES;
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
    
    // collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
    [self.collectionView registerClass:[NKJPhotoSliderCollectionViewCell class]
            forCellWithReuseIdentifier:@"cell"];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = YES;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    
    if (self.visiblePageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 22)];
        self.pageControl.numberOfPages = self.imageURLs.count;
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NKJPhotoSliderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    if (self.imageURLs > 0) {
        NSURL *imageURL = self.imageURLs[indexPath.row];
        [cell loadImageWithURL:imageURL];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollPreviewPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
        CGFloat alpha = 1.0 - (fabs(scrollView.contentOffset.y * 2.f) / (scrollView.frame.size.height / 2));
        self.backgroundView.alpha = alpha;
        
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = self.scrollPreviewPoint.x;
        scrollView.contentOffset = contentOffset;
    } else if (self.scrollMode == NKJPhotoSliderControllerScrollModeHorizontal) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.y = self.scrollPreviewPoint.y;
        scrollView.contentOffset = contentOffset;
    }

    
    if (self.visiblePageControl) {
        if (fmod(scrollView.contentOffset.x, scrollView.frame.size.width) == 0.0) {
            self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollMode == NKJPhotoSliderControllerScrollModeVertical) {

        CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        
        CGPoint velocity = [[scrollView panGestureRecognizer] velocityInView:scrollView];

        if (velocity.y < -500.f) {
            self.collectionView.frame = scrollView.frame;
            
            if ([self.delegate respondsToSelector:@selector(photoSliderControllerWillDismiss:)]) {
                [self.delegate photoSliderControllerWillDismiss:self];
            }
            
            [UIView animateWithDuration:0.25 delay:0.f options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.collectionView.frame = CGRectMake(0, -screenHeight, screenWidth, screenHeight);
                                 self.backgroundView.alpha = 0.f;
                                 self.view.alpha = 0.f;
                             }
                             completion:^(BOOL finished) {
                                 [self dissmissViewControllerAnimated:NO];
                             }];
        } else if (velocity.y > 500.f) {
            self.collectionView.frame = scrollView.frame;
            
            if ([self.delegate respondsToSelector:@selector(photoSliderControllerWillDismiss:)]) {
                [self.delegate photoSliderControllerWillDismiss:self];
            }
            
            [UIView animateWithDuration:0.25 delay:0.f options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.collectionView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
                                 self.backgroundView.alpha = 0.f;
                                 self.view.alpha = 0.f;
                             }
                             completion:^(BOOL finished) {
                                 [self dissmissViewControllerAnimated:NO];
                             }];
        }
    }
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
