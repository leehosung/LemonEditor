//
//  IUDocumentController.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentController.h"

@implementation IUDocumentController
-(id)initWithDocument:(IUDocument*)document{
    NSAssert(document!=nil, @"document is nil");
    self = [super init];
    if (self) {
        [self setChildrenKeyPath:@"children"];
        [self setObjectClass:[IUBox class]];
        [self setContent:document];
    }
    return self;
}

-(IUDocument*)document{
    NSAssert(self.content != nil, @"content is nil");
    return [self.content objectAtIndex:0];
}

-(IUProject*)project{
    return [self.content firstObject];
}

-(NSString*)keyPathFromDocumentControllerToEventVariables{
    return @"documentController.project.eventVariable.eventVariableArray";
}

-(void)setContent:(id)content{
    [self willChangeValueForKey:@"document"];
    [self willChangeValueForKey:@"project"];
    [super setContent:content];
    [self didChangeValueForKey:@"project"];
    [self didChangeValueForKey:@"document"];
}

@end
