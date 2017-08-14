//
//  代码地址:https://github.com/SupermanChao/CATransaction-Demo
//  简书地址:http://www.jianshu.com/u/d6fe286d5fad
//
//  Created by 刘超 on 2017/8/8.
//  Copyright © 2017年 ogemray. All rights reserved.
//

#import "LCProgressView.h"

@interface LCProgressView ()

@property (nonatomic, strong) UILabel *progressLbl;

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *outLayer;

@property (nonatomic) dispatch_source_t timer;
@property (nonatomic, assign) int count;    //执行次数
@property (nonatomic, assign) float progress;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *pathwayColor;
@property (nonatomic, strong) UIColor *scheduleColor;
@property (nonatomic, copy) NSString *lineCap;
@property (nonatomic, strong) UIFont *progressFont;
@property (nonatomic, assign) NSTimeInterval totalTime;

@end

@implementation LCProgressView

- (instancetype)initWithFrame:(CGRect)frame andLineWidth:(CGFloat)lineWidth andPathwayColor:(UIColor *)pathwayColor andScheduleColor:(UIColor *)scheduleColor andScheduleCap:(NSString *)lineCap andProgressFont:(UIFont *)font andTime:(NSTimeInterval)time
{
    if (self = [super initWithFrame:frame]) {
        
        self.lineWidth = lineWidth;
        self.pathwayColor = pathwayColor;
        self.scheduleColor = scheduleColor;
        self.lineCap = lineCap;
        self.progressFont = font;
        self.totalTime = time;
        
        self.accuracy = LCAnimationAccuracyMid; //精确度默认为中等
        self.progress = 0;
        
        [self addSubview:self.progressLbl];
        [self.layer addSublayer:self.outLayer];
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

- (void)lc_starAnimation
{
    if (self.isAnimation || self.progress >= 99.99) return;
    dispatch_resume(self.timer);
    _isAnimation = YES;
}

- (void)lc_stopAnimation
{
    if (!self.isAnimation) return;
    dispatch_suspend(self.timer);
    _isAnimation = NO;
}

- (void)lc_backToBeginning
{
    self.progress = 0;
    self.progressLayer.strokeEnd = 0.001;
}

- (void)onTimer
{
    switch (self.accuracy) {
        case LCAnimationAccuracyLow:
            self.progress += 2;
            break;
        case LCAnimationAccuracyHeight:
            self.progress += 0.5;
            break;
        case LCAnimationAccuracyVeryHeight:
            self.progress += 0.1;
            break;
        default:
            self.progress += 1;
            break;
    }
    
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:self.totalTime / self.count];
    self.progressLayer.strokeEnd = self.progress / 100.0;
    [CATransaction commit];
    
    if (self.progress >= 99.99) {
        [self lc_stopAnimation];
        if ([self.delegate respondsToSelector:@selector(lc_animationFinishAction)]) {
            [self.delegate lc_animationFinishAction];
        }
    };
}

- (UILabel *)progressLbl
{
    if (!_progressLbl) {
        _progressLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _progressLbl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        _progressLbl.font = self.progressFont;
        _progressLbl.textAlignment = NSTextAlignmentCenter;
        _progressLbl.adjustsFontSizeToFitWidth = YES;
    }
    return _progressLbl;
}

- (UIBezierPath *)path
{
    if (!_path) {
        CGFloat radius = (MIN(self.frame.size.width, self.frame.size.height) - self.lineWidth) * 0.5;
        CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        _path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    }
    return _path;
}

- (CAShapeLayer *)outLayer
{
    if (!_outLayer) {
        _outLayer = [CAShapeLayer layer];
        _outLayer.lineWidth = self.lineWidth;
        _outLayer.fillColor = [UIColor clearColor].CGColor;
        _outLayer.strokeColor = self.pathwayColor.CGColor;
        _outLayer.path = self.path.CGPath;
    }
    return _outLayer;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.lineWidth = self.lineWidth;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeColor = self.scheduleColor.CGColor;
        _progressLayer.path = self.path.CGPath;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0.001;
    }
    return _progressLayer;
}

- (dispatch_source_t)timer
{
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        //设置定时器的开始时间 执行间隔 精确度
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, (self.totalTime / self.count) * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf onTimer];
            });            
        });
    }
    return _timer;
}

- (void)setAccuracy:(LCAnimationAccuracy)accuracy
{
    _accuracy = accuracy;
    
    switch (_accuracy) {
        case LCAnimationAccuracyLow:
            self.count = 50;
            break;
        case LCAnimationAccuracyHeight:
            self.count = 200;
            break;
        case LCAnimationAccuracyVeryHeight:
            self.count = 1000;
            break;
        default:
            self.count = 100;
            break;
    }
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    switch (self.accuracy) {
        case LCAnimationAccuracyLow:
            self.progressLbl.text = [NSString stringWithFormat:@"%d%%",(int)self.progress];
            break;
        case LCAnimationAccuracyHeight:
            self.progressLbl.text = [NSString stringWithFormat:@"%.1f%%",self.progress];
            break;
        case LCAnimationAccuracyVeryHeight:
            self.progressLbl.text = [NSString stringWithFormat:@"%.1f%%",self.progress];
            break;
        default:
            self.progressLbl.text = [NSString stringWithFormat:@"%d%%",(int)self.progress];
            break;
    }
}

- (void)dealloc
{
    dispatch_source_cancel(self.timer);
}

@end
