//
//  LCProgressView.h
//  CATransaction-Demo
//
//  Created by 刘超 on 2017/8/8.
//  Copyright © 2017年 ogemray. All rights reserved.
//

#import <UIKit/UIKit.h>

///动画精确度三个档次
typedef NS_ENUM(NSInteger, LCAnimationAccuracy) {
    
    LCAnimationAccuracyLow = 0,
    LCAnimationAccuracyMid = 1,
    LCAnimationAccuracyHeight = 2,
    LCAnimationAccuracyVeryHeight = 3
};

@protocol LCProgressViewDelegate <NSObject>

- (void)lc_animationFinishAction;

@end

@interface LCProgressView : UIView

///动画进度精确度 默认为LCAnimationAccuracyMid
@property (nonatomic, assign) LCAnimationAccuracy accuracy;

@property (nonatomic, readonly, assign) BOOL isAnimation; //记录是否正在动画

@property (nonatomic, assign) id<LCProgressViewDelegate> delegate;

/**
 *  @brief  进度视图初始化
 *
 *  @param  frame           位置
 *  @param  lineWidth       圆环宽度
 *  @param  pathwayColor    跑道颜色
 *  @param  scheduleColor   进度颜色
 *  @param  lineCap         进度边幅形状 (枚举:kCALineCapButt / kCALineCapRound / kCALineCapSquare)
 *  @param  font            中间进度提示文字大小
 *  @param  time            运行一周时间
 *
 *  @return 返回初始化的本类实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                 andLineWidth:(CGFloat)lineWidth
              andPathwayColor:(UIColor *)pathwayColor
             andScheduleColor:(UIColor *)scheduleColor
               andScheduleCap:(NSString *)lineCap
              andProgressFont:(UIFont *)font
                      andTime:(NSTimeInterval)time;

///开始动画
- (void)lc_starAnimation;

///暂停动画
- (void)lc_stopAnimation;

///回到开始位置,进度回到开始位置
- (void)lc_backToBeginning;

@end
