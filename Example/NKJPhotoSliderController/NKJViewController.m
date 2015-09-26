//
//  NKJViewController.m
//  NKJPhotoSliderController
//
//  Created by nakajijapan on 04/12/2015.
//  Copyright (c) 2014 nakajijapan. All rights reserved.
//

#import "NKJViewController.h"
#import "NKJPhotoSliderController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NKJViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    NKJPhotoSliderControllerDelegate
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
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image001.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image002.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image003.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image004.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image005.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image006.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image007.jpg"],
                    [NSURL URLWithString:@"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image008.jpg"]
                    ];

}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLayoutSubviews
{
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hcell" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    [imageView sd_setImageWithURL:self.images[indexPath.row]];

    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NKJPhotoSliderController *photoSlider = [[NKJPhotoSliderController alloc] initWithImageURLs:self.images];
    photoSlider.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    photoSlider.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    photoSlider.delegate = self;
    photoSlider.currentPage = indexPath.row;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self presentViewController:photoSlider animated:YES completion:nil];
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

#pragma mark - UIContentContainer

// Deprecated Method(from iOS8)
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self traitCollectionDidChange:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    NSIndexPath *indexPath = (NSIndexPath *)[self.collectionView indexPathsForVisibleItems].firstObject;
    self.collectionView.contentOffset = CGPointMake((CGFloat)indexPath.row * width , 0.f);
}

#pragma mark - NKJPhotoSliderControllerDelegate

- (void)photoSliderControllerWillDismiss:(NKJPhotoSliderController *)viewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

@end
