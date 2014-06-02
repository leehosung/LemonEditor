//ready collection
$(document).ready(function(){
	/* Initialize IU.JS*/
	
	console.log('iu')
	if (typeof isEditor != 'undefined' && isEditor == true){
		return;
	}
	console.log('start : transition code');
                  
	//Initialize transition
	$('.IUTransition').each(function(){
		var eventType = $(this).attr('transitionevent');
		var transitionanimation = $(this).attr('transitionanimation');
                                          
		if (eventType=='mouseOn'){
			$(this).bind('mouseenter',window[transitionanimation]);
			$(this).bind('mouseleave',window[transitionanimation]);
		}
		else {
			$(this).bind(eventType, window[transitionanimation]);
		}
		if (transitionanimation == 'flyFromRight'){
			$($(this).children()[1]).css('left', '100%');
		}
	});
                  
	//move : current viewport pc type
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
                  
	/* Initialize IUFrame.js */
	console.log("ready : iuframe");
	resizePageContentHeight();
	resizeCollection();
	reframeCenter();
	resizePageLinkSet();

/*INIT_JS_REPLACEMENT*/
            
});
