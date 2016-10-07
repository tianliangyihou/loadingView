//
//  LLBLoadingView.m
//  loadingView
//
//  Created by llb on 16/10/5.
//  Copyright © 2016年 llb. All rights reserved.
//

#import "LLBLoadingView.h"

#define DEGREES(degrees) ((M_PI * (degrees))/180.f)

@interface LLBLoadingView ()

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, strong)CAGradientLayer *gradientLayer;

@property (nonatomic, strong)CAShapeLayer *shapeLayer;

@end


@implementation LLBLoadingView

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerForDo) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGradientLayer];
        [self initShapeLayer];
        [self timer];
    }
    return self;
}

- (void)initGradientLayer {

    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    colorLayer.frame = self.bounds;
    colorLayer.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height /2.0);
    colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor whiteColor].CGColor,
                          (__bridge id)[UIColor redColor].CGColor];
    colorLayer.locations = @[@(-0.2),@(-0.1),@(0)];
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:colorLayer];
    _gradientLayer = colorLayer;
    
}
- (void)initShapeLayer {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    CGFloat macRadius = MIN(self.frame.size.width,  self.frame.size.height) /2.0 - 4;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:macRadius startAngle:DEGREES(0) endAngle:DEGREES(360) clockwise:YES];
    circleLayer.path = path.CGPath;
    circleLayer.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height /2.0);
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.lineDashPattern = nil;
    circleLayer.strokeEnd = 1.f;
//    [circleLayer setLineWidth:10];
    _shapeLayer = circleLayer;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    _gradientLayer.mask = _shapeLayer;

}

static int i = 0;
- (void)timerForDo {
       if (i ++ %2 == 0) {
           CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
           fadeAinmation.fromValue = @[@(-0.2), @(-0.1),@(0)];
           fadeAinmation.toValue = @[@(1.0),@(1.1),@(1.2)];
           fadeAinmation.duration = 1.5;
           [_gradientLayer addAnimation:fadeAinmation forKey:nil];
       }else {
       
           CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
           fadeAinmation.toValue = @[@(-0.2), @(-0.1),@(0)];
           fadeAinmation.fromValue = @[@(1.0),@(1.1),@(1.2)];
           fadeAinmation.duration = 1.5;
           [_gradientLayer addAnimation:fadeAinmation forKey:nil];
       }
}

@end
