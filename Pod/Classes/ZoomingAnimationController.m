//
//  ZoomingAnimationController.m
//  Pods
//
//  Created by nakajijapan on 2015/10/26.
//
//

#import "ZoomingAnimationController.h"

@implementation ZoomingAnimationController

- (instancetype)initWithPresent:(BOOL)present
{
    self = [super init];
    if (self) {
        self.present = present;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.present) {
        [self animatePresenting:transitionContext];
    } else {
        [self animateDismiss:transitionContext];
    }
}

- (void)animatePresenting:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (void)animateDismiss:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}


@end
