'use strict';
//   core
if (!window.bridge) {
    
    window.bridge = {};
}

window.bridge.callbackDispatcher = {
__count: 0,
cache: {},
invoke: function invoke(id, args) {
    var key = '' + id;
    var func = window.bridge.callbackDispatcher.cache[key];
    func(args);
},
push: function push(func) {
    var index = -1;
    if (func != null) {
        window.bridge.callbackDispatcher.__count += 1;
        index = window.bridge.callbackDispatcher.__count;
        window.bridge.callbackDispatcher.cache['' + index] = func;
    }
    return index;
}
};

window.bridge.invoke = function (id, selector, callback) {
    for (var _len = arguments.length, args = Array(_len > 3 ? _len - 3 : 0), _key = 3; _key < _len; _key++) {
        args[_key - 3] = arguments[_key];
    }
    
    var index = window.bridge.callbackDispatcher.push(callback);
    window.webkit.messageHandlers.bridge.postMessage({ "identifier": id, "selector": selector, "callbackId": index, "args": args });
};

window.bridge.plugin = {};
