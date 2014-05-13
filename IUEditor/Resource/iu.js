function isMobile(){
	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
	 	return true;
	}
	else{
		return false;
	}
}

function overlap(e){
	if (isEditor == true){
		return;
	}
	console.log('com');
	if ($(this).hasClass('selected')){
		var secondObj = $(this).children()[1];
		$(secondObj).css('visibility','hidden');
		$(this).removeClass('selected');
	}
	else {
		var secondObj = $(this).children()[1];
		$(secondObj).css('visibility','visible');
		$(this).addClass('selected');
	}
}


function flyFromRight(eventObject){
	if (isEditor == true){
		return;
	}
    if ($(this).hasClass('selected')){
		var secondObj = $(this).children()[1];
        $(secondObj).css('visibility', 'hidden');
		$(secondObj).animate({
			'left': '1000%',			
		}, 200);
		$(this).removeClass('selected');
	}
	else {
		var secondObj = $(this).children()[1];
		$(secondObj).css('visibility','visible');
		$(secondObj).css('left','100%');
		$(secondObj).animate({
			'left': '0%',			
		}, 200);
		$(this).addClass('selected');
	}
}

$(document).ready(function(){
    if (isEditor == true){
        return;
    }
    console.log('start : transition code');
                 
	$('.IUTransition').each(function(){
		var eventType = $(this).attr('transitionevent');
		var transitionanimation = $(this).attr('transitionanimation');
		
		if (eventType=='mouseOn'){
			$(this).bind('mouseenter',flyFromRight);
			$(this).bind('mouseleave',flyFromRight);
		}
		else {
			$(this).bind(eventType, transitionanimation);
		}
	});
});


// move
$(document).ready(function(){
	if (isEditor == true){
		return;
	}
	if(isMobile()==false){
	    $('[xPosMove]').each(function(){
			var xPosMove = $(this).attr('xPosMove');
			if ($(this).css('position') == 'absolute'){
				var startLeft = parseFloat($(this).css('left')) - xPosMove;
			    $(this).css('left', startLeft + 'px');
				$(this).attr('startLeft', startLeft);
			};
		});
	}
});

function onYouTubePlayerReady(playerId){
	console.log("playerId : "+playerId);
}

$(window).scroll(function(){
	if (isEditor == true){
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