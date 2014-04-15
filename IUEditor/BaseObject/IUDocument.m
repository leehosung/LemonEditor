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
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
}


-(NSString*)editorSource{
    return [self.compiler editorSource:self];
}

- (NSString*)outputSource{
    //TODO
    return self.editorSource;
}

-(NSArray*)widthWithCSS{
    return @[];
}

-(IUBox *)selectableIUAtPoint:(CGPoint)point{
    return nil;
}

@end