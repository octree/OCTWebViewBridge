//
//  OCTConsoleDestination.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTConsoleDestination.h"

@implementation OCTConsoleDestination


- (NSString *)formattedMessageForMessage:(NSString *)msg level:(OCTLogLevel)level {

    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm ss";
    NSString *dateString = [formatter stringFromDate:date];
    NSString *levelTitle = [self titleForLevel:level];
    NSString *levelBadge = [self badgeForLevel:level];
    return [NSString stringWithFormat:@"🌎 >>>>>>>>>>>>>>>>>>>>\n%@ %@ [%@] 👉🏻\n%@\n\n", dateString, levelBadge, levelTitle, msg];
}


@end
