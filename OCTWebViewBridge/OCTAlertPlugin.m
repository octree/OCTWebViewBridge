//
//  TDFAlertBridge.m
//  TDFWebViewBridge
//
//  Created by Octree on 15/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTAlertPlugin.h"
#import <UIKit/UIKit.h>

@implementation OCTAlertPlugin

- (NSString *)identifier {

    return @"me.octree.bridge.alert";
}

- (NSString *)javascriptCode {

    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"alert" ofType:@"js"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (void)alert:(NSString *)msg confirm:(OCTResponseCallback)callback {

    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        callback(@{
                   @"hello": @"world"
                   });
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:avc animated:YES completion:nil];
}

@end
