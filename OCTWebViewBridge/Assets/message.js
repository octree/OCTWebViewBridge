"use strict";
//   core

if (!window.bridge) {
    window.bridge = {};
}

window.bridge.callbackDispatcher = {
__count: 0,
cache: {},
invoke: function invoke(id, args) {
    var key = "" + id;
    var func = window.bridge.callbackDispatcher.cache[key];
    func(args);
},
push: function push(func) {
    var index = -1;
    if (func != null) {
        window.bridge.callbackDispatcher.__count += 1;
        index = window.bridge.callbackDispatcher.__count;
        window.bridge.callbackDispatcher.cache["" + index] = func;
    }
    return index;
}
};

window.bridge.invoke = function(id, selector) {
    for (
         var _len = arguments.length,
         args = Array(_len > 2 ? _len - 2 : 0),
         _key = 2;
         _key < _len;
         _key++
         ) {
        args[_key - 2] = arguments[_key];
    }
    
    args = args.map(function(elt) {
                    if (typeof v === "function") {
                    return { type: 0, val: window.bridge.callbackDispatcher.push(elt) };
                    } else {
                    return { type: 1, val: elt };
                    }
                    });
    
    window.webkit.messageHandlers.bridge.postMessage({
                                                     identifier: id,
                                                     selector: selector,
                                                     args: args
                                                     });
};

window.bridge.plugin = {};

