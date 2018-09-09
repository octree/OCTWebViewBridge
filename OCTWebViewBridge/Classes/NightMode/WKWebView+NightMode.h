//
//  WKWebView+NightMode.h
//  OCTWebViewBridge
//
//  Created by Octree on 2018/9/9.
//

#import <WebKit/WebKit.h>

@interface WKWebView (NightMode)

- (void)oct_nightFall;
- (void)oct_sunrise;

@end
