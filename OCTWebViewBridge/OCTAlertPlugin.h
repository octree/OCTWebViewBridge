//
//  TDFAlertBridge.h
//  TDFWebViewBridge
//
//  Created by Octree on 15/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "OCTWebViewBridge.h"

@interface OCTAlertPlugin : NSObject <OCTWebViewPlugin>

@property (copy, nonatomic, readonly) NSString *identifier;

@property (copy, nonatomic, readonly) NSString *javascriptCode;

- (void)alert:(NSString *)msg confirm:(OCTResponseCallback)callback;

@end
