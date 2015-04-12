//
//  NKJPhotoSlideCollectionViewCell.m
//  Pods
//
//  Created by nakajijapan on 4/12/15.
//
//

#import "NKJPhotoSliderCollectionViewCell.h"

@implementation NKJPhotoSliderCollectionViewCell

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
    self.imageView = [[NKJPhotoSliderImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageView];
}

@end
