//this file only used in editor
document.sharedFrameDict = {};

$.fn.updatePixel = function(){
	return this.each(function(){
                     var myName = this.id;
                     if (this.position == undefined){
                     this.position = $(this).iuPosition();
                     if (document.sharedFrameDict[myName] == undefined){
                        document.sharedFrameDict[myName] = this.position;
                     }
                     }
                     else{
                     /* check and update */
                     var newPosition = $(this).iuPosition();
                     if (this.position.top != newPosition.top || this.position.left != newPosition.left ||
                         this.position.width != newPosition.width || this.position.height != newPosition.height ||
                         this.position.x != newPosition.x || this.position.y != newPosition.y
                         ){
                     document.sharedFrameDict[myName] = newPosition;
                     this.position = newPosition;
                     }
                     }
                     })
}

$.fn.iuPosition = function(){
	var top = $(this).position().top + parseFloat($(this).css('margin-top'));
	var left = $(this).position().left + parseFloat($(this).css('margin-left'));
	var width = parseFloat($(this).css('width'));
	var height = parseFloat($(this).css('height'));
    var x = $(this).offset().left;
    var y = $(this).offset().top;

	if($(this).css('position') == "relative"){
		var marginTop =  parseFloat($(this).css('margin-top'));
		var marginLeft = parseFloat($(this).css('margin-left'));
		return { top: top, left: left, width: width, height: height, marginTop:marginTop, marginLeft:marginLeft, x:x, y:y }
	}
	return { top: top, left: left, width: width, height: height, x:x, y:y }
}



function getDictionaryKeys(dictionary){
    var keyArray = Object.keys(dictionary);
    return keyArray;
}

function getIUUpdatedFrameThread(){
    $('.IUBox').updatePixel();
    
    if (Object.keys(document.sharedFrameDict).length > 0
        && console.reportFrameDict ){
        console.reportFrameDict(document.sharedFrameDict);
        document.sharedFrameDict = {};
    }
}


$(document).ready(function(){
            console.log("ready : iuframe.js");
            getIUUpdatedFrameThread();
});

