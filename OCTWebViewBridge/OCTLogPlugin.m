//
//  TDFLogBridge.m
//  TDFWebViewBridge
//
//  Created by Octree on 15/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTLogPlugin.h"

@implementation OCTLogPlugin

- (NSString *)identifier {
    
    return @"me.octree.bridge.log";
}

- (NSString *)javascriptCode {
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"log" ofType:@"js"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}


- (void)log:(id)msg {

    NSLog(@"WebView Bridge: %@", [msg description]);
}

@end
