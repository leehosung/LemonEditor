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

#pragma mark - 
#pragma mark IUImage

- (BOOL)shouldAddIUByUserInput{
    return NO;
}

-(BOOL)shouldEditText{
    return NO;
}

- (void)insertImage:(NSString *)imageName{
    self.imageName = imageName;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.htmlID];
}


@end
