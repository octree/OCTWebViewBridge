//
//  OCTWebViewBridge.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/2.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCTWebViewPlugin.h"

@class WKWebView;
@interface OCTWebViewPluginInjector : NSObject

+ (instancetype)injectorForWebView:(WKWebView *)webView;

/**
 *  inject plugin
 *
 *  @param plugin plugin
 */
- (void)injectPlugin:(id<OCTWebViewPlugin>)plugin;


/**
 *  inject plugin
 *
 *  js : window.bridge.<functionName>(json)
 *
 *  @param functionName js function name
 *  @param block        handler
 */
- (void)injectPluginFunctionName:(NSString *)functionName handler:(void(^)(NSDictionary *data))block;


/**
 *  inject plugin
 *
 *  js : window.bridge.<functionName>(json, callbackFunction)
 *
 *  @param functionName js function name
 *  @param block        handler
 */
- (void)injectPluginFunctionName:(NSString *)functionName handlerWithResponseBlock:(void(^)(NSDictionary *data, OCTResponseCallback responseCallback))block;

/**
 *  remove plugin for identifier
 *
 *  @param identifier plugin identifier
 */
- (void)removePluginForIdentifier:(NSString *)identifier;

/**
 *  remove all plugins
 */
- (void)removeAllPlugins;

- (void)injectCSSString:(NSString *)cssString forIdentifier:(NSString *)identifier;
- (void)removeCSSStringForIdentifier:(NSString *)identifier;



@end
