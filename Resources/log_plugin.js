
if (window.bridge == null) {
    
    window.bridge = {}
}

window.bridge.log = function(msg) {
    
    window.bridge.invoke("me.octree.bridge.log", "log:", null, msg)
}


;(function() {
  
  var stringify = function(obj) {
      if (typeof obj === 'function') {
        return obj + ''
      }
      var placeholder = '____PLACEHOLDER____XXOOO___';
      var fns = [];
      var json = JSON.stringify(obj, function(key, value) {
                                if (typeof value === 'function') {
                                fns.push(value);
                                return placeholder;
                                }
                                return value;
                                }, 2);
      return json.replace(new RegExp('"' + placeholder + '"', 'g'), function(_) {
                          return fns.shift();
                          });
  };
  var exlog = window.console.log
  console.log = function(msg) {
    exlog(msg)
    window.bridge.log(stringify(msg))
  }
})()
