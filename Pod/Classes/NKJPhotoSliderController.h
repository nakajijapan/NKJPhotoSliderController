//
//  NKJPhotoSliderController.h
//  Pods
//
//  Created by nakajijapan on 4/13/15.
//
//

#import <UIKit/UIKit.h>

@class NKJPhotoSliderController;

@protocol NKJPhotoSliderControllerDelegate <NSObject>

@optional
- (void)photoSliderControllerWillDismiss:(NKJPhotoSliderController *)viewController;
- (void)photoSliderControllerDidDismiss:(NKJPhotoSliderController *)viewController;
@end

@interface NKJPhotoSliderController : UIViewController

@property (nonatomic) NSInteger index;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) BOOL visiblePageControl;
@property (nonatomic) BOOL visibleCloseButton;
@property (nonatomic) id<NKJPhotoSliderControllerDelegate> delegate;

- (id)initWithImageURLs:(NSArray *)imageURLs;

@end
