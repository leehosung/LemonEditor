//for ie
var alertFallback = false;
if (typeof console === "undefined" || typeof console.log === "undefined") {
    console = {};
    if (alertFallback) {
        console.log = function(msg) {
            alert(msg);
        };
    } else {
        console.log = function() {};
    }
}


function isMobile(){
	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
	 	return true;
	}
	else{
		return false;
	}
}


function transitionAnimation(eventObject){
    if (typeof isEditor != 'undefined' && isEditor == true){
        return;
    }
    var effect = $(this).attr('transitionanimation');
    
    console.log('com');
    if ($(this).hasClass('selected')){
        var secondObj = $(this).children()[1];
        $(secondObj).hide(effect);
        $(this).removeClass('selected');
    }
    else {
        var secondObj = $(this).children()[1];
        $(secondObj).show(effect);
        $(this).addClass('selected');
    }
}

$(document).ready(function(){
    console.log('iu.js')
});

function onYouTubePlayerReady(playerId){
	console.log("playerId : "+playerId);
}

$(window).scroll(function(){
    if (typeof isEditor != 'undefined' && isEditor == true){

		return;
	}
	
	if(isMobile()==false){
		//autoplay when appear
		var scrollY = $(document).scrollTop();
		var screenH = $(window).height();
		var maxY = scrollY + screenH;
		$('[eventAutoplay]').each(function(){
			var yPos = $(this).offset().top;
			var type = $(this).attr('videotype');
			if(yPos > scrollY && yPos < maxY){
				//play
				if(type=='vimeo'){
					var vimeo = $f($(this).children()[0]);
					vimeo.api('play');
				
				}
				/*
				else if(type=='video'){
				$(this).load();
				$(this).play();
				}
				*/
			}
			else{
				//stop
				if(type=='vimeo'){
					var vimeo = $f($(this).children()[0]);
					vimeo.api('pause');
				}
			
			
			}
		});
	
		//move horizontally
		$('[opacitymove]').each(function(){
			var opacityMove = $(this).attr('opacitymove'); 
			var yPos = $(this).offset().top+$(this).outerHeight()/2;
			var percent = (yPos - scrollY)/(screenH/2);
			if(percent > 0){
				if(percent<=0.35){
					percent = percent*2.0;	
				}
				else if(percent>0.35 && percent <1.0){
					percent = 1.0;
				}
				else if(percent > 1.0){
					percent = percent - 1.0;
					percent = 1.0 - percent;
				}
				$(this).css('opacity', percent);
			}
		});
		$('[xPosMove]').each(function(){
			startLeft = parseFloat($(this).attr('startLeft')); 
			xMove = parseFloat($(this).attr('xPosMove')); 
			y = $(window).height()/1.5;
			x = (scrollY- $(this).offset().top+screenH);
		
			var left = (startLeft) +  xMove/y* x;
		
			if (xMove > 0){
				if (left < startLeft){
					left = startLeft;
				}
				else if ( left > startLeft + xMove ){
					left = startLeft + xMove;
				}
			}
			else {
				if (left > startLeft){
					left = startLeft;
				}
				else if ( left < startLeft + xMove ){
					left = startLeft + xMove;
				}
			}
			$(this).css('left', left+'px');
		});
	
	}
});