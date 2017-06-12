//
//  OCTWebViewBridging.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/2.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OCTWebViewPluginInjectionTime) {

    OCTWebViewPluginInjectionTimeAtDocumentStart,
    OCTWebViewPluginInjectionTimeAtDocumentEnd,
};

/**
 *  JS 函数需要 Native 处理数据后，回调传回数据
 *
 *  @param params js 回调函数的参数, params 只能是 NSNumber NSString NSArray NSDictionary
 */
typedef void (^OCTResponseCallback)(id params);

/**
 *  WebView 的扩展，把 Native Bridge 到 WebView 中的 Object 需要实现这个协议
 */

@protocol OCTWebViewPlugin <NSObject>

@optional

@property (nonatomic, readonly) OCTWebViewPluginInjectionTime injectionTime;

@required
/**
 *  唯一标识
 */
@property (copy, nonatomic, readonly) NSString *identifier;
/**
 *  javascript 代码，主要作用是来定义在 webview 中，javascript function 的名称
 */
@property (copy, nonatomic, readonly) NSString *javascriptCode;

@end
