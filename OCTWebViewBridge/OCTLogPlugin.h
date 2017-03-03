//
//  TDFLogBridge.h
//  TDFWebViewBridge
//
//  Created by Octree on 15/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCTWebViewBridge.h"

@interface OCTLogPlugin : NSObject <OCTWebViewPlugin>

@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *javascriptCode;

@end
