//
//  IUWebMovie.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUWebMovie.h"

@interface IUWebMovie()


@end

@implementation IUWebMovie{
}

-(id)initWithManager:(IUIdentifierManager*)manager option:(NSDictionary *)option{
    self = [super initWithManager:manager option:option];
    if(self){
        _thumbnail = NO;
        _type = @"webMovie";
        _webMovieSource = @"<iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/9bZkp7q19f0?list=PLEC422D53B7588DC7\" frameborder=\"0\" allowfullscreen></iframe>";
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUWebMovie class] properties]];
        //call thumbnail data
        self.webMovieSource = _webMovieSource;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUWebMovie class] properties]];
    
}


- (BOOL)shouldAddIUByUserInput{
    return NO;
}

- (BOOL)shouldEditText{
    return NO;
}

-(void)setWebMovieSource:(NSString *)aWebMovieSource{
    _webMovieSource = aWebMovieSource;
    _thumbnail = NO;
    
    if(aWebMovieSource == nil || aWebMovieSource.length ==0 ){
        self.innerHTML = @"";
        return;
    }
    
    //width, height => 100%, innerHTML에 적용
    NSString *changeSource = aWebMovieSource;
    
    if ([changeSource containsString:@"src=\"//"]) {
        changeSource= [changeSource stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"http://"];
    }
    
    if([changeSource containsString:@"height"]){
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"height=\"([0-9]*)\""
                                                                             options:NSRegularExpressionCaseInsensitive error:nil];
        
        changeSource = [regex stringByReplacingMatchesInString:changeSource
                                                          options:0
                                                            range:NSMakeRange(0, [changeSource length])
                                                     withTemplate:[NSString stringWithFormat:@"height=100%%"]];
    }
    
    if([changeSource containsString:@"width"]){
        NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:@"width=\"([0-9]*)\""
                                                                             options:NSRegularExpressionCaseInsensitive error:nil];
        
        changeSource = [regex stringByReplacingMatchesInString:changeSource
                                                          options:0
                                                            range:NSMakeRange(0, [changeSource length])
                                                     withTemplate:[NSString stringWithFormat:@"width=100%%"]];
    }
    
    NSMutableString *appendSource= [NSMutableString stringWithString:changeSource];
    NSString *videoID;
    NSRange optionRange = [changeSource rangeOfString:@"?"];

    //use api
    if([changeSource containsString:@"youtube"]){
        _type = @"youtube";
        videoID = [NSString stringWithFormat:@"%@_%@", self.htmlID, _type];
        NSString *option = [NSString stringWithFormat:@"version=3&enablejsapi=1&"];
        if(optionRange.length == 0){
            NSRange range = [appendSource rangeOfString:@"/embed/"];
            NSInteger start = range.length+range.location +11;
            [appendSource insertString:[NSString stringWithFormat:@"?%@", option] atIndex:start];
        }
        else{
            [appendSource insertString:option atIndex:optionRange.location + optionRange.length];
        }
    }
    else if([changeSource containsString:@"vimeo"]){
        _type = @"vimeo";
        videoID = [NSString stringWithFormat:@"%@_%@", self.htmlID, _type];
        NSString *option = [NSString stringWithFormat:@"api=1&player_id=%@&", videoID];
        if(optionRange.length == 0){
            NSRange range = [appendSource rangeOfString:@"/video/"];
            NSInteger start = range.length+range.location +8;
            [appendSource insertString:[NSString stringWithFormat:@"?%@", option] atIndex:start];
        }
        else{
            [appendSource insertString:option atIndex:optionRange.location + optionRange.length];
        }
        
    }
    
    NSRange iframeRange = [appendSource rangeOfString:@"<iframe"];
    if(iframeRange.length >0 && videoID){
        [appendSource insertString:[NSString stringWithFormat:@" id='%@'", videoID] atIndex:iframeRange.location+iframeRange.length];
    }

    
    [self thumbnailOfWebMovieSource:_webMovieSource];
    self.innerHTML = appendSource;
}

-(void)thumbnailOfWebMovieSource:(NSString *)webMovieSource{
    
    if ([webMovieSource containsString:@"youtube"]){
        NSRange range = [self.webMovieSource rangeOfString:@"/embed/"];
        NSInteger start = range.length+range.location;
        NSString *idStr = [self.webMovieSource substringWithRange:NSMakeRange(start, 11)];
        if([_thumbnailID isEqualToString:idStr]){
            _thumbnail = YES;
            return;
        }
        _thumbnailID = idStr;
        _thumbnailPath = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/sddefault.jpg", idStr ];
        _thumbnail = YES;
        
    }
    // 2. vimeo
    else if ([webMovieSource containsString:@"vimeo"]){
        NSRange range = [self.webMovieSource rangeOfString:@"/video/"];
        NSInteger start = range.length+range.location;
        NSString *idStr = [self.webMovieSource substringWithRange:NSMakeRange(start, 8)];
        if([_thumbnailID isEqualToString:idStr]){
            _thumbnail = YES;
            return;
        }
        _thumbnailID = idStr;
        NSURL *filePath =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.vimeo.com/api/v2/video/%@.json", idStr]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
            NSData* data = [NSData dataWithContentsOfURL:
                            filePath];
            [self performSelectorOnMainThread:@selector(fetchedVimeoData:)
                                   withObject:data waitUntilDone:YES];
        });
        
        /* vimeo example src
         *
         <iframe src="//player.vimeo.com/video/87939713?title=0&amp;byline=0&amp;portrait=0&amp;color=afd9cd" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/87939713">Happy Camper - The Daily Drumbeat</a> from <a href="http://vimeo.com/jobjorismarieke">Job, Joris &amp; Marieke</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
         */
    }
}

- (void)fetchedVimeoData:(NSData *)responseData {

    //data 연결 등의 문제로 empty일때
    if(responseData == nil) return;
    NSError* error;
    
    //parse out the json data
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    
    NSDictionary* vimeoDict = json[0];
    _thumbnailPath = [vimeoDict objectForKey:@"thumbnail_large"]; //2
    _thumbnail = YES;
    
    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
    
    
}

/*
 *
 add for scroll event
 ㅇ
 $(document).scroll(function(){
 var vimeo = $('#vimeo_94631360');
 var height = $(this).scrollTop();
 var vimeo_location =  vimeo.offset().top;
 var vimeo_height = vimeo.outerHeight();
 if(height>=vimeo_location-200){
 froogaloop.api('play');
 }
 else{
 froogaloop.api('pause');
 }
 if(height>=vimeo_location+100){
 froogaloop.api('pause');
 }
 });
 
 $(document).ready(function(){
 console.log('ready : iuevent.js')
 
 var vimeo = $('#vimeo_94631360');
 froogaloop = $f(vimeo[0].id);
 
 */

@end
