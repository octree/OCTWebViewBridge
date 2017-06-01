//
//  OCTLogger.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTLogger.h"

@interface OCTLogger ()

@property (strong, nonatomic) NSMutableArray *p_loggers;

@end

@implementation OCTLogger

- (void)log:(NSString *)msg {

    [self.p_loggers makeObjectsPerformSelector:@selector(log:) withObject:msg];
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
