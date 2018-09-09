//
//  WKWebView+NightMode.m
//  OCTWebViewBridge
//
//  Created by Octree on 2018/9/9.
//

#import "WKWebView+NightMode.h"
#import "OCTWebViewPluginInjector.h"

static NSString * const kOCTNightCSSID = @"me.octree.id.nightcss";

@implementation WKWebView (NightMode)

- (void)oct_nightFall {
    
    [[OCTWebViewPluginInjector injectorForWebView:self] injectCSSString:[self _oct_nightCSS] forIdentifier:kOCTNightCSSID];
    [self evaluateJavaScript:[self _oct_nightJS] completionHandler:nil];
}

- (void)oct_sunrise {
    
    [[OCTWebViewPluginInjector injectorForWebView:self] removeCSSStringForIdentifier: kOCTNightCSSID];
}

- (NSString *)_oct_nightCSS {
    
    return [self _oct_stringWithFileName:@"night" extension:@"css"];
}

- (NSString *)_oct_nightJS {
    
    return [self _oct_stringWithFileName:@"night" extension:@"js"];
}

- (NSString *)_oct_stringWithFileName:(NSString *)fileName extension:(NSString *)ext {
    
    NSString *path = [[NSBundle bundleForClass:[OCTWebViewPluginInjector class]] pathForResource:fileName ofType:ext];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

@end
