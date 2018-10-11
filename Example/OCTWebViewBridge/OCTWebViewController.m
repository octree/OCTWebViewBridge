//
//  OCTWebViewController.m
//  OCTWebViewBridge_Example
//
//  Created by Octree on 2018/10/11.
//  Copyright © 2018 citype. All rights reserved.
//

#import "OCTWebViewController.h"
#import <WebKit/WebKit.h>
#import <OCTWebViewBridge/OCTWebViewBridge.h>

@interface OCTWebViewController ()

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic) BOOL isNightMode;

@end

@implementation OCTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Night" style:UIBarButtonItemStylePlain target:self action:@selector(handleNight)];
    self.navigationItem.rightBarButtonItem = item;
    [self.view addSubview:self.webView];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [self.webView loadRequest:req];
}

- (void)handleNight {
    
    if (self.isNightMode) {
        
        [self.webView oct_sunrise];
    } else {
        [self.webView oct_nightFall];
    }
    self.isNightMode = !self.isNightMode;
}

- (NSString *)logpath {
    
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path    = [pathList objectAtIndex:0];
    
    path = [[path stringByAppendingPathComponent:@"me.octree.log"] stringByAppendingPathComponent:@"webview"];
    
    return [path stringByAppendingPathComponent:@"web_console.log"];
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
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        OCTLogPlugin *plg = [[OCTLogPlugin alloc] init];
        plg.logger = [self logger];
        [[OCTWebViewPluginInjector injectorForWebView:_webView] injectPlugin:plg];
    }
    return _webView;
}


@end
