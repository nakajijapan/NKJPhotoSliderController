//
//  ZoomingAnimationController.h
//  Pods
//
//  Created by nakajijapan on 2015/10/26.
//
//

#import <Foundation/Foundation.h>

@protocol NKJPhotoSliderZoomingAnimatedTransitioning <NSObject>

- (UIImageView *)transitionSourceImageView;
- (CGRect)transitionDestinationImageViewFrameWithSourceImageView:(UIImageView *)sourceImageView;

@end

@interface NKJPhotoSliderZoomingAnimator : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithPresent:(BOOL)present;
@property (nonatomic) BOOL present;
@property (nonatomic) id<NKJPhotoSliderZoomingAnimatedTransitioning> sourceTransition;
@property (nonatomic) id<NKJPhotoSliderZoomingAnimatedTransitioning> destinationTransition;

@end
