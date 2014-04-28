//this file only used in editor
document.sharedFrameDict = {};
document.sharedPercentFrameDict = {}

$.fn.updatePixel = function(){
	return this.each(function(){
                     var myName = this.id;
                     if (this.position == undefined){
                     this.position = $(this).iuPosition();
                     if (document.sharedFrameDict[myName] == undefined){
                        document.sharedFrameDict[myName] = this.position;
                        document.sharedPercentFrameDict[myName] = $(this).iuPercentFrame();
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
                     document.sharedPercentFrameDict[myName] = $(this).iuPercentFrame();
                     this.position = newPosition;
                     }
                     }
                     })
}


$.fn.iuPosition = function(){
	var top = $(this).position().top + parseFloat($(this).css('margin-top'));
	var left = $(this).position().left + parseFloat($(this).css('margin-left'));
	var width = parseFloat($(this).css('width')) + parseFloat($(this).css('border-left-width'))+parseFloat($(this).css('border-right-width'));
	var height = parseFloat($(this).css('height')) + parseFloat($(this).css('border-top-width'))+parseFloat($(this).css('border-bottom-width'));
    var x = $(this).offset().left;
    var y = $(this).offset().top;
    
	if($(this).css('position') == "relative"){
		var marginTop =  parseFloat($(this).css('margin-top'));
		var marginLeft = parseFloat($(this).css('margin-left'));
		return { top: top, left: left, width: width, height: height, marginTop:marginTop, marginLeft:marginLeft, x:x, y:y }
	}
	return { top: top, left: left, width: width, height: height, x:x, y:y }
}


$.fn.iuPercentFrame = function(){
    var iu = $(this);
    var parent = $(iu).parent();
    
    
    var pWidth = parseFloat(parent.iuPosition().width);
    var pHeight = parseFloat(parent.iuPosition().height);
    
    var top, height;
    if(pHeight == 0){
        top =0;
        height = 0;
    }
    else{
        top = (parseFloat($(iu).iuPosition().top) / pHeight) *100;
        height = (parseFloat($(iu).iuPosition().height) / pHeight )*100;
    }
    var left, width;
    if(pWidth == 0){
        left = 0;
        height = 0;
    }
    else{
        left = (parseFloat($(iu).iuPosition().left) / pWidth)*100;
        width = (parseFloat($(iu).iuPosition().width) / pWidth)*100;
    }
    
    return { top: top, left: left, width: width, height: height};
    
}


function getDictionaryKeys(dictionary){
    var keyArray = Object.keys(dictionary);
    return keyArray;
}

function getIUUpdatedFrameThread(){
    
    //새로운 인풋이 들어왔을때 변해야 하면 이곳에서 호출
    //editor mode 에서
    $('.IUBox').updatePixel();
    $('.bxslider').bxSlider();
    
    if (Object.keys(document.sharedFrameDict).length > 0
        && console.reportFrameDict ){
        
        console.reportFrameDict(document.sharedFrameDict);
        console.reportPercentFrame(document.sharedPercentFrameDict);
        
        document.sharedPercentFrameDict = {};
        document.sharedFrameDict = {};
    }
}

function resizePageContentHeight(){
    var height=0;
    $('.IUPageContent').siblings().each(function(){height += $(this).height()});
    height=$('.IUPageContent').parent().height()-height;
    $('.IUPageContent').css('height', height+'px');
    
    getIUUpdatedFrameThread();
}


$(document).ready(function(){
            console.log("ready : iuframe.js");
            resizePageContentHeight();
            getIUUpdatedFrameThread();
});

