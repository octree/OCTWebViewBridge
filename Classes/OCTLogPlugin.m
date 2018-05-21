//
//  OCTLogPlugin.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTLogPlugin.h"
#import "OCTLogger.h"

@implementation OCTLogPlugin

- (NSString *)identifier {
    
    return @"me.octree.bridge.log";
}

- (NSString *)javascriptCode {
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"log_plugin" ofType:@"js"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (void)log:(NSString *)msg {
    
    [self.logger log:msg];
}

- (void)log:(NSString *)msg level:(NSNumber *)level {
    
    [self.logger log:msg level:[level integerValue]];
}

- (OCTWebViewPluginInjectionTime)injectionTime {
    
    return OCTWebViewPluginInjectionTimeAtDocumentStart;
}

@end
