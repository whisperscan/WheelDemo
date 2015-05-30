//
//  WheelView.m
//  WheelDemo
//
//  Created by caramel on 5/27/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import "WheelView.h"
#import "WheelButton.h"

#define CAAngle     30
#define angle2radian(x)     ((x) / 180.0 * M_PI)


@interface WheelView ()

@property (weak, nonatomic) IBOutlet UIImageView *rotateWheel;
@property (weak, nonatomic) UIButton *selectedButton;
@property (strong, nonatomic) CADisplayLink *link;

@end

@implementation WheelView

#pragma mark - 定时器的懒加载

- (CADisplayLink *)link
{
    if(_link == nil)
    {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return _link;
}

#pragma mark - 类方法加载view从xib中

+ (instancetype)wheelView
{
    return [[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil][0];
}

#pragma mark - 初始化设置

/** awakeFromNib执行的时候连线已经关联了xib内的控件*/
- (void)awakeFromNib
{
    // 设置rotateWheel可以进行用户交互
    self.rotateWheel.userInteractionEnabled = YES;
    
    // 添加十二个按钮到rotateWheel中
    [self addButton];
}

- (void)addButton
{
    NSLog(@"%s",__func__);
    for(NSInteger i = 0;i < 12;++i)
    {
        WheelButton *button = [[WheelButton alloc]init];
        
        // 设置按钮属性
        [self setButtonProperty:button];
        
        // 设置按钮旋转角度
        [self setButtonRotation:button withIndex:i];
        
        // 设置按钮图片
        [self setButtonImage:button withIndex:i];
        
        // 如果是第一按钮让第一个按钮选中
        if(i == 0)      [self buttonClick:button];
        
        // 绑定按钮事件
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rotateWheel addSubview:button];
    }
}

/** 设置按钮属性*/
- (void)setButtonProperty:(WheelButton *)button
{
    // 设置button的锚点
    button.layer.anchorPoint = CGPointMake(0.5, 1);
    
    // 设置button的position
    button.layer.position = CGPointMake(self.rotateWheel.bounds.size.width * 0.5, self.rotateWheel.bounds.size.height * 0.5);
    
    // 设置button的bounds
    button.bounds = CGRectMake(0, 0, 68, 143);

}

/** 设置按钮旋转角度*/
- (void)setButtonRotation:(WheelButton *)button withIndex:(NSInteger)index
{
    // 旋转按钮
    button.transform = CGAffineTransformMakeRotation(angle2radian(index * CAAngle));
}

/** 设置按钮图片*/
- (void)setButtonImage:(WheelButton *)button withIndex:(NSInteger)index
{
    // 设置按钮选中时的背影图片
    [button setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
    
    // 获取按钮图片，然后裁剪
    UIImage *normalStateBigImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *selectedStateBigImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    CGFloat imageW = normalStateBigImage.size.width / 12 * [UIScreen mainScreen].scale;
    CGFloat imageH = normalStateBigImage.size.height * [UIScreen mainScreen].scale;
    
    CGRect clipRect = CGRectMake(imageW * index, 0, imageW, imageH);
    
    // CGImage格式
    CGImageRef normalStateRealImageCG = CGImageCreateWithImageInRect(normalStateBigImage.CGImage, clipRect);
    CGImageRef selectedStateRealImageCG = CGImageCreateWithImageInRect(selectedStateBigImage.CGImage, clipRect);
    
    // UIImage格式
    UIImage *normalStateRealImage = [UIImage imageWithCGImage:normalStateRealImageCG];
    UIImage *selectedStateRealImage = [UIImage imageWithCGImage:selectedStateRealImageCG];
    
    // 设置按钮正常/选择状态下的图片
    [button setImage:normalStateRealImage forState:UIControlStateNormal];
    [button setImage:selectedStateRealImage forState:UIControlStateSelected];
}

- (void)buttonClick:(UIButton *)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}


#pragma mark - center button 监听事件

- (IBAction)centerButtonClick:(UIButton *)sender
{
    NSLog(@"%s",__func__);
    
    // 停止时钟
    [self animationStop];
    
    // 停止rotateWheel用户交互
    self.rotateWheel.userInteractionEnabled = NO;
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.rotation";
    
    anim.toValue = @(M_PI * 4);
    
    anim.duration = 0.5;
    
    anim.delegate = self;
    
    [self.rotateWheel.layer addAnimation:anim forKey:nil];
}

# pragma mark - 核心动画停止

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 开启rotateWheel的用户交互
    self.rotateWheel.userInteractionEnabled = YES;
    
    // 将选择的按钮旋转最上方
    CGFloat radian = atan2(self.selectedButton.transform.b, self.selectedButton.transform.a);
    
    self.rotateWheel.transform = CGAffineTransformMakeRotation(-radian);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animationStart];
    });
}


#pragma mark - 对外方法 开始/停止旋转

- (void)animationStart
{
    self.link.paused = NO;
}

- (void)rotation
{
    // CADisplayLink第秒运行60次
    self.rotateWheel.transform = CGAffineTransformRotate(self.rotateWheel.transform, angle2radian(0.75));
    
}

- (void)animationStop
{
    self.link.paused = YES;
}

@end
