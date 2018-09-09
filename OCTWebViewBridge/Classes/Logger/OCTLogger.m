//
//  OCTLogger.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTLogger.h"
#import "OCTConsoleDestination.h"

@interface OCTLogger ()

@property (strong, nonatomic) NSMutableArray *p_loggers;

@end

@implementation OCTLogger

- (instancetype)init {

    if (self = [super init]) {
        
        self.destination = [[OCTConsoleDestination alloc] init];
    }
    return self;
}

- (void)log:(NSString *)msg {
    
    [self log:msg level:OCTLogLevelVerbose];
}

- (void)log:(NSString *)msg level:(OCTLogLevel)level {

    for (OCTLogger *logger in self.p_loggers) {
        [logger log:msg level:level];
    }
}


- (void)addLogger:(OCTLogger *)logger {

    [self.p_loggers addObject:logger];
}

#pragma mark - Accessor

- (NSMutableArray *)p_loggers {

    if (!_p_loggers) {
        
        _p_loggers = [NSMutableArray array];
    }
    return _p_loggers;
}

@end
