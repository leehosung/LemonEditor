//
//  IUDocument.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocument.h"

@implementation IUDocument


-(id)initWithProject:(IUProject *)project setting:(NSDictionary *)setting{
    self = [super initWithProject:project setting:setting];
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
    assert(self.project);
    return [self.project.compiler editorSource:self];
}

-(NSArray*)widthWithCSS{
    return @[];
}

-(IUObj *)selectableIUAtPoint:(CGPoint)point{
    return nil;
}


-(void)addReferenceToIUDocument:(IUDocument*)document{
    
}
-(void)removeReferenceToIUDocument:(IUDocument*)document{
    
}

-(void)addReferenceFromIUDocument:(IUDocument*)document{
    
}
-(void)removeReferenceFromIUDocument:(IUDocument*)document{
    
}

@end