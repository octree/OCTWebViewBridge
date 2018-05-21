//
//  OCTCSSInjectPlugin.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/3.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTCSSInjectionPlugin.h"
#import <WebKit/WebKit.h>

@interface OCTCSSInjectionPlugin ()

@property (strong, nonatomic) NSMutableDictionary *cssMap;
@property (weak, nonatomic) WKWebView *webView;

@end

@implementation OCTCSSInjectionPlugin

- (instancetype)initWithWebView:(WKWebView *)webView {

    if (self = [super init]) {
        
        _webView = webView;
    }
    return self;
}

- (void)injectCSSString:(NSString *)cssString forIdentifier:(NSString *)identifier {
    
    NSParameterAssert(cssString != nil);
    NSParameterAssert(identifier != nil);
    identifier = [self generateCSSIdentifierWithIdentifier:identifier];
    self.cssMap[identifier] = cssString;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{identifier: cssString} options:0 error:NULL];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *js = [NSString stringWithFormat:@"window.bridge.plugin.cssInjector.inject(%@)", json];
    [self.webView evaluateJavaScript:js completionHandler:nil];
}

- (void)removeCSSStringForIdentifier:(NSString *)identifier {

    NSParameterAssert(identifier != nil);
    identifier = [self generateCSSIdentifierWithIdentifier:identifier];
    NSString *js = [NSString stringWithFormat:@"window.bridge.plugin.cssInjector.remove('%@')", identifier];
    [self.cssMap removeObjectForKey:identifier];
    [self.webView evaluateJavaScript:js completionHandler:nil];
}

- (NSString *)generateCSSIdentifierWithIdentifier:(NSString *)string {

    return [NSString stringWithFormat:@"ME_OCTREE_CSS_INJECTOR_%@", string];
}

- (void)fetchCSSJSON:(OCTResponseCallback)callback {

    callback(self.cssMap);
}


- (NSString *)javascriptCode {

    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"css_injector" ofType:@"js"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (NSString *)identifier {

    return @"me.octree.plugin.cssInjector";
}

- (NSMutableDictionary *)cssMap {

    if (!_cssMap) {
        
        _cssMap = [NSMutableDictionary dictionary];
    }
    
    return _cssMap;
}

- (OCTWebViewPluginInjectionTime)injectionTime {

    return OCTWebViewPluginInjectionTimeAtDocumentStart;
}
@end
