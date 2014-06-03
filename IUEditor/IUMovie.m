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
#import "IUDocument.h"
#import "IUCompiler.h"


@implementation IUMovie

- (void)fetch{
    [super fetch];
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
