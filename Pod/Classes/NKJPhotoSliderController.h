//
//  NKJPhotoSliderController.h
//  Pods
//
//  Created by nakajijapan on 4/13/15.
//
//

#import <UIKit/UIKit.h>

@interface NKJPhotoSliderController : UIViewController

@property (nonatomic) NSInteger index;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) BOOL visiblePageControl;

- (id)initWithImageURLs:(NSArray *)imageURLs;

@end
