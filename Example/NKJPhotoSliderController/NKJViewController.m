//
//  NKJViewController.m
//  NKJPhotoSliderController
//
//  Created by nakajijapan on 04/12/2015.
//  Copyright (c) 2014 nakajijapan. All rights reserved.
//

#import "NKJViewController.h"
#import <NKJPhotoSliderController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageCollectionViewCell.h"

@interface NKJViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    NKJPhotoSliderControllerDelegate,
    UIViewControllerTransitioningDelegate,
    NKJPhotoSliderZoomingAnimatedTransitioning
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UICollectionView *collectionView;

@property NSArray *images;
@end

@implementation NKJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.images = @[
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image001.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image002.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image003.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image004.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image005.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image006.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image007.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Resources/image008.jpg"]
                    ];

}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    if (self.collectionView != nil) {
        if (self.collectionView.collectionViewLayout != nil) {
            [self.collectionView.collectionViewLayout invalidateLayout];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell01"];
    self.collectionView = (UICollectionView *)[cell viewWithTag:1];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

        if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait ||
            [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
            return tableView.bounds.size.width;
        } else {
            return tableView.bounds.size.height;
        }
    }
    
    return 0.f;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"hcell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    [imageView sd_setImageWithURL:self.images[indexPath.row]];

    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NKJPhotoSliderController *photoSlider = [[NKJPhotoSliderController alloc] initWithImageURLs:self.images];
    //photoSlider.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //photoSlider.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    photoSlider.delegate = self;
    photoSlider.transitioningDelegate = self;
    photoSlider.currentPage = indexPath.row;
    //photoSlider.enableDynamicsAnimation = YES;
    
    [self presentViewController:photoSlider animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait ||
        [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width);
    } else {
        return CGSizeMake(self.tableView.bounds.size.width, collectionView.bounds.size.height);
    }

}

#pragma mark - NKJPhotoSliderZoomingAnimatedTransitioning

- (UIImageView *)transitionSourceImageView
{
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: cell.imageView.image];
    
    CGRect frame = cell.imageView.frame;
    frame.origin.y += 20;
    
    imageView.frame = frame;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return imageView;
}

- (void)transitionDestinationImageView:(UIImageView *)sourceImageView
{
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect frame = CGRectZero;
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait ||
        [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {

        if (sourceImageView.image.size.height < sourceImageView.image.size.width) {

            CGFloat width = (sourceImageView.image.size.width * sourceImageView.bounds.size.width) / sourceImageView.image.size.height;
            CGFloat x = width * 0.5f - CGRectGetWidth(cell.imageView.bounds) * 0.5f;
            frame = CGRectMake(- x, 0.f, width, CGRectGetHeight(cell.imageView.bounds));
            
        } else {
            frame = CGRectMake(0.f, 0.f, CGRectGetWidth(cell.imageView.bounds), CGRectGetHeight(cell.imageView.bounds));
        }
        
    } else {

        CGFloat height = (sourceImageView.image.size.height * CGRectGetWidth(cell.imageView.bounds)) / sourceImageView.image.size.width;
        CGFloat y = height * 0.5f - CGRectGetHeight(cell.imageView.bounds) * 0.5f;
        frame = CGRectMake(0.f, - y, CGRectGetWidth(cell.imageView.bounds), height);

    }
    
    sourceImageView.frame = frame;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    NKJPhotoSliderZoomingAnimator *animationController = [[NKJPhotoSliderZoomingAnimator alloc] initWithPresent:YES];
    animationController.sourceTransition = (id<NKJPhotoSliderZoomingAnimatedTransitioning>)source;
    animationController.destinationTransition = (id<NKJPhotoSliderZoomingAnimatedTransitioning>)presented;
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NKJPhotoSliderZoomingAnimator *animationController = [[NKJPhotoSliderZoomingAnimator alloc] initWithPresent:NO];
    animationController.sourceTransition = (id<NKJPhotoSliderZoomingAnimatedTransitioning>)dismissed;
    animationController.destinationTransition = (id<NKJPhotoSliderZoomingAnimatedTransitioning>)self;

    // for orientation
    if ([self respondsToSelector:@selector(animationControllerForDismissedController:)]) {
        self.view.frame = dismissed.view.bounds;
    }

    return animationController;
}


#pragma mark - UIContentContainer

// Deprecated Method(from iOS8)
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self traitCollectionDidChange:nil];
}

#pragma mark - UITraitEnvironment

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    if (self.collectionView != nil) {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
        self.collectionView.contentOffset = CGPointMake((CGFloat)indexPath.row * width , 0.f);
    }
}

#pragma mark - NKJPhotoSliderControllerDelegate

- (void)photoSliderControllerWillDismiss:(NKJPhotoSliderController *)viewController
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem: viewController.currentPage inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition: UICollectionViewScrollPositionNone animated:NO];
}

@end
