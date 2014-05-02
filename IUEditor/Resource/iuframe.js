
function resizePageContentHeight(){
    var height=0;
    $('.IUPageContent').siblings().each(function(){height += $(this).height()});
    height=$('.IUPageContent').parent().height()-height;
    $('.IUPageContent').css('height', height+'px');
}

function resizeBackgroundHeight(){
    var height=0;
    $('.IUBackground').children().each(function(){height += $(this).height()});
    height=$('.IUBackground').parent().height()-height;
    $('.IUBackground').css('height', height+'px');

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
                  resizeBackgroundHeight();
//			resizeCollection();
});
