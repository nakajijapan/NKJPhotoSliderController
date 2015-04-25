//
//  NKJPhotoSliderProgressView.m
//  Pods
//
//  Created by nakajijapan on 4/24/15.
//
//

#import "NKJPhotoSliderProgressView.h"

@interface NKJPhotoSliderProgressView()
@property (nonatomic) CAShapeLayer  *indicator;
@property (nonatomic) CAShapeLayer  *progressLayer;
@property (nonatomic) CAShapeLayer  *circleLayer;
@end


@implementation NKJPhotoSliderProgressView

- (void)drawRect:(CGRect)rect
{
    [self createProgressLayer];
}

- (void)createProgressLayer
{
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = M_PI_2 * 2 + M_PI_2 ;
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2 , CGRectGetHeight(self.frame)/2);
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                             radius:100
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:true].CGPath;
    self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.progressLayer.fillColor = [UIColor greenColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = 10.0;
    self.progressLayer.strokeStart = 0.0;
    self.progressLayer.strokeEnd = 0.0;
    self.progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.progressLayer];
}

- (void)animateCurveToProgress:(float)progress
{
    NSLog(@"start");
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.delegate = self;
    animation.fromValue = [NSNumber numberWithFloat:self.progressLayer.strokeEnd];
    animation.toValue = [NSNumber numberWithFloat:progress];
    animation.duration = 0.1;
    animation.fillMode = kCAFillModeForwards;
    self.progressLayer.strokeEnd = progress;
    self.progressLayer.strokeColor = [UIColor yellowColor].CGColor;
    
    [self.progressLayer addAnimation:animation forKey:@"strokeEnd"];
}

- (void)animationDidStart:(CAAnimation *)theAnimation
{
    NSLog(@"animation start");
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSLog(@"animation stop");
}

@end
