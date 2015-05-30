//
//  WheelView.h
//  WheelDemo
//
//  Created by caramel on 5/27/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WheelView : UIView

/** 类方法返回一个转盘的view*/
+ (instancetype)wheelView;

/** 如果调用转盘开始旋转*/
- (void)animationStart;

/** 如果调用转盘停止旋转*/
- (void)animationStop;

@end
