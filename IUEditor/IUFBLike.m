//
//  IUFBLike.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 23..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUFBLike.h"
@interface IUFBLike()

@property NSString *fbSource;

@end

@implementation IUFBLike{
}

-(id)initWithManager:(IUIdentifierManager *)identifierManager{
    self = [super initWithManager:identifierManager];
    if(self){
        _fbSource = @"<iframe src=\"//www.facebook.com/plugins/like.php?href=__FB_LINK_ADDRESS__+&amp;width&amp;layout=standard&amp;action=like&amp;show_faces=__SHOW_FACE__&amp;share=true&amp;\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; height:__HEIGHT__px\" allowTransparency=\"true\"></iframe>";
        _showFriendsFace = YES;
        [self addObserver:self forKeyPaths:@[@"showFriendsFace", @"likePage"] options:0 context:@"IUFBSource"];
        [self.css setValue:@(80) forTag:IUCSSTagHeight forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:@(350) forTag:IUCSSTagWidth forWidth:IUCSSMaxViewPortWidth];
        [self.css setValue:nil forTag:IUCSSTagBGColor forWidth:IUCSSMaxViewPortWidth];


    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUFBLike class] properties]];
        [self addObserver:self forKeyPaths:@[@"showFriendsFace", @"likePage"] options:0 context:@"IUFBSource"];

    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUFBLike class] properties]];
    
}

- (void)IUFBSourceContextDidChange:(NSDictionary *)change{
    NSString *showFaces;
    if(self.showFriendsFace){
        [self.css setValue:@(80) forTag:IUCSSTagHeight];
        showFaces = @"true";
    }else{
        [self.css setValue:@(35) forTag:IUCSSTagHeight];
        showFaces = @"false";
    }
    NSString *currentPixel = [[NSString alloc] initWithFormat:@"%.0f", [self.css.assembledTagDictionary[IUCSSTagHeight] floatValue]];
    
    NSString *source;
    source = [self.fbSource stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:currentPixel];
    source = [source stringByReplacingOccurrencesOfString:@"__SHOW_FACE__" withString:showFaces];
    
    source = [source stringByReplacingOccurrencesOfString:@"__FB_LINK_ADDRESS__" withString:self.likePage];
    
    self.innerHTML = source;
}

-(BOOL)hasWidth{
    return NO;
}
-(BOOL)hasHeight{
    return NO;
}

@end
