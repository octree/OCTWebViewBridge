window.bridge.log = function(msg) {
    
    window.bridge.invoke("me.octree.bridge.log", "log:", msg)
}
