//
//  OCTBlockPlugin.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/2.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTBlockPlugin.h"


NSString *OCTObjectDefineJavascriptCode(NSString *path) {
    return [NSString stringWithFormat:@"if(%@==null){ %@ = {} }", path, path];
}

NSString *OCTFunctionDefineCode(NSString *path, NSString *identifier, BOOL needCallback) {
    
    
    if (needCallback) {
        return [NSString stringWithFormat:@"if(%@==null) { %@ = function(param, callback) { window.bridge.invoke('%@', 'invoke:callback:', callback, param)} }", path, path, identifier];
    } else {
        return [NSString stringWithFormat:@"if(%@==null) { %@ = function(param) { window.bridge.invoke('%@', 'invoke:', null, param)} }", path, path, identifier];
    }
}

NSString *OCTJavascriptCodeForPath(NSString *path, NSString *identifier, BOOL needCallback) {
    
    NSArray *array = [path componentsSeparatedByString:@"."];
    NSInteger count = array.count - 1;
    NSMutableString *pathTmp = [NSMutableString stringWithString:@"this"];
    NSMutableString *code = [NSMutableString string];
    NSInteger index = 0;
    while (index < count) {
        [pathTmp appendFormat:@".%@", array[index++]];
        [code appendString:OCTObjectDefineJavascriptCode(pathTmp)];
    }
    [code appendString:OCTFunctionDefineCode(path, identifier, needCallback)];
    return code;
}


@interface OCTBlockPlugin ()

@property (strong, nonatomic) void (^handler)(id param);
@property (strong, nonatomic) void (^handlerWithResponseBlock)(id param, OCTResponseCallback block);

@end

@implementation OCTBlockPlugin

#pragma mark - Life Cycle

- (instancetype)initWithFunctionName:(NSString *)functionName handler:(void(^)(id data))block {

    if (self = [super init]) {
        
        NSParameterAssert(functionName.length > 0);
        NSParameterAssert(block != nil);
        self.handler = block;
        _identifier = [NSString stringWithFormat:@"me.octree.plugin0.%@", functionName];
        _javascriptCode = [self loadJSCodeWithFileName:@"block_plugin_template" functionName:functionName identifier:_identifier];
    }
    
    return self;
}

- (instancetype)initWithFunctionName:(NSString *)functionName handlerWithResponseBlock:(void(^)(id data, OCTResponseCallback responseCallback))block {

    if (self = [super init]) {
        
        NSParameterAssert(functionName.length > 0);
        NSParameterAssert(block != nil);
        self.handlerWithResponseBlock = block;
        _identifier = [NSString stringWithFormat:@"me.octree.plugin1.%@", functionName];
        _javascriptCode = [self loadJSCodeWithFileName:@"block_plugin_with_callback_template" functionName:functionName identifier:_identifier];
    }
    
    return self;
}

- (instancetype)initWithFunctionPath:(NSString *)path handler:(void(^)(id data))block {
    if (self = [super init]) {
        
        NSParameterAssert(path.length > 0);
        NSParameterAssert(block != nil);
        _handler = block;
        _identifier = [NSString stringWithFormat:@"me.octree.plugin3.%@", path];
        _javascriptCode = OCTJavascriptCodeForPath(path, _identifier, NO);
    }
    return self;
}

- (instancetype)initWithFunctionPath:(NSString *)path handlerWithResponseBlock:(void(^)(id data, OCTResponseCallback responseCallback))block {
    if (self = [super init]) {
        
        NSParameterAssert(path.length > 0);
        NSParameterAssert(block != nil);
        self.handlerWithResponseBlock = block;
        _identifier = [NSString stringWithFormat:@"me.octree.plugin4.%@", path];
        _javascriptCode = OCTJavascriptCodeForPath(path, _identifier, YES);
    }
    
    return self;
}


#pragma mark - Private Method


- (void)invoke:(id)param {

    !self.handler ?: self.handler(param);
}

- (void)invoke:(id)param callback:(OCTResponseCallback)callback {

    !self.handlerWithResponseBlock ?: self.handlerWithResponseBlock(param, callback);
}

- (NSString *)loadJSCodeWithFileName:(NSString *)fileName functionName:(NSString *)name identifier:(NSString *)identifier {

    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"js"];
    NSString *code = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    return [[code stringByReplacingOccurrencesOfString:@"{name}" withString:name] stringByReplacingOccurrencesOfString:@"{identifier}" withString:identifier];
}

#pragma mark - Accessor


@end
