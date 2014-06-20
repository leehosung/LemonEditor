
function resizePageContentHeight(){
	//for page file,
	//make page content height
    var height=0;
    $('.IUPageContent').siblings().each(function(){height += $(this).height()});
    height=$(window).height()-height;
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
//		widthStr = 1/count *100 + '%';
//		$(this).children().css('width', widthStr);
	});
}

function reframeCenter(){
    
    var respc = $('[horizontalCenter="1"]').toArray();
    $.each(respc, function( i, iu ){
		//if flow layout, margin auto
		//if absolute layout, set left
		$(this).css('margin-left', 'auto');
        $(this).css('margin-right', 'auto');
        $(this).css('left','');
		var pos = $(this).css('position');
           if (pos == 'absolute'){
           var parentW;
           var parent = $(this).parent();
           if(parent.prop('tagName') == 'A'){
            parentW = parent.parent().width();
           }
           else{
            parentW = $(this).parent().width();
           }
           
           var myW = $(this).width();
           $(this).css('left', (parentW-myW)/2 + 'px');
           }
    });
}

function resizePageLinkSet(){
	$('.PGPageLinkSet div').each(function(){
		len = $(this).children().children().length;
		m = parseFloat($(this).children().children().children().css('margin-left'));
		w = $(this).children().children().children().width();
		width = (2*m+w)*len;
		$(this).width(width+'px');
	});
}

function setTextAutoHeight(){
    var respc = $('[autolineheight="1"]').toArray();
    $.each(respc, function(){
           var brCount = $("br", $(this)).length;
           if(brCount == 0){
                brCount = 1;
           }
           var height = $(this).height();
           var lineheight = height/brCount;
           $(this).css('line-height', lineheight+'px');
           });
}


$(window).resize(function(){
                 console.log("resize window : iuframe.js");
                 resizePageContentHeight();
                 resizeCollection();
                 reframeCenter();
				 resizePageLinkSet();
                 });

$(document).ready(function(){
                 console.log("ready : iuframe.js");
                 });


