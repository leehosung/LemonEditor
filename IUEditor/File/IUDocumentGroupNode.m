//
//  IUDirectoryNode.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentGroupNode.h"
#import "IUDocumentController.h"
#import "IUDocumentNode.h"

@implementation IUDocumentGroupNode{
}

-(NSArray*)allDocuments{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([evaluatedObject isKindOfClass:[IUDocumentNode class]]) {
            return YES;
        }
        return NO;
    }];
    NSArray *documentsNodes = [self.children filteredArrayUsingPredicate:predicate];
    return [documentsNodes valueForKey:@"document"];
}

@end
