//
//  NKJPhotoSliderProgressView.m
//  Pods
//
//  Created by nakajijapan on 4/24/15.
//
//

#import "NKJPhotoSliderProgressView.h"

@interface NKJPhotoSliderProgressView()
@property (nonatomic) CAShapeLayer  *progressLayer;
@end


@implementation NKJPhotoSliderProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self createInitialProgressLayer];
    [self createProgressLayer];
}

- (void)createInitialProgressLayer
{
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = M_PI_2 * 2 + M_PI_2 ;
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                             radius:20
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES].CGPath;
    self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.2].CGColor;
    self.progressLayer.lineWidth = 4.f;
    self.progressLayer.strokeStart = 0.f;
    self.progressLayer.strokeEnd = 1.f;
    [self.layer addSublayer:self.progressLayer];
}

- (void)createProgressLayer
{
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = M_PI_2 * 2 + M_PI_2 ;
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                             radius:20
                                                         startAngle:startAngle
                                                           endAngle:endAngle
                                                          clockwise:YES].CGPath;
    self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = 4.f;
    self.progressLayer.strokeStart = 0.f;
    self.progressLayer.strokeEnd = 0.f;
    self.progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.progressLayer];
}

- (void)animateCurveToProgress:(float)progress
{
    if (!self.progressLayer) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //animation.delegate = self;
    animation.fromValue = [NSNumber numberWithFloat:self.progressLayer.strokeEnd];
    animation.toValue = [NSNumber numberWithFloat:progress];
    animation.duration = 0.05;
    animation.fillMode = kCAFillModeForwards;
    self.progressLayer.strokeEnd = progress;
    [self.progressLayer addAnimation:animation forKey:@"strokeEnd"];
}

@end
