//
//  OCTConsoleLogger.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTConsoleLogger.h"

@implementation OCTConsoleLogger


- (void)log:(NSString *)msg level:(OCTLogLevel)level {

    if (level < self.level) {
        return;
    }
    
    fprintf(stderr, "%s", [self.destination formattedMessageForMessage:msg level:level].UTF8String);
}

@end
