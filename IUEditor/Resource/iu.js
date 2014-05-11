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