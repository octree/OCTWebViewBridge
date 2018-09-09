//
//  OCTBaseDestination.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTLogLevel.h"
#import <Foundation/Foundation.h>

#if TARGET_OS_IOS
#define   OCTColor UIColor
#import <UIKit/UIKit.h>
#elif TARGET_OS_OSX
#define   OCTColor NSColor
#import <Cocoa/Cocoa.h>
#endif

@interface OCTLevelString : NSObject

@property (copy, nonatomic) NSString *verbose;
@property (copy, nonatomic) NSString *debug;
@property (copy, nonatomic) NSString *info;
@property (copy, nonatomic) NSString *warning;
@property (copy, nonatomic) NSString *error;

@end


@interface OCTLevelColor : NSObject

@property (copy, nonatomic) OCTColor *verbose;
@property (copy, nonatomic) OCTColor *debug;
@property (copy, nonatomic) OCTColor *info;
@property (copy, nonatomic) OCTColor *warning;
@property (copy, nonatomic) OCTColor *error;

@end

@interface OCTLevelBadge : NSObject

@property (copy, nonatomic) NSString *verbose;
@property (copy, nonatomic) NSString *debug;
@property (copy, nonatomic) NSString *info;
@property (copy, nonatomic) NSString *warning;
@property (copy, nonatomic) NSString *error;

@end

@interface OCTBaseDestination : NSObject

@property (strong, nonatomic) OCTLevelString *levelString;
@property (strong, nonatomic) OCTLevelColor *levelColor;
@property (strong, nonatomic) OCTLevelBadge *levelBadge;

- (NSString *)formattedMessageForMessage:(NSString *)msg level:(OCTLogLevel)level;
- (OCTColor *)colorForLevel:(OCTLogLevel)level;
- (NSString *)titleForLevel:(OCTLogLevel)level;
- (NSString *)badgeForLevel:(OCTLogLevel)level;

@end
