//
//  ZoomingAnimationController.m
//  Pods
//
//  Created by nakajijapan on 2015/10/26.
//
//

#import "NKJPhotoSliderZoomingAnimator.h"
#import "UIView+NKJPhotoSlider.h"

@implementation NKJPhotoSliderZoomingAnimator

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
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIImageView *snapshotView = [[UIImageView alloc] initWithImage: [fromViewController.view nkj_snapshotImage]];
    [containerView addSubview:snapshotView];
    
    toViewController.view.alpha = 0.f;
    [containerView addSubview:toViewController.view];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:fromViewController.view.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.f;
    [containerView addSubview:backgroundView];
    
    UIImageView *sourceImageView = [self.sourceTransition transitionSourceImageView];
    [containerView addSubview:sourceImageView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self.destinationTransition transitionDestinationImageView:sourceImageView];
                         backgroundView.alpha = 1.f;
                         
                     } completion:^(BOOL finished) {
                        
                         sourceImageView.alpha = 0.f;
                         [sourceImageView removeFromSuperview];
                         
                         toViewController.view.alpha = 1.f;
                         [backgroundView removeFromSuperview];
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         
                     }];
    
}

- (void)animateDismiss:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    
    UIImageView *sourceImageView = [self.sourceTransition transitionSourceImageView];
    [containerView addSubview:sourceImageView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self.destinationTransition transitionDestinationImageView:sourceImageView];
                         fromViewController.view.alpha = 0.1f;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         sourceImageView.alpha = 0.f;
                         fromViewController.view.alpha = 0.f;
                         
                         [sourceImageView removeFromSuperview];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

                     }];
    
}


@end
