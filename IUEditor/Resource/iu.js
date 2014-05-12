function overlap(e){
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
	if ($(this).hasClass('selected')){
		var secondObj = $(this).children()[1];
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
    var width = (window.innerWidth > 0) ? window.innerWidth : screen.width;
    if (width > 360){
	    $('[opacitymove]').each(function(){
			var opacity = $(this).attr('opacitymove');
		    $(this).css('opacity', 1-opacity);
		});
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

$(window).scroll(function(){
	if (isEditor == true){
		return;
	}
    var width = (window.innerWidth > 0) ? window.innerWidth : screen.width;
    if (width > 360){
	    $('[opacitymove]').each(function(){
			var opacityMove = $(this).attr('opacitymove'); 
			var opacity = (1-opacityMove) +  opacityMove/($(window).height()/1.7)*($(document).scrollTop() - $(this).offset().top+$(window).height());
			if (opacity > 1){
				opacity = 1;
			}
			if (opacity < 1 - opacityMove){
				opacity = 1 - opacityMove;
			}
			$(this).css('opacity', opacity);
		});
	    $('[xPosMove]').each(function(){
			startLeft = parseFloat($(this).attr('startLeft')); 
			xMove = parseFloat($(this).attr('xPosMove')); 
			y = $(window).height()/1.7;
			x = ($(document).scrollTop() - $(this).offset().top+$(window).height());
		
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