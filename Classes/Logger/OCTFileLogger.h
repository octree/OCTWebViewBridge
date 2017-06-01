//
//  OCTFileLogger.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTLogger.h"

@interface OCTLogFileInfo : NSObject

@property (strong, nonatomic, readonly) NSString *filePath;
@property (strong, nonatomic, readonly) NSString *fileName;
@property (strong, nonatomic, readonly) NSDictionary *fileAttributes;

@property (strong, nonatomic, readonly) NSDate *creationDate;
@property (strong, nonatomic, readonly) NSDate *modificationDate;

@property (nonatomic, readonly) unsigned long long fileSize;

@property (nonatomic, readonly) NSTimeInterval age;

+ (instancetype)logFileWithPath:(NSString *)filePath NS_SWIFT_UNAVAILABLE("Use init(filePath:)");

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFilePath:(NSString *)filePath NS_DESIGNATED_INITIALIZER;

- (void)reset;
- (void)renameFile:(NSString *)newFileName NS_SWIFT_NAME(renameFile(to:));

- (BOOL)hasExtendedAttributeWithName:(NSString *)attrName;
- (void)addExtendedAttributeWithName:(NSString *)attrName;
- (void)removeExtendedAttributeWithName:(NSString *)attrName;

@end


@interface OCTFileLogger : OCTLogger

@property (copy, nonatomic, readonly) NSString *filePath;
@property (strong, nonatomic, readonly) OCTLogFileInfo *logFileInfo;
- (instancetype)initWithPath:(NSString *)path;
+ (instancetype)loggerWithPath:(NSString *)path;

- (void)clear;

@end

