//
//  IUDocument.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocument.h"

@implementation IUDocument


-(id)initWithSetting:(NSDictionary*)setting{
    self = [super initWithSetting:setting];
    if (self) {
        
    }
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
    return [_compiler generateEditorSource:self];
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