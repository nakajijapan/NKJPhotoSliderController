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

- (id)initWithImageURLs:(NSArray *)imageURLs;

@end
