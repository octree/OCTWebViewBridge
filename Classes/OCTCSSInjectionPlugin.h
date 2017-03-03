//
//  OCTCSSInjectPlugin.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/3.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCTWebViewPlugin.h"

@class WKWebView;
@interface OCTCSSInjectionPlugin : NSObject <OCTWebViewPlugin>

@property (nonatomic, readonly) OCTWebViewPluginInjectionTime injectionTime;
@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *javascriptCode;


- (instancetype)initWithWebView:(WKWebView *)webView;

- (void)injectCSSString:(NSString *)cssString forIdentifier:(NSString *)identifier;
- (void)removeCSSStringForIdentifier:(NSString *)identifier;

@end
