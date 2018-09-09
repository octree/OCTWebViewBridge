//
//  OCTBaseDestination.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTBaseDestination.h"


#if TARGET_OS_IOS
#define   OCTColor UIColor
#define OCTColorWithRGBA(r,g,b, a)  [UIColor colorWithRed:r green:g blue:b alpha:a]
#elif TARGET_OS_OSX
#define OCTColorWithRGBA(r,g,b, a)  [NSColor colorWithDeviceRed:r green:g blue:b alpha:a]
#endif

@implementation OCTLevelString

@end


@implementation OCTLevelColor : NSObject

@end

@implementation OCTLevelBadge : NSObject

@end

@implementation OCTBaseDestination


- (instancetype)init {

    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)formattedMessageForMessage:(NSString *)msg level:(OCTLogLevel)level {

    return msg;
}

- (OCTColor *)colorForLevel:(OCTLogLevel)level {

    switch (level) {
        case OCTLogLevelVerbose:
            
            return self.levelColor.verbose;
        case OCTLogLevelDebug:
            
             return self.levelColor.debug;
        case OCTLogLevelInfo:
            
             return self.levelColor.info;
        case OCTLogLevelWarning:
            
             return self.levelColor.warning;
        case OCTLogLevelError:
            
             return self.levelColor.error;
    }
}

- (NSString *)titleForLevel:(OCTLogLevel)level {

    switch (level) {
        case OCTLogLevelVerbose:
            
            return self.levelString.verbose;
        case OCTLogLevelDebug:
            
            return self.levelString.debug;
        case OCTLogLevelInfo:
            
            return self.levelString.info;
        case OCTLogLevelWarning:
            
            return self.levelString.warning;
        case OCTLogLevelError:
            
            return self.levelString.error;
        default:
            return @"Unkown";
    }
}

- (NSString *)badgeForLevel:(OCTLogLevel)level {

    switch (level) {
        case OCTLogLevelVerbose:
            
            return self.levelBadge.verbose;
        case OCTLogLevelDebug:
            
            return self.levelBadge.debug;
        case OCTLogLevelInfo:
            
            return self.levelBadge.info;
        case OCTLogLevelWarning:
            
            return self.levelBadge.warning;
        case OCTLogLevelError:
            
            return self.levelBadge.error;
        default:
            return @"🖤";
    }
}


- (OCTLevelString *)levelString {

    if (!_levelString) {
        
        _levelString = [[OCTLevelString alloc] init];
        _levelString.verbose = @"VERBOSE";
        _levelString.debug = @"DEBUG";
        _levelString.info = @"INFO";
        _levelString.warning = @"WARNING";
        _levelString.error = @"ERROR";
    }
    return _levelString;
}


- (OCTLevelBadge *)levelBadge {

    if (!_levelBadge) {
        
        _levelBadge = [[OCTLevelBadge alloc] init];
        _levelBadge.verbose = @"💜";
        _levelBadge.debug = @"💙";
        _levelBadge.info = @"💚";
        _levelBadge.warning = @"💛";
        _levelBadge.error = @"❤️";
    }
    
    return _levelBadge;
}


- (OCTLevelColor *)levelColor {

    if (!_levelColor) {
        
        _levelColor = [[OCTLevelColor alloc] init];
        _levelColor.verbose = OCTColorWithRGBA(0.85, 0.85, 0.85, 1);
        _levelColor.debug = OCTColorWithRGBA(0.369, 0.769, 0.482, 1);
        _levelColor.info = OCTColorWithRGBA(0.396, 0.776, 0.933, 1);
        _levelColor.warning = OCTColorWithRGBA(0.906, 0.753, 0.271, 1);
        _levelColor.error = OCTColorWithRGBA(0.898, 0.302, 0.447, 1);
    }
    
    return _levelColor;
}
@end
