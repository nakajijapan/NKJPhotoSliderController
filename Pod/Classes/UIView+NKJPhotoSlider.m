//
//  UIView+NKJPhotoSlider.m
//  Pods
//
//  Created by nakajijapan on 2016/10/01.
//
//

#import "UIView+NKJPhotoSlider.h"

@implementation UIView (NKJPhotoSlider)

- (UIImage *)nkj_snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -self.frame.origin.x, -self.frame.origin.y);
    
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
