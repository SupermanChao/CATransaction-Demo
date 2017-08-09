//
//  LCProgressVC.m
//  CATransaction-Demo
//
//  Created by 刘超 on 2017/8/9.
//  Copyright © 2017年 ogemray. All rights reserved.
//

#import "LCProgressVC.h"
#import "LCProgressView.h"

@interface LCProgressVC ()<LCProgressViewDelegate>

@property (nonatomic, strong) LCProgressView *progressView;

@property (nonatomic, strong) UIButton *btnStar;
@property (nonatomic, strong) UIButton *btnStop;
@property (nonatomic, strong) UIButton *btnClear;

@end

@implementation LCProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
}

- (void)initSubviews
{
    [self.view addSubview:self.progressView];
    
    [self.view addSubview:self.btnStar];
    [self.view addSubview:self.btnStop];
    [self.view addSubview:self.btnClear];
}

#pragma mark ------<Action>
- (void)starAnimationAction
{
    [self.progressView lc_starAnimation];
}

- (void)stopAnimationAction
{
    [self.progressView lc_stopAnimation];
}

- (void)comeBackBeginPositionAction
{
    [self.progressView lc_backToBeginning];
}

#pragma mark ------<LCProgressViewDelegate>
- (void)lc_animationFinishAction
{
    NSLog(@"达到终点,动画结束");
}

- (LCProgressView *)progressView
{
    if (!_progressView) {
        
        CGRect frame = CGRectMake(0, 0, 200, 200);
        CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5 - 50);
        CGFloat lineWidth = 10.0; //轨道宽度
        //轨道颜色
        UIColor *pathwayColor = [UIColor colorWithRed:201 / 255.0 green:240 / 255.0 blue:255 / 255.0 alpha:1.0];
        //进度颜色
        UIColor *scheduleColor = [UIColor colorWithRed:53 / 255.0 green:195 / 255.0 blue:248 / 255.0 alpha:1.0];
        //进度画笔两端边幅形状
        NSString *scheduleCap = kCALineCapRound;
        //中间进度提示文字大小
        UIFont *progressFont = [UIFont boldSystemFontOfSize:20];
        //转一圈时间
        NSTimeInterval time = 20.0;
        
        _progressView = [[LCProgressView alloc] initWithFrame:frame
                                                 andLineWidth:lineWidth
                                              andPathwayColor:pathwayColor
                                             andScheduleColor:scheduleColor
                                               andScheduleCap:scheduleCap
                                              andProgressFont:progressFont
                                                      andTime:time];
        _progressView.center = center;
        
        _progressView.accuracy = LCAnimationAccuracyMid;
        _progressView.delegate = self;
    }
    return _progressView;
}

- (UIButton *)btnStar
{
    if (!_btnStar) {
        _btnStar = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnStar.frame = CGRectMake(0, 0, 60, 30);
        _btnStar.center = CGPointMake(self.progressView.center.x, CGRectGetMaxY(self.progressView.frame) + 50);
        [_btnStar setTitle:@"开始" forState:UIControlStateNormal];
        [_btnStar addTarget:self action:@selector(starAnimationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnStar;
}

- (UIButton *)btnStop
{
    if (!_btnStop) {
        _btnStop = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnStop.frame = CGRectMake(0, 0, 60, 30);
        _btnStop.center = CGPointMake(self.progressView.center.x, CGRectGetMaxY(self.progressView.frame) + 90);
        [_btnStop setTitle:@"暂停" forState:UIControlStateNormal];
        [_btnStop addTarget:self action:@selector(stopAnimationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnStop;
}

- (UIButton *)btnClear
{
    if (!_btnClear) {
        _btnClear = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnClear.frame = CGRectMake(0, 0, 100, 30);
        _btnClear.center = CGPointMake(self.progressView.center.x, CGRectGetMaxY(self.progressView.frame) + 130);
        [_btnClear setTitle:@"回到起始位置" forState:UIControlStateNormal];
        [_btnClear addTarget:self action:@selector(comeBackBeginPositionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClear;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
