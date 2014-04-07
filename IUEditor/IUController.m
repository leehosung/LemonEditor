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


#pragma mark set By LMCanvasVC

-(void)setSelectedObjectsByIdentifiers:(NSArray *)identifiers{
    [JDLogUtil log:IULogAction key:@"canvas selected objects" string:[identifiers description]];
    IUDocument *document = [self.content firstObject];
    NSArray *allChildren = [[document allChildren] arrayByAddingObject:document];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUObj *iu, NSDictionary *bindings) {
        if ([identifiers containsObject:iu.htmlID]) {
            return YES;
        }
        return NO;
    }];
    NSArray *selectedChildren = [allChildren filteredArrayUsingPredicate:predicate];
    [self setSelectedObjects:selectedChildren];
}

-(NSArray*)selectedIdentifiers{
    return [self.selectedObjects valueForKey:@"htmlID"];
}

@end
