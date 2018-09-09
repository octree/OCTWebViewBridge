if (!window.bridge.plugin) {
    window.bridge.plugin = {}
}

window.bridge.plugin.{name} = function(param, callback) {
    
    window.bridge.invoke("{identifier}", "invoke:callback:", callback, param)
}
