//
//  OCTViewController.m
//  OCTWebViewBridge
//
//  Created by Octree on 09/09/2018.
//  Copyright (c) 2018 Octree. All rights reserved.
//

#import "OCTViewController.h"
#import <OCTWebViewBridge/OCTWebViewBridge.h>
#import "OCTAlertPlugin.h"
#import <WebKit/WebKit.h>

@interface OCTViewController ()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation OCTViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:[self html] baseURL:nil];
}


- (IBAction)injectCSS:(id)sender {
    
    [[OCTWebViewPluginInjector injectorForWebView:_webView] injectCSSString:@"body {background-color: #eeeeee;}" forIdentifier:@"test"];
    [[OCTWebViewPluginInjector injectorForWebView:_webView] injectCSSString:[self bootstrapCSSString] forIdentifier:@"link"];
    
}
- (IBAction)removeCSS:(id)sender {
    
    [[OCTWebViewPluginInjector injectorForWebView:_webView] removeCSSStringForIdentifier:@"test"];
    [[OCTWebViewPluginInjector injectorForWebView:_webView] removeCSSStringForIdentifier:@"link"];
}

- (IBAction)reloadWebView:(id)sender {
    
    //    [self.webView loadHTMLString:[self html] baseURL:nil];
    NSString *string = [NSString stringWithContentsOfFile:[self logpath] encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"%@", string);
}

- (NSString *)logpath {
    
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    
    myPath = [[myPath stringByAppendingPathComponent:@"me.octree.log"] stringByAppendingPathComponent:@"yooo"];
    
    return [myPath stringByAppendingPathComponent:@"web_console.log"];
}

- (OCTLogger *)logger {
    
    OCTLogger *logger = [[OCTLogger alloc] init];
    [logger addLogger:[OCTFileLogger loggerWithPath:[self logpath]]];
    [logger addLogger:[[OCTConsoleLogger alloc] init]];
    return logger;
}

- (WKWebView *)webView {
    
    if (!_webView) {
        
        WKUserContentController *userController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userController;
        configuration.allowsInlineMediaPlayback = YES;
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y = 30;
        frame.size.height = 400;
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        OCTLogPlugin *plugin = [[OCTLogPlugin alloc] init];
        plugin.logger = [self logger];
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPlugin:plugin];
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPlugin:[[OCTAlertPlugin alloc] init]];
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionName:@"test" handler:^(NSDictionary *data) {
            
            NSLog(@"%@", data);
        }];
        
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionPath:@"octree.util.log" handlerWithResponseBlock:^(NSDictionary *data, OCTResponseCallback responseCallback) {
            responseCallback(@(1));
        }];
    }
    return _webView;
}

- (NSString *)html {
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"demo" ofType:@"html"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (NSString *)bootstrapCSSString {
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"bootstrap" ofType:@"css"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}


@end
