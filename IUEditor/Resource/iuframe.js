
function resizePageContentHeight(){
	//for page file,
	//make page content height
    var height=0;
    $('.IUPageContent').siblings().each(function(){height += $(this).height()});
    height=$('.IUPageContent').parent().height()-height;
    $('.IUPageContent').css('height', height+'px');
	
	//make min height of page content
	var minHeight=0;
    $('.IUPageContent').children().each(function(){
		if (minHeight < $(this).height() + $(this).position().top){
			minHeight = $(this).height() + $(this).position().top;
		}
    });
    $('.IUPageContent').css('min-height', minHeight+'px');
}



function resizeCollection(){
	$('.IUCollection').each(function(){
		var responsive = $(this).attr('responsive');
		responsiveArray = eval(responsive);
		count = $(this).attr('defaultItemCount');
		viewPortWidth = $(window).width();
		for (var index in responsiveArray){
			dict = responsiveArray[index];
			width = dict.width;
			if (viewPortWidth<width){
				count = dict.count;
			}
		}
		widthStr = 1/count *100 + '%';
		$(this).children().css('width', widthStr);		
	});
}


$(document).ready(function(){
            console.log("ready : iuframe.js");
            resizePageContentHeight();
			resizeCollection();
});
