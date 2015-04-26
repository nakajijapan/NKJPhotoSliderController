//
//  NKJPhotoSlideCollectionViewCell.h
//  Pods
//
//  Created by nakajijapan on 4/12/15.
//
//

#import <UIKit/UIKit.h>
#import "NKJPhotoSliderImageView.h"
#import "NKJPhotoSliderProgressView.h"

@interface NKJPhotoSliderCollectionViewCell : UICollectionViewCell

@property (nonatomic) NKJPhotoSliderImageView *imageView;
@property (nonatomic) NKJPhotoSliderProgressView *progressView;

- (void)loadImageWithURL:(NSURL *)imageURL;

@end
