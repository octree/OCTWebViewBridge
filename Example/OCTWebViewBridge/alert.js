window.bridge.alert = function(msg, callback) {
    
    window.bridge.invoke("me.octree.bridge.alert", "alert:confirm:", msg, callback)
}
