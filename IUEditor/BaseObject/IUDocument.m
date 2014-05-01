//
//  IUDocument.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocument.h"

@implementation IUDocument


-(id)initWithManager:(IUIdentifierManager *)manager{
    self = [super initWithManager:manager];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ghostX = [aDecoder decodeFloatForKey:@"ghostX"];
        _ghostY = [aDecoder decodeFloatForKey:@"ghostY"];
        _ghostImageName = [aDecoder decodeObjectForKey:@"ghostImageName"];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFloat:_ghostX forKey:@"ghostX"];
    [aCoder encodeFloat:_ghostY forKey:@"ghostY"];
    [aCoder encodeObject:_ghostImageName forKey:@"ghostImageName"];
}


-(NSString*)editorSource{
    return [self.compiler editorSource:self mqSizeArray:_mqSizeArray];
}

- (NSString*)outputSource{
    return [self.compiler outputSource:self mqSizeArray:_mqSizeArray];;
}

- (NSString*)outputInitJSSource{
    return [self.compiler outputJSInitializeSource:self];
}

-(NSArray*)widthWithCSS{
    return @[];
}

-(IUBox *)selectableIUAtPoint:(CGPoint)point{
    return nil;
}

@end