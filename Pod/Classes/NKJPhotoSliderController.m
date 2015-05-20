//
//  NKJPhotoSliderController.m
//  Pods
//
//  Created by nakajijapan on 4/13/15.
//
//

#import "NKJPhotoSliderController.h"
#import "NKJPhotoSliderCollectionViewCell.h"

const

@interface NKJPhotoSliderController()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *imageURLs;
@property (nonatomic) CGPoint scrollPreviewPoint;
@property (nonatomic) UIButton *closeButton;
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
   
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backgroundView];
    
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
        NSURL *imageURL = [NSURL URLWithString:self.imageURLs[indexPath.row]];
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
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    if (scrollView.contentOffset.y > 100) {
        self.collectionView.frame = scrollView.frame;
        
        if ([self.delegate respondsToSelector:@selector(photoSliderControllerWillDismiss:)]) {
            [self.delegate photoSliderControllerWillDismiss:self];
        }
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.collectionView.frame = CGRectMake(0, -screenHeight, screenWidth, screenHeight);
                             [self dissmissViewController];
                         } completion:nil];
        return;
    } else if (scrollView.contentOffset.y < -100) {
        self.collectionView.frame = scrollView.frame;
        
        if ([self.delegate respondsToSelector:@selector(photoSliderControllerWillDismiss:)]) {
            [self.delegate photoSliderControllerWillDismiss:self];
        }

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.collectionView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
                             [self dissmissViewController];
                         } completion:nil];
        return;
    }
    
    CGFloat offsetX = fabs(scrollView.contentOffset.x - self.scrollPreviewPoint.x);
    CGFloat offsetY = fabs(scrollView.contentOffset.y - self.scrollPreviewPoint.y);
    
    if (offsetY > offsetX) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = self.scrollPreviewPoint.x;
        scrollView.contentOffset = contentOffset;
    } else {
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

#pragma mark - Button Actions

- (void)closeButtonDidTap:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(photoSliderControllerWillDismiss:)]) {
        [self.delegate photoSliderControllerWillDismiss:self];
    }
    
    [self dissmissViewController];
}

#pragma mark - Private Methods

- (void)dissmissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
