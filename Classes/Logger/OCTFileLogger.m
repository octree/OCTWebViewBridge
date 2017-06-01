//
//  OCTFileLogger.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTFileLogger.h"
#import <unistd.h>
#import <sys/attr.h>
#import <sys/xattr.h>
#import <libkern/OSAtomic.h>


@implementation OCTLogFileInfo

@synthesize     filePath    =   _filePath,
                fileName    =   _fileName,
                fileSize    =   _fileSize,
          fileAttributes    =   _fileAttributes,
            creationDate    =   _creationDate,
        modificationDate    =   _modificationDate,
                     age    =   _age;


#pragma mark Lifecycle

+ (instancetype)logFileWithPath:(NSString *)aFilePath {
    return [[self alloc] initWithFilePath:aFilePath];
}

- (instancetype)initWithFilePath:(NSString *)aFilePath {
    if ((self = [super init])) {
        _filePath = [aFilePath copy];
    }
    
    return self;
}

#pragma mark Standard Info

- (NSDictionary *)fileAttributes {
    if (!_fileAttributes && _filePath) {
        _fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil];
    }
    
    return _fileAttributes;
}

- (NSString *)fileName {
    if (_fileName == nil) {
        _fileName = [_filePath lastPathComponent];
    }
    
    return _fileName;
}

- (NSDate *)modificationDate {
    if (_modificationDate == nil) {
        _modificationDate = self.fileAttributes[NSFileModificationDate];
    }
    
    return _modificationDate;
}

- (NSDate *)creationDate {
    if (_creationDate == nil) {
        _creationDate = self.fileAttributes[NSFileCreationDate];
    }
    
    return _creationDate;
}

- (unsigned long long)fileSize {
    if (_fileSize == 0) {
        _fileSize = [self.fileAttributes[NSFileSize] unsignedLongLongValue];
    }
    
    return _fileSize;
}

- (NSTimeInterval)age {
    return [[self creationDate] timeIntervalSinceNow] * -1.0;
}

- (NSString *)description {
    return [@{ @"filePath": self.filePath ? : @"",
               @"fileName": self.fileName ? : @"",
               @"fileAttributes": self.fileAttributes ? : @"",
               @"creationDate": self.creationDate ? : @"",
               @"modificationDate": self.modificationDate ? : @"",
               @"fileSize": @(self.fileSize),
               @"age": @(self.age)
               }
            description];
}

#pragma mark Changes

- (void)reset {
    
    _fileAttributes = nil;
    _creationDate = nil;
    _modificationDate = nil;
    _fileName = nil;
}

- (void)renameFile:(NSString *)newFileName {
    // This method is only used on the iPhone simulator, where normal extended attributes are broken.
    // See full explanation in the header file.
    
    if (![newFileName isEqualToString:[self fileName]]) {
        NSString *fileDir = [_filePath stringByDeletingLastPathComponent];
        
        NSString *newFilePath = [fileDir stringByAppendingPathComponent:newFileName];
        
        NSError *error = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newFilePath] &&
            ![[NSFileManager defaultManager] removeItemAtPath:newFilePath error:&error]) {
        }
        
        if (![[NSFileManager defaultManager] moveItemAtPath:_filePath toPath:newFilePath error:&error]) {
        }
        
        _filePath = newFilePath;
        [self reset];
    }
}


- (BOOL)hasExtendedAttributeWithName:(NSString *)attrName {
    const char *path = [_filePath UTF8String];
    const char *name = [attrName UTF8String];
    
    ssize_t result = getxattr(path, name, NULL, 0, 0, 0);
    
    return (result >= 0);
}

- (void)addExtendedAttributeWithName:(NSString *)attrName {
    const char *path = [_filePath UTF8String];
    const char *name = [attrName UTF8String];
    
    int result = setxattr(path, name, NULL, 0, 0, 0);
    
    if (result < 0) {
        NSLog(@"OCTLogFileInfo: setxattr(%@, %@): error = %s",
                   attrName,
                   _filePath,
                   strerror(errno));
    }
}

- (void)removeExtendedAttributeWithName:(NSString *)attrName {
    const char *path = [_filePath UTF8String];
    const char *name = [attrName UTF8String];
    
    int result = removexattr(path, name, 0);
    
    if (result < 0 && errno != ENOATTR) {
        NSLog(@"OCTLogFileInfo: removexattr(%@, %@): error = %s",
                   attrName,
                   self.fileName,
                   strerror(errno));
    }
}

#pragma mark Comparisons

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        OCTLogFileInfo *another = (OCTLogFileInfo *)object;
        
        return [_filePath isEqualToString:[another filePath]];
    }
    
    return NO;
}

-(NSUInteger)hash {
    return [_filePath hash];
}

- (NSComparisonResult)reverseCompareByCreationDate:(OCTLogFileInfo *)another {
    NSDate *us = [self creationDate];
    NSDate *them = [another creationDate];
    
    NSComparisonResult result = [us compare:them];
    
    if (result == NSOrderedAscending) {
        return NSOrderedDescending;
    }
    
    if (result == NSOrderedDescending) {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

- (NSComparisonResult)reverseCompareByModificationDate:(OCTLogFileInfo *)another {
    NSDate *us = [self modificationDate];
    NSDate *them = [another modificationDate];
    
    NSComparisonResult result = [us compare:them];
    
    if (result == NSOrderedAscending) {
        return NSOrderedDescending;
    }
    
    if (result == NSOrderedDescending) {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

@end


@interface OCTFileLogger ()

@property (strong, nonatomic) NSFileHandle *currentFileHandle;

@end

@implementation OCTFileLogger

@synthesize logFileInfo = _logFileInfo;

#pragma mark - Life Cycle

- (instancetype)initWithPath:(NSString *)path {

    if (self = [super init]) {
        
        _logFileInfo = [OCTLogFileInfo logFileWithPath:[path copy]];
        [self createLogFileIfNeeded];
    }
    return self;
}

+ (instancetype)loggerWithPath:(NSString *)path {
    
    return [[[self class] alloc] initWithPath:path];
}


#pragma mark - Public Method

- (void)clear {

    [[[NSData alloc] init] writeToFile:self.filePath atomically:YES];
}

- (void)log:(NSString *)msg level:(OCTLogLevel)level {

    if (level < self.level) {
        return;
    }
    NSString *log = [self.destination formattedMessageForMessage:msg level:level];
    
    NSData *logData = [log dataUsingEncoding:NSUTF8StringEncoding];
    [self.currentFileHandle writeData:logData];
}



#pragma mark - Private Method

- (void)createLogFileIfNeeded {
    
    NSString *directory = [self.filePath stringByDeletingLastPathComponent];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:directory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:self.filePath
                                                contents:[@"" dataUsingEncoding:NSUTF8StringEncoding]
                                              attributes:nil];
    }
}


#pragma mark - Accessor

- (OCTLogFileInfo *)logFileInfo {
    
    if (!_logFileInfo) {
        _logFileInfo = [OCTLogFileInfo logFileWithPath:self.filePath];
    }
    return _logFileInfo;
}

- (NSString *)filePath {

    return self.logFileInfo.filePath;
}

- (NSFileHandle *)currentFileHandle {
    if (!_currentFileHandle) {
        NSString *logFilePath = [[self logFileInfo] filePath];
        
        _currentFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
        [_currentFileHandle seekToEndOfFile];
    }
    
    return _currentFileHandle;
}

@end
