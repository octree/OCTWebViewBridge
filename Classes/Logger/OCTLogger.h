//
//  OCTLogger.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCTLogger : NSObject

- (void)log:(NSString *)msg;
- (void)addLogger:(OCTLogger *)logger;

@end
