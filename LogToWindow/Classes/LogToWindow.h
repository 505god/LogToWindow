//
//  LogToWindow.h
//  LogToWindow
//
//  Created by 邱成西 on 2017/6/28.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
//文本
#define _TLog(format, ...)  [[LogToWindow sharedInstance] printLog:format,##__VA_ARGS__];
//文本+行数
#define _TLLog(format, ...)  [[LogToWindow sharedInstance] printWithLine:__LINE__ log:format,##__VA_ARGS__];
//文本+方法
#define _TMLog(format, ...)  [[LogToWindow sharedInstance] printWithMethod:__func__ log:format,##__VA_ARGS__];
//文本+行数+方法
#define _TLMLog(format, ...)  [[LogToWindow sharedInstance] printWithLine:__LINE__ method:__func__ log:format,##__VA_ARGS__];

#else

#define _TLog(format, ...)
#define _TLLog(format, ...)
#define _TMLog(format, ...)
#define _TLMLog(format, ...)

#endif

/*
 1. 需要在window输出，需要在AppDelegate或pch文件加：
 #define iPhoneTest
 
 2. 初始化
 + (instancetype)sharedInstance
 
 3. 输出 log
 -(void)printLog....
 
 4. 如需清空 log
 -(void)clear
 */

@interface LogToWindow : UIWindow

// [单例] 初始化
+ (instancetype)sharedInstance;

//打印基本文本信息
-(void)printLog:(NSString *)format, ...;

//打印基本文本信息+行数
-(void)printWithLine:(NSInteger)line log:(NSString *)format, ...;

//打印基本文本信息+方法名
-(void)printWithMethod:(const char *)method log:(NSString *)format, ...;

//打印基本文本信息+方法名+行数
-(void)printWithLine:(NSInteger)line method:(const char *)method log:(NSString *)format, ...;

//清空 log
-(void)clear;

@end
