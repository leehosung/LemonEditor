function resize(){
    if ( typeof isEditor == 'undefined'){
        var height=0;
        $('.IUPageContent').siblings().each(function(){height += $(this).height()});
        height=$('.IUPageContent').parent().height()-height;
        $('.IUPageContent').css('height', height+'px');
    }
}

$(document).ready(function(){
                  console.log("ready : iu.js");
                  $(window).resize(resize());
});
