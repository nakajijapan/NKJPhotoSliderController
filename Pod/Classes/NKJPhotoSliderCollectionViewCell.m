//
//  NKJPhotoSlideCollectionViewCell.m
//  Pods
//
//  Created by nakajijapan on 4/12/15.
//
//

#import "NKJPhotoSliderCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    self.progressView = [[NKJPhotoSliderProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    self.progressView.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    self.progressView.hidden = YES;
    [self addSubview:self.progressView];
}

- (void)loadImageWithURL:(NSURL *)imageURL
{
    self.progressView.hidden = NO;
    [self.imageView.imageView sd_setImageWithURL:imageURL
                                placeholderImage:nil
                                         options:SDWebImageCacheMemoryOnly
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                            CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
                                            [self.progressView animateCurveToProgress:progress];
                                        }
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           self.progressView.hidden = YES;
                                       }];
}

@end
