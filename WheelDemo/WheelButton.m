//
//  WheelButton.m
//  WheelDemo
//
//  Created by caramel on 5/27/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import "WheelButton.h"

@implementation WheelButton

/** 些方法用于返回自定button的imageView的frame的大小，有点类似于cell中返回cell的高度*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(14, 20, 40, 47);
}

@end
