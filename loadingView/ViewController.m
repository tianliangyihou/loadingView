//
//  ViewController.m
//  loadingView
//
//  Created by llb on 16/10/5.
//  Copyright © 2016年 llb. All rights reserved.
//

#import "ViewController.h"
#import "LLBLoadingView.h"

#define MINLINE_FLOAT 0.000000001

@interface ViewController ()

@property (nonatomic ,strong)CAGradientLayer *layer1;

@property (nonatomic ,strong)NSTimer *timer1;

@property (nonatomic ,strong)CAGradientLayer *layer2;

@property (nonatomic ,strong)NSTimer *timer2;

@property (nonatomic ,strong)CAGradientLayer *layer3;

@property (nonatomic ,strong)NSTimer *timer3;


@end

@implementation ViewController

- (NSTimer *)timer1 {
    if (!_timer1) {
        _timer1 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeFrame1) userInfo:nil repeats:YES];
    }
    return _timer1;
}
- (NSTimer *)timer2 {
    if (!_timer2) {
        _timer2 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeFrame2) userInfo:nil repeats:YES];
    }
    return _timer2;
}
- (NSTimer *)timer3 {
    if (!_timer3) {
        _timer3 = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeFrame3) userInfo:nil repeats:YES];
    }
    return _timer3;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layerWithTag:0];
    [self layerWithTag:1];
    [self layerWithTag:2];

    LLBLoadingView *loadingView = [[LLBLoadingView alloc]initWithFrame:CGRectMake(87.5, 240, 200, 200)];
    loadingView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:loadingView];
    
}
- (void)layerWithTag:(int)tag {

    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"知我者谓我心忧，不知我者谓我何求";
    label.frame = CGRectMake(0, 60 + (20 + 40) *tag , 375, 40);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    // 疑问：label只是用来做文字裁剪，能否不添加到view上。
    // 必须要把Label添加到view上，如果不添加到view上，label的图层就不会调用drawRect方法绘制文字，也就没有文字裁剪了。
    // 如何验证，自定义Label,重写drawRect方法，看是否调用,发现不添加上去，就不会调用
    [self.view addSubview:label];
    
    // 创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = label.frame;
    
    switch (tag) {
        case 0:
        {
//             设置渐变层的颜色，随机颜色渐变 ```````````````1111111111111111````````````````
                gradientLayer.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor clearColor].CGColor];
                gradientLayer.locations = @[@(-0.00001),@(0)]; //这是用来上一个动画的
            _layer1 =gradientLayer;

        }
            break;
        case 1:
        {
            // 设置渐变层的颜色，随机颜色渐变 ```````````````22222222222222222````````````````
                gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor redColor].CGColor,(id)[UIColor clearColor].CGColor];
                gradientLayer.locations = @[@(-0.2),@(-0.1),@(-0)];
            _layer2 =gradientLayer;

        }
            break;
        case 2:
        {
            // 设置渐变层的颜色，随机颜色渐变 ```````````````3333333333333333333````````````````

            gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor redColor].CGColor,(id)[UIColor redColor].CGColor,(id)[UIColor blackColor].CGColor];
            gradientLayer.locations = @[@( -0.1-MINLINE_FLOAT),@(-0.1),@(0 - MINLINE_FLOAT),@(0)];
            _layer3 =gradientLayer;
        
        }
            break;
        default:
            break;
    }
    // 疑问:渐变层能不能加在label上
    // 不能，mask原理：默认会显示mask层底部的内容，如果渐变层放在mask层上，就不会显示了
    
    // 添加渐变层到控制器的view图层上
    [self.view.layer addSublayer:gradientLayer];
    
    // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
    // 设置渐变层的裁剪层
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.mask = label.layer;
    
    // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层，这样做的目的：以渐变层为坐标系，方便计算裁剪区域，如果以其他层为坐标系，还需要做点的转换，需要把别的坐标系上的点，转换成自己坐标系上点，判断当前点在不在裁剪范围内，比较麻烦。
    
    
    // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
    label.frame = gradientLayer.bounds;
    
    // 利用定时器，快速的切换渐变颜色，就有文字颜色变化效果
    if (tag == 0) {
        [self timer1];
    }else if (tag == 1)
    {
        [self timer2];
    }else {
        [self timer3];
    }
}







static int i = 0;
- (void)changeFrame1 {
    if (i ++ %2 == 0) {
        CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
        fadeAinmation.fromValue = @[@(-0.00001), @(0)];
        fadeAinmation.toValue = @[@(1),@(1.00001)];
        fadeAinmation.duration = 3;
        [_layer1 addAnimation:fadeAinmation forKey:nil];
    }else {
        
        CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
        fadeAinmation.toValue = @[@(-0.00001), @(0)];
        fadeAinmation.fromValue = @[@(1),@(1.00001)];
        fadeAinmation.duration = 3;
        [_layer1 addAnimation:fadeAinmation forKey:nil];
    }
}


static int j = 0;
- (void)changeFrame2 {
    if (j ++ %2 == 0) {
        CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
        fadeAinmation.fromValue = @[@(-0.2),@(-0.1),@(-0)];
        fadeAinmation.toValue = @[@(1),@(1.1),@(1.2)];
        fadeAinmation.duration = 3;
        [_layer2 addAnimation:fadeAinmation forKey:nil];
    }else {

        CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
        fadeAinmation.toValue = @[@(-0.2),@(-0.1),@(-0)];
        fadeAinmation.fromValue = @[@(1),@(1.1),@(1.2)];
        fadeAinmation.duration = 3;
        [_layer2 addAnimation:fadeAinmation forKey:nil];
    }
}


static int k = 0;
- (void)changeFrame3 {
    if (k ++ %2 == 0) {
        CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
        fadeAinmation.fromValue =  @[@( -0.1-MINLINE_FLOAT),@(-0.1),@(0 - MINLINE_FLOAT),@(0)];        fadeAinmation.toValue =  @[@(1),@(1+MINLINE_FLOAT),@(1.1),@(1.1 + MINLINE_FLOAT)];
        fadeAinmation.duration = 3;
        [_layer3 addAnimation:fadeAinmation forKey:nil];
    }else {

        CABasicAnimation *fadeAinmation = [CABasicAnimation animationWithKeyPath:@"locations"];
        fadeAinmation.toValue = @[@( -0.1-MINLINE_FLOAT),@(-0.1),@(0 - MINLINE_FLOAT),@(0)];          fadeAinmation.fromValue =  @[@(1),@(1+MINLINE_FLOAT),@(1.1),@(1.1 + MINLINE_FLOAT)];
        fadeAinmation.duration = 3;
        [_layer3 addAnimation:fadeAinmation forKey:nil];
    }
}
@end
