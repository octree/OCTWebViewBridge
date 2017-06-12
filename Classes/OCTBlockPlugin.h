//
//  OCTBlockPlugin.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/2.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCTWebViewPlugin.h"

@interface OCTBlockPlugin : NSObject <OCTWebViewPlugin>

@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *javascriptCode;

- (instancetype)initWithFunctionName:(NSString *)functionName handler:(void(^)(id data))block;
- (instancetype)initWithFunctionName:(NSString *)functionName handlerWithResponseBlock:(void(^)(id data, OCTResponseCallback responseCallback))block;
- (instancetype)initWithFunctionPath:(NSString *)path handler:(void(^)(id data))block;
- (instancetype)initWithFunctionPath:(NSString *)path handlerWithResponseBlock:(void(^)(id data, OCTResponseCallback responseCallback))block;


@end
