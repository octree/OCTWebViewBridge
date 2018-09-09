if (!window.bridge.plugin) {
    window.bridge.plugin = {}
}

window.bridge.plugin.cssInjector =  {

    inject: function(json) {
        Object.keys(json).forEach(function(identifier) {

            var style = document.getElementById(identifier)
            if (!style) {
               var style = document.createElement('style');
               style.type = 'text/css';style.setAttribute('id', identifier);
            }
            style.innerHTML = json[identifier]
            document.getElementsByTagName('head')[0].appendChild(style);
        });
    },
    remove: function(identifier) {
        
        var style = document.getElementById(identifier)
        if (style) {
            style.parentNode.removeChild(style)
        }
    },
    fetchCSSJSON: function (callback) {
    
        window.bridge.invoke("me.octree.plugin.cssInjector", "fetchCSSJSON:", callback)
    }
}

window.bridge.plugin.cssInjector.fetchCSSJSON(window.bridge.plugin.cssInjector.inject)
