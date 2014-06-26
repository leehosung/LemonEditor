//
//  IUMovie.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUMovie.h"
#import <AVFoundation/AVFoundation.h>

#import "IUImageUtil.h"
#import "IUSheet.h"
#import "IUCompiler.h"


@implementation IUMovie

- (void)connectWithEditor{
    [super connectWithEditor];
    [self addObserver:self forKeyPaths:@[@"enableControl", @"enableLoop", @"enableMute", @"enableAutoPlay",@"cover", @"altText", @"posterPath"] options:0 context:@"attributes"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUMovie class] properties]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUMovie class] properties]];
    
}

-(id)copyWithZone:(NSZone *)zone{
    IUMovie *movie = [super copyWithZone:zone];
    movie.videoPath = [_videoPath copy];
    movie.altText = [_altText copy];
    movie.posterPath = [_posterPath copy];
    
    movie.enableAutoPlay = _enableAutoPlay;
    movie.enableControl = _enableControl;
    movie.enableLoop = _enableLoop;
    movie.enableMute = _enableMute;
    
    return movie;
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"enableControl", @"enableLoop", @"enableMute", @"enableAutoPlay",@"cover", @"altText", @"posterPath"]];
}

- (BOOL)shouldAddIUByUserInput{
    return NO;
}


- (void)setVideoPath:(NSString *)videoPath{
    _videoPath = videoPath;
    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
}

- (void)attributesContextDidChange:(NSDictionary *)change{
    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
}

@end
