//   core

if (!window.bridge) {

    window.bridge = {}
}

window.bridge.callbackDispatcher = {
    __count: 0,
    cache: {
    },
    invoke: function(id, args) {
        let key = '' + id
        let func = window.bridge.callbackDispatcher.cache[key]
        func(args)
    },
    push: function(func) {
        let index = -1
        if (func != null ) {
            window.bridge.callbackDispatcher.__count += 1
            index = window.bridge.callbackDispatcher.__count
            window.bridge.callbackDispatcher.cache['' + index] = func
        }
        return index
    }
}

window.bridge.invoke = function(id, selector, callback, ...args) {
        let index = window.bridge.callbackDispatcher.push(callback)
        window.webkit.messageHandlers.bridge.postMessage({"identifier": id, "selector": selector, "callbackId": index, "args": args })
}

window.bridge.plugin = { }
