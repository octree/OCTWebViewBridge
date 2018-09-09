## OCTWebViewBridge

起源于在老东家工作的时候的库 [YJWebView](https://github.com/TinydustDevelopers/YJWebView)


## Installation

```shell
pod OCTWebViewBridge
```



## How To Use

### Custom Plugin

javascript file（log.js）:
```javascript
window.bridge.log = function(msg) {
    
    window.bridge.invoke("me.octree.bridge.log", "log:", null, msg)
}
```

objective-c code

```objectivec
@interface OCTLogPlugin : NSObject <OCTWebViewPlugin>

@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *javascriptCode;

@end


@implementation OCTLogPlugin

- (NSString *)identifier {
    
    return @"me.octree.bridge.log";
}

- (NSString *)javascriptCode {
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"log" ofType:@"js"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}


- (void)log:(id)msg {

    NSLog(@"WebView Bridge: %@", [msg description]);
}

@end

```

inject plugin 

```objectivec
[[OCTWebViewPluginInjector injectorForWebView:webView] injectPlugin:[[OCTLogPlugin alloc] init]];
```

javascript call native log:

```
window.bridge.log("yoooooooo man")
```

### Block Plugin

inject:

```objectivec
[[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionName:@"test" handler:^(NSDictionary *data) { 
    NSLog(@"%@", data);
}];

[[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionName:@"test2" handlerWithResponseBlock:^(NSDictionary *data, OCTResponseCallback responseCallback) {
   NSLog(@"test2: %@", data);
   responseCallback(@{ @"hello" : @"world" });
}];
```

call:

```javascript
window.bridge.plugin.test({'hello': 'world'})
window.bridge.plugin.test2({'hello': 'world'}, function(json) {
  window.bridge.log(JSON.stringify(json))
})
```



### CSS Injector

```objectivec
// inject css
[[OCTWebViewPluginInjector injectorForWebView:_webView] injectCSSString:@"body {background-color: #eeeeee;}" forIdentifier:@"test"];
// remove css
[[OCTWebViewPluginInjector injectorForWebView:_webView] removeCSSStringForIdentifier:@"test"];
```

## License

OCTWebViewBridge is released under the MIT license. See LICENSE for details.