//
//  IUDocument.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocument.h"
#import "IUProject.h"

@implementation IUDocument

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ghostX = [aDecoder decodeFloatForKey:@"ghostX"];
        _ghostY = [aDecoder decodeFloatForKey:@"ghostY"];
        _ghostOpacity = [aDecoder decodeFloatForKey:@"ghostOpacity"];
        _ghostImageName = [aDecoder decodeObjectForKey:@"ghostImageName"];
        _group = [aDecoder decodeObjectForKey:@"group"];

    }
    return self;
}


- (BOOL)enableXUserInput{
    return NO;
}
- (BOOL)enableYUserInput{
    return NO;
}
- (BOOL)enableWidthUserInput{
    return NO;
}

- (BOOL)enableHeightUserInput{
    return NO;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFloat:_ghostX forKey:@"ghostX"];
    [aCoder encodeFloat:_ghostY forKey:@"ghostY"];
    [aCoder encodeFloat:_ghostOpacity forKey:@"ghostOpacity"];
    [aCoder encodeObject:_ghostImageName forKey:@"ghostImageName"];
    [aCoder encodeObject:_group forKey:@"group"];
}




-(NSString*)editorSource{
    assert(self.project.compiler);
    return [self.project.compiler editorSource:self mqSizeArray:_mqSizeArray];
}

- (NSString*)outputSource{
    assert(self.project.compiler);
    return [self.project.compiler outputSource:self mqSizeArray:_mqSizeArray];;
}

- (NSString*)outputInitJSSource{
    return [self.project.compiler outputJSInitializeSource:self];
}

-(NSArray*)widthWithCSS{
    return @[];
}

-(IUBox *)selectableIUAtPoint:(CGPoint)point{
    return nil;
}

@end