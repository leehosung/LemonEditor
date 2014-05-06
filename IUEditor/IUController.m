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


- (id)selection{
    if ([self.selectedObjects count] == 1) {
        return [[self selectedObjects] objectAtIndex:0];
    }
    return [super selection];
}


-(NSArray*)selectedPedigree{
    if ([self.selectedObjects count]==0) {
        return nil;
    }
    
    IUBox *firstObj = [self.selectedObjects objectAtIndex:0];
    NSMutableArray *firstPedigrees = [[[firstObj class] classPedigreeTo:[IUBox class]] mutableCopy];
    NSMutableArray *retArray = [firstPedigrees mutableCopy];
    
    for (NSString *aPedigree in firstPedigrees) {
        for (IUBox *obj in self.selectedObjects) {
            Class class = NSClassFromString(aPedigree);
            if ([obj isKindOfClass:class] == NO) {
                [retArray removeObject:aPedigree];
            }
        }
    }
    
    return retArray;
}

#pragma mark set By LMCanvasVC

- (BOOL)setSelectionIndexPaths:(NSArray *)indexPaths{
    [self willChangeValueForKey:@"selectedTextRange"];
    _selectedTextRange = NSZeroRange;
    BOOL result = [super setSelectionIndexPaths:indexPaths];
    [self didChangeValueForKey:@"selectedTextRange"];
    return result;
}

- (BOOL)setSelectionIndexPath:(NSIndexPath *)indexPath{
    [self willChangeValueForKey:@"selectedTextRange"];
    _selectedTextRange = NSZeroRange;
    BOOL result = [super setSelectionIndexPath:indexPath];
    [self didChangeValueForKey:@"selectedTextRange"];
    return result;
}


-(void)trySetSelectedObjectsByIdentifiers:(NSArray *)identifiers{
    [JDLogUtil log:IULogAction key:@"canvas selected objects" string:[identifiers description]];
    IUDocument *document = [self.content firstObject];
    
    NSString *firstIdentifier = [identifiers firstObject];
    if ([firstIdentifier containsString:@"__"]) { // it's in import!
        NSArray *IUChain = [firstIdentifier componentsSeparatedByString:@"__"];
        NSString *documentIUIdentifier = [IUChain firstObject];

        IUDocument *parentDoc = (IUDocument*)[self IUBoxByIdentifier:documentIUIdentifier];
        NSIndexPath *documentPath = [self indexPathOfObject:parentDoc];

        NSArray *allChildren = [[parentDoc allChildren] arrayByAddingObject:document];
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUBox *iu, NSDictionary *bindings) {
            for (NSString *identifier in identifiers) {
                NSString *childIdentifier = [identifier substringFromIndex:[documentIUIdentifier length]+2];
                if ([childIdentifier isEqualToString:iu.htmlID]) {
                    return YES;
                }
            }
            return NO;
        }];
        NSArray *selectedChildren = [allChildren filteredArrayUsingPredicate:predicate];

        NSMutableArray *indexPaths = [NSMutableArray array];
        for (IUBox *selectedIU in selectedChildren) {
            [indexPaths addObjectsFromArray:[self indexPathsOfObject:selectedIU]];
        }
        
        NSPredicate *selectIndexPathPredicate = [NSPredicate predicateWithBlock:^BOOL(NSIndexPath *path, NSDictionary *bindings) {
            if ([path containsIndexPath:documentPath]) {
                return YES;
            }
            return NO;
        }];
        

        NSArray *selectedPaths = [indexPaths filteredArrayUsingPredicate:selectIndexPathPredicate];
        
        [self setSelectionIndexPaths:selectedPaths];
        
    }
    else {
        NSArray *allChildren = [[document allChildren] arrayByAddingObject:document];
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUBox *iu, NSDictionary *bindings) {
            if ([identifiers containsObject:iu.htmlID]) {
                return YES;
            }
            return NO;
        }];
        NSArray *selectedChildren = [allChildren filteredArrayUsingPredicate:predicate];
        // if selection is IUItem subclass, it's parent should be selected before
        //FIXME: need to change
        
        [self _setSelectedObjects:selectedChildren];
    }
    
}


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

-(NSString*)keyPathFromControllerToCSSTag:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary" stringByAppendingPathExtension:tag];
}

-(NSString*)keyPathFromControllerToEventTag:(IUEventTag)tag{
    return [@"controller.selection.event" stringByAppendingPathExtension:tag];
}

-(NSString*)keyPathFromControllerToProperty:(NSString*)property{
    return [@"controller.selection" stringByAppendingPathExtension:property];
}

@end
