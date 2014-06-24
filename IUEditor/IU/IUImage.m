//
//  IUImage.m
//  IUEditor
//
//  Created by JD on 4/1/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUImage.h"

@implementation IUImage

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUImage class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUImage class] properties]];
    
}

-(id)copyWithZone:(NSZone *)zone{
    IUImage *image = [super copyWithZone:zone];
    image.imageName = [_imageName copy];
    image.altText = [_altText copy];
    return image;
}

#pragma mark - 
#pragma mark IUImage

- (BOOL)shouldAddIUByUserInput{
    return NO;
}


- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self updateHTML];
}

@end
