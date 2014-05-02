(function(window) {
    var iSpeech = function() {

    }
  
    iSpeech.prototype = {
        init: function (key){
            cordova.exec(null, null, "iSpeech", "init",[key]);
        },
        speak: function(callback, errCallbac, message) {
            cordova.exec(callback, errCallbac, "iSpeech", "speak",[message]);
        },
        recognize: function (callback, errCallbac) {
            cordova.exec(callback, errCallbac, "iSpeech", "recognize",[]);
        }
    };
  
    cordova.addConstructor(function() {
        window.iSpeech = new iSpeech();
    });

})(window);

