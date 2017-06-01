//
//  OCTConsoleLogger.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTConsoleLogger.h"

@implementation OCTConsoleLogger

- (void)log:(NSString *)msg {

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm ss";
    NSString *dateString = [formatter stringFromDate:date];
    NSString *log = [NSString stringWithFormat:@"🌶🐔 >>>>>>>>>>>>>>>>>>>>\n%@[🌎 WebView Log] 👉🏻\n%@\n\n", dateString, msg];
    fprintf(stderr, "%s", log.UTF8String);
}

@end
