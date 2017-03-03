//
//  OCTBlockPlugin.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/2.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTBlockPlugin.h"


@interface OCTBlockPlugin ()

@property (strong, nonatomic) void (^handler)(NSDictionary *param);
@property (strong, nonatomic) void (^handlerWithResponseBlock)(NSDictionary *param, OCTResponseCallback block);

@end

@implementation OCTBlockPlugin

#pragma mark - Life Cycle

- (instancetype)initWithFunctionName:(NSString *)functionName handler:(void(^)(NSDictionary *data))block {

    if (self = [super init]) {
        
        NSParameterAssert(functionName.length > 0);
        NSParameterAssert(block != nil);
        self.handler = block;
        _identifier = [NSString stringWithFormat:@"me.octree.plugin0.%@", functionName];
        _javascriptCode = [self loadJSCodeWithFileName:@"block_plugin_template" functionName:functionName identifier:_identifier];
    }
    
    return self;
}

- (instancetype)initWithFunctionName:(NSString *)functionName handlerWithResponseBlock:(void(^)(NSDictionary *data, OCTResponseCallback responseCallback))block {

    if (self = [super init]) {
        
        NSParameterAssert(functionName.length > 0);
        NSParameterAssert(block != nil);
        _identifier = [NSString stringWithFormat:@"me.octree.plugin1.%@", functionName];
        _javascriptCode = [self loadJSCodeWithFileName:@"block_plugin_with_callback_template" functionName:functionName identifier:_identifier];
        self.handlerWithResponseBlock = block;
    }
    
    return self;
}


#pragma mark - Private Method

- (void)invoke:(NSDictionary *)param {

    !self.handler ?: self.handler(param);
}

- (void)invoke:(NSDictionary *)param callback:(OCTResponseCallback)callback {

    !self.handlerWithResponseBlock ?: self.handlerWithResponseBlock(param, callback);
}

- (NSString *)loadJSCodeWithFileName:(NSString *)fileName functionName:(NSString *)name identifier:(NSString *)identifier {

    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"js"];
    NSString *code = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    return [[code stringByReplacingOccurrencesOfString:@"{name}" withString:name] stringByReplacingOccurrencesOfString:@"{identifier}" withString:identifier];
}

#pragma mark - Accessor

@end
