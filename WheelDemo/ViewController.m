//
//  ViewController.m
//  WheelDemo
//
//  Created by caramel on 5/27/15.
//  Copyright (c) 2015 caramel. All rights reserved.
//

#import "ViewController.h"
#import "WheelView.h"


@interface ViewController ()

@property (weak, nonatomic) WheelView *wheelView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WheelView *wheelView = [WheelView wheelView];
    
    wheelView.center = self.view.center;
    
    [self.view addSubview:wheelView];
    
    self.wheelView = wheelView;
}

- (IBAction)runClick
{
    [self.wheelView animationStart];
}

- (IBAction)stopClick
{
    [self.wheelView animationStop];
}

@end
