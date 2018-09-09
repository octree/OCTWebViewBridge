if (!window.bridge.plugin) {
    window.bridge.plugin = {}
}

window.bridge.plugin.{name} = function(param) {
    
    window.bridge.invoke("{identifier}", "invoke:", null, param)
}
