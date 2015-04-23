//
//  NKJPhotoSliderController.m
//  Pods
//
//  Created by nakajijapan on 4/13/15.
//
//

#import "NKJPhotoSliderController.h"
#import "NKJPhotoSliderCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NKJPhotoSliderController()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *imageURLs;
@property (nonatomic) CGPoint scrollPreviewPoint;
@end

@implementation NKJPhotoSliderController

- (id)initWithImageURLs:(NSArray *)imageURLs;
{
    self = [super init];
    if (self) {
        self.imageURLs = imageURLs;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    
    self.visiblePageControl = YES;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.7;
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
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.imageURLs > 0) {
        NSURL *imageURL = [NSURL URLWithString:self.imageURLs[indexPath.row]];
        [cell.imageView.imageView sd_setImageWithURL:imageURL];
        
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
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.collectionView.frame = CGRectMake(0, -screenHeight, screenWidth, screenHeight);
                             [self dismissViewControllerAnimated:YES completion:nil];
                         } completion:nil];
        return;
    } else if (scrollView.contentOffset.y < -100) {
        self.collectionView.frame = scrollView.frame;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.collectionView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight);
                             [self dismissViewControllerAnimated:YES completion:nil];
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

@end
