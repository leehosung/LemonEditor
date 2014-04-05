//
//  IUTreeController.m
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUController.h"
#import "IUDocument.h"
#import "NSTreeController+JDExtension.h"

@implementation IUController

#pragma mark LMCanvasVCDelegate
-(void)IUSelected:(NSArray *)identifiers{
    IUDocument *document = [self.content firstObject];
    NSArray *allChildren = [document allChildren];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUObj *iu, NSDictionary *bindings) {
        if ([identifiers containsObject:iu.htmlID]) {
            return YES;
        }
        return NO;
    }];
    NSArray *selectedChildren = [allChildren filteredArrayUsingPredicate:predicate];
    [self setSelectedObjects:selectedChildren];
}


@end
