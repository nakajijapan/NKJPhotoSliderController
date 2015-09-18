//
//  NKJPhotoSliderImageView.h
//  Pods
//
//  Created by nakajijapan on 4/12/15.
//
//

#import <UIKit/UIKit.h>

@protocol NKJPhotoSliderImageViewDelegate;

@interface NKJPhotoSliderImageView : UIImageView

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) id<NKJPhotoSliderImageViewDelegate> delegate;
- (void)loadImage:(NSURL *)imageURL;
@end

@protocol NKJPhotoSliderImageViewDelegate <NSObject>
@optional
- (void)photoSliderImageViewDidDoubleTap:(NKJPhotoSliderImageView *)imageView atScale:(CGFloat)scale;
@end
