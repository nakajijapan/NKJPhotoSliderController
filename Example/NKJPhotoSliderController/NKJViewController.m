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

@interface NKJViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property IBOutlet UITableView *tableView;
@property NSArray *images;

@end

@implementation NKJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.images = @[
                    @"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image001.jpg",
                    @"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image002.jpg",
                    @"https://raw.githubusercontent.com/nakajijapan/PhotoSlider/master/Example/Resources/image003.jpg"
                    ];
    
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
    UICollectionView *collectionView = (UICollectionView *)[cell viewWithTag:1];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    return cell;
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
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]]];

    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NKJPhotoSliderController *slider = [[NKJPhotoSliderController alloc] initWithImageURLs:self.images];
    slider.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    slider.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    slider.index = indexPath.row;
    NSLog(@"idexPath row %ld", slider.index);
    [self presentViewController:slider animated:YES completion:nil];
}

@end
