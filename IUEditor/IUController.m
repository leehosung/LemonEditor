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
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUBox *iu, NSDictionary *bindings) {
        if ([identifiers containsObject:iu.htmlID]) {
            return YES;
        }
        return NO;
    }];
    NSArray *selectedChildren = [allChildren filteredArrayUsingPredicate:predicate];
    [self _setSelectedObjects:selectedChildren];
}

-(NSArray*)selectedIdentifiers{
    return [self.selectedObjects valueForKey:@"htmlID"];
}

-(IUBox *)IUBoxByIdentifier:(NSString *)identifier{
    IUDocument *document = [self.content firstObject];
    NSArray *allChildren = [[document allChildren] arrayByAddingObject:document];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUBox *iu, NSDictionary *bindings) {
        if ([identifier isEqualToString:iu.htmlID]) {
            return YES;
        }
        return NO;
    }];
    NSArray *findIUs = [allChildren filteredArrayUsingPredicate:predicate];
    if(findIUs.count  > 1){
        JDErrorLog(@"Error : IUID can be unique");
        return nil;
    }
    if(findIUs.count == 0){
        JDInfoLog(@"there is no IUID");
        return nil;
    }
    
    return findIUs[0];
}

-(NSString*)requestNewIdentifierWithString:(NSString*)string{
    int i=0;
    while (1) {
        i++;
        NSString *identifier = [string stringByAppendingFormat:@"%d", i];
        if ([self IUBoxByIdentifier:identifier] == nil) {
            return identifier;
        }
    }
}

-(NSString*)keyPathFromControllerToTag:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary" stringByAppendingPathExtension:tag];
}

-(NSString*)keyPathFromControllerToProperty:(NSString*)property{
    return [@"controller.selection" stringByAppendingPathExtension:property];
}

@end
