//
//  OCTLogPlugin.h
//  OCTWebViewBridge
//
//  Created by Octree on 2017/6/1.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTWebViewPlugin.h"

@class OCTLogger;
@interface OCTLogPlugin : NSObject <OCTWebViewPlugin>

@property (strong, nonatomic) OCTLogger *logger;

@end
