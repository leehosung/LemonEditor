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

- (BOOL)shouldAddIU{
    return NO;
}

- (void)insertImage:(NSString *)imageName{
    self.imageName = imageName;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.delegate IU:self.htmlID HTML:self.html withParentID:self.htmlID];
}

- (NSDictionary *)HTMLAtributes{
    NSMutableDictionary *dict = [[super HTMLAtributes] mutableCopy];
    
    if(self.imageName){
        [dict setObject:self.imageName forKey:@"src"];
    }
    
    if(self.altText){
        [dict setObject:self.altText forKey:@"alt"];
    }
    
    return dict;
}

@end
