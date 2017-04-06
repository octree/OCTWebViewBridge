//   core

if (!window.bridge) {

    window.bridge = {}
}

window.bridge.callback = {
    index: 0,
    cache: {
    },
    invoke: function(id, args) {
        let key = '' + id
        let callback = window.bridge.callback.cache[key]
        callback(args)
//        delete window.bridge.callback.cache[key]
    }
}

window.bridge.invoke = function(id, selector, callback, ...args) {
    let index = -1
    if (callback !== null && callback !== undefined ) {
        window.bridge.callback.index += 1
        index = window.bridge.callback.index
        window.bridge.callback.cache['' + index] = callback
    }
    window.webkit.messageHandlers.bridge.postMessage({"identifier": id, "selector": selector, "callbackId": index, "args": args })
}

window.bridge.plugin = { }
