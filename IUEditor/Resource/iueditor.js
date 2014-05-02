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
	var width = $(this).outerWidth();
	var height = $(this).outerHeight();
    var x = $(this).offset().left;
    var y = $(this).offset().top;
    
    //carouselitem position
    var carouselID = $(this).attr('carouselID');
    
    if(carouselID != undefined){
        var carousel = document.getElementById(carouselID)
        x = $(carousel).iuPosition().x
    }
    
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

function resizePageContentHeightEditor(){
	//make page content height
    if ($('.IUPage') == null){
        //if it is not page file, return
        return;
    }
    if ($('.IUPageContent')){
        //make min height of page content
        var minHeight=500;
        $('.IUPageContent').children().each(function(){
                                            var newValue = $(this).height()+$(this).position().top;
                                            if (newValue > minHeight){
                                            minHeight = newValue;
                                            }});
        $('.IUPageContent').css('min-height', minHeight+'px');
        console.log('pagecontentminheight :' + minHeight);
        
        var pageHeight=minHeight;
		pageHeight += $('.IUHeader').height();
        console.resizePageContentHeightFinished(pageHeight);
    }
    else {
        console.log('failed!!!!!');
        //background 가 없으면 page content 도 없는데...
    }
}

function getIUUpdatedFrameThread(){
    //새로운 인풋이 들어왔을때 변해야 하면 이곳에서 호출
    //editor mode 에서
    console.log('iu update thread');
    $('.IUBox').updatePixel();
    
    if (Object.keys(document.sharedFrameDict).length > 0
        && console.reportFrameDict ){
        
        console.reportFrameDict(document.sharedFrameDict);
        //console.reportPercentFrame(document.sharedPercentFrameDict);
        
        document.sharedPercentFrameDict = {};
        document.sharedFrameDict = {};
    }
    resizePageContentHeightEditor();
}

function resizeBackgroundSize(){
    var height=0;
    $('.IUBackground').css('height', '100%');
    $('.IUBackground').css('width', '100%');
}

$(document).ready(function(){
            console.log("ready : iueditor.js");
            resizePageContentHeightEditor();
            getIUUpdatedFrameThread();
            resizeBackgroundSize();

});
