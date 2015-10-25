//
//  ZoomingAnimationController.h
//  Pods
//
//  Created by nakajijapan on 2015/10/26.
//
//

#import <Foundation/Foundation.h>

@protocol ZoomingAnimationControllerTransitioning <NSObject>

- (UIImageView *)transitionSourceImageView;
- (CGRect)transitionDestinationImageViewFrame;

@end

@interface ZoomingAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL present;
@property (nonatomic) id<ZoomingAnimationControllerTransitioning> sourceTransition;
@property (nonatomic) id<ZoomingAnimationControllerTransitioning> destinationTransition;

@end
