//
//  IUWebMovie.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUWebMovie.h"

@implementation IUWebMovie

-(id)initWithManager:(IUIdentifierManager*)manager{
    self = [super initWithManager:manager];
    if(self){
        _webMovieSource = @"<iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/9bZkp7q19f0?list=PLEC422D53B7588DC7\" frameborder=\"0\" allowfullscreen></iframe>";
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUWebMovie class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUWebMovie class] properties]];
    
}


-(BOOL)shouldADDIU{
    return NO;
}

-(void)setWebMovieSource:(NSString *)aWebMovieSource{
    _webMovieSource = aWebMovieSource;
    
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
    
    self.innerHTML = changeSource;
}


@end
