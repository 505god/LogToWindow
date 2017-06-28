//
//  LogToWindow.m
//  LogToWindow
//
//  Created by 邱成西 on 2017/6/28.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "LogToWindow.h"

#define DebugLog_RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LogToWindow ()

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableArray *logs;

@end

@implementation LogToWindow

#pragma mark -
#pragma mark - 单例

// [单例] 初始化
+ (instancetype)sharedInstance {
    
#if !DEBUG
    return nil;
#endif
    
    static LogToWindow __strong *debugLog = nil;
    
    @synchronized(self) {
        if (!debugLog)
            debugLog = [[LogToWindow alloc] init];
        
        return debugLog;
    }
}

#pragma mark -
#pragma mark - lifecycle,init

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 400)];
    
    if (self) {
        self.rootViewController = [UIViewController new];
        self.windowLevel = UIWindowLevelAlert;
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        self.userInteractionEnabled = NO;
        
        [self textView];
        
        [self logs];
    }
    
    return self;
}

#pragma mark -
#pragma mark - 输出、NSLog

//打印基本文本信息
-(void)printLog:(NSString *)format, ... {
    
    if (format.length == 0) {
        return;
    }
    
    @synchronized (self) {
        format = [NSString stringWithFormat:@"%@\n",format];
        va_list args, args_copy;
        va_start(args, format);
        va_copy(args_copy, args);
        va_end(args);
        va_end(args_copy);
        
        NSString *log_text = [[NSString alloc] initWithFormat:format arguments:args_copy];
        
#if (TARGET_IPHONE_SIMULATOR)
        NSLog(@"%@",log_text);
#else
        
#ifdef iPhoneTest
        [self refreshLogs:log_text];
#else
        NSLog(@"%@",log_text);
#endif
#endif
    }
}

//打印基本文本信息+行数
-(void)printWithLine:(NSInteger)line log:(NSString *)format, ... {
    if (format.length == 0) {
        return;
    }
    
    @synchronized (self) {
        format = [NSString stringWithFormat:@"[Line %ld]:%@\n",line,format];
        va_list args, args_copy;
        va_start(args, format);
        va_copy(args_copy, args);
        va_end(args);
        va_end(args_copy);
        
        NSString *log_text = [[NSString alloc] initWithFormat:format arguments:args_copy];
        
#if (TARGET_IPHONE_SIMULATOR)
        NSLog(@"%@",log_text);
#else
#ifdef iPhoneTest
        [self refreshLogs:log_text];
#else
        NSLog(@"%@",log_text);
#endif
#endif
    }
}

//打印基本文本信息+方法名
-(void)printWithMethod:(const char *)method log:(NSString *)format, ... {
    if (format.length == 0) {
        return;
    }
    
    @synchronized (self) {
        format = [NSString stringWithFormat:@"%s:%@\n",method,format];
        va_list args, args_copy;
        va_start(args, format);
        va_copy(args_copy, args);
        va_end(args);
        va_end(args_copy);
        
        NSString *log_text = [[NSString alloc] initWithFormat:format arguments:args_copy];
        
        log_text = [log_text substringWithRange:NSMakeRange(1, log_text.length-1)];
        
#if (TARGET_IPHONE_SIMULATOR)
        NSLog(@"%@",log_text);
#else
#ifdef iPhoneTest
        [self refreshLogs:log_text];
#else
        NSLog(@"%@",log_text);
#endif
#endif
    }
}

//打印基本文本信息+方法名+行数
-(void)printWithLine:(NSInteger)line method:(const char *)method log:(NSString *)format, ... {
    if (format.length == 0) {
        return;
    }
    
    @synchronized (self) {
        format = [NSString stringWithFormat:@"%s[Line %ld]:%@\n",method,line,format];
        va_list args, args_copy;
        va_start(args, format);
        va_copy(args_copy, args);
        va_end(args);
        va_end(args_copy);
        
        NSString *log_text = [[NSString alloc] initWithFormat:format arguments:args_copy];
        
        log_text = [log_text substringWithRange:NSMakeRange(1, log_text.length-1)];
        
#if (TARGET_IPHONE_SIMULATOR)
        NSLog(@"%@",log_text);
#else
#ifdef iPhoneTest
        [self refreshLogs:log_text];
#else
        NSLog(@"%@",log_text);
#endif
#endif
    }
}

-(void)refreshLogs:(NSString *)log_text {
    [self.logs addObject:log_text];
    
    if (self.logs.count > 30) {
        [self.logs removeObjectAtIndex:0];
    }
    
    if (self.hidden) {
        [[LogToWindow sharedInstance] setHidden:NO];
    }
    
    [self logDisplay];
}

#pragma mark -
#pragma mark - 清空数据

-(void)clear {
    self.textView.text = @"";
    self.logs = nil;
}

#pragma mark -
#pragma mark - UI

-(void)logDisplay {
    NSMutableAttributedString* attributedString = [NSMutableAttributedString new];
    
    for (NSString *log in self.logs) {
        if (log.length == 0) {
            return;
        }
        
        NSMutableAttributedString *logString = [[NSMutableAttributedString alloc] initWithString:log];
        [logString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, logString.length)];
        
        NSString *regTags = @"\\[[^\\]]+]";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        // 执行匹配的过程
        NSArray *array = [regex matchesInString:log
                                        options:0
                                          range:NSMakeRange(0, [log length])];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTextCheckingResult *math = (NSTextCheckingResult *)obj;
            NSRange range = [math range];
            
            if (idx == 0) {
                [logString addAttribute:NSForegroundColorAttributeName value:DebugLog_RGBOF(0xFF5F58) range:range];
            }else if (idx == 1) {
                [logString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
            }
        }];
        
        [attributedString appendAttributedString:logString];
    }
    
    __weak typeof(self)weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.textView.attributedText = attributedString;
        
        // scroll to bottom
        if(attributedString.length > 0) {
            NSRange bottom = NSMakeRange(attributedString.length - 1, 1);
            [weakself.textView scrollRangeToVisible:bottom];
        }
    });
    
}

#pragma mark -
#pragma mark - getter/setter


-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:self.bounds];
        _textView.font = [UIFont systemFontOfSize:12.0f];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.scrollsToTop = NO;
        [self addSubview:_textView];
    }
    return _textView;
}

-(NSMutableArray *)logs {
    if (!_logs) {
        _logs = [NSMutableArray array];
    }
    return _logs;
}

@end
