
if (window.bridge == null) {
    
    window.bridge = {}
}

window.bridge.log = function(msg) {
    
    window.bridge.invoke("me.octree.bridge.log", "log:", null, msg)
}

window.bridge.loglevel = function(msg, level) {

     window.bridge.invoke("me.octree.bridge.log", "log:level:", null, msg, level)
}


;(function() {
  
  var stringify = function(obj) {
      if (typeof obj === 'function') {
        return obj + ''
      }
  
      if (obj === undefined) {
          return 'undefined'
      }
  
      if (obj === null) {
          return 'null'
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
  
  
  var exdebug = window.console.debug
  console.debug = function(msg) {
    exdebug(msg)
    window.bridge.loglevel(stringify(msg), 1)
  }
  
  var exinfo = window.console.info
  console.info = function(msg) {
    exdebug(msg)
    window.bridge.loglevel(stringify(msg), 2)
  }
  
  var exwarn = window.console.warn
  console.warn = function(msg) {
    exwarn(msg)
    window.bridge.loglevel(stringify(msg), 3)
  }
  
  var exerror = window.console.error
  console.error = function(msg) {
    exerror(msg)
    window.bridge.loglevel(stringify(msg), 4)
  }
})()
