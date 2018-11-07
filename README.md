## OCTWebViewBridge

起源于在老东家工作的时候的库 [YJWebView](https://github.com/TinydustDevelopers/YJWebView)


在 WKWebView 中使用 `Javascript` 调用 Native 代码，支持函数作为参数。

```javascript
window.native.foo(param1, param2, (obj) => {

})
```

## Installation

```shell
pod 'OCTWebViewBridge'
```



## How To Use

### Custom Plugin

javascript file（log.js）:
```javascript
window.bridge.log = function(msg) {

window.bridge.invoke("me.octree.bridge.log", "log:", msg)
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

javascript 调用 Native 代码

```
window.bridge.log("yoooooooo man")
```

### Block Plugin

使用 Block 的方式为 Web 提供插件。
Web 调用时，会执行这个 Block

```objectivec
[[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionName:@"test" handler:^(NSDictionary *data) { 
    NSLog(@"%@", data);
}];

[[OCTWebViewPluginInjector injectorForWebView:_webView] injectPluginWithFunctionName:@"test2" handlerWithResponseBlock:^(NSDictionary *data, OCTResponseCallback responseCallback) {
   NSLog(@"test2: %@", data);
   responseCallback(@{ @"hello" : @"world" });
}];
```

在 Web 中调用

```javascript
window.bridge.plugin.test({'hello': 'world'})
window.bridge.plugin.test2({'hello': 'world'}, function(json) {
  window.bridge.log(JSON.stringify(json))
})
```



### CSS Injector

注入 CSS 代码

```objectivec
// inject css
[[OCTWebViewPluginInjector injectorForWebView:_webView] injectCSSString:@"body {background-color: #eeeeee;}" forIdentifier:@"test"];
// remove css
[[OCTWebViewPluginInjector injectorForWebView:_webView] removeCSSStringForIdentifier:@"test"];
```

### Night Mode 

开启网页夜间模式

```objectivec

// enable night mode
[self.webView oct_nightFall];

// disable night mode
[self.webView oct_sunrise];

```

## License

OCTWebViewBridge is released under the MIT license. See LICENSE for details.
