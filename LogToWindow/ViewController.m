//
//  ViewController.m
//  LogToWindow
//
//  Created by 邱成西 on 2017/6/28.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "ViewController.h"

#import "LogToWindow.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *str = @"test";
    
    CGFloat xx = 0.02;
    
    _TLog(@"%f",xx);
    
    _TLLog(@"%@",str);
    _TLog(@"%@",str);
    _TMLog(@"%@",str);
    _TLMLog(@"%@",str);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
