//
//  OCTLogger.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCTLogLevel.h"
#import "OCTBaseDestination.h"

@interface OCTLogger : NSObject

@property (nonatomic) OCTLogLevel level;
@property (strong, nonatomic) OCTBaseDestination *destination;

- (void)log:(NSString *)msg;
- (void)log:(NSString *)msg level:(OCTLogLevel)level;
- (void)addLogger:(OCTLogger *)logger;

@end
