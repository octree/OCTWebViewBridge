//
//  ViewController.m
//  OCTWebViewBridge
//
//  Created by Octree on 2017/3/2.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import "ViewController.h"
#import "OCTWebViewBridge.h"
#import <WebKit/WebKit.h>
#import "OCTLogPlugin.h"
#import "OCTAlertPlugin.h"

@interface ViewController ()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation ViewController

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
    
    [self.webView loadHTMLString:[self html] baseURL:nil];
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
        
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPlugin:[[OCTLogPlugin alloc] init]];
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPlugin:[[OCTAlertPlugin alloc] init]];
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionName:@"test" handler:^(NSDictionary *data) {
            
            NSLog(@"%@", data);
        }];
        
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionName:@"test2" handlerWithResponseBlock:^(NSDictionary *data, OCTResponseCallback responseCallback) {
            NSLog(@"test2: %@", data);
            responseCallback(@{ @"hello" : @"world" });
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

