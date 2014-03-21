//
//  IUDocument.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocument.h"

@implementation IUDocument

-(NSString*)editorSource{
    return @"";
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