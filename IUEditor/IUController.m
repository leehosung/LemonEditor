//
//  IUTreeController.m
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUController.h"
#import "IUSheet.h"
#import "NSTreeController+JDExtension.h"
#import "NSIndexPath+JDExtension.h"
#import "IUImport.h"
#import "IUProject.h"
#import "IUPage.h"

@implementation IUController{
    NSArray     *pasteboard;
    NSInteger   _pasteRepeatCount;
    IUBox       *_lastPastedIU;
}


- (void)awakeFromNib{
    [self addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectedObjects"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationSelectionDidChange object:self userInfo:@{@"selectedObjects": self.selectedObjects}];
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (id)selection{
    if ([self.selectedObjects count] == 1) {
        return [[self selectedObjects] objectAtIndex:0];
    }
    return [super selection];
}
- (void) dealloc{
    [self removeObserver:self forKeyPath:@"selectedObjects"];
}
-(void)copySelectedIUToPasteboard:(id)sender{
    pasteboard = [NSArray arrayWithArray:self.selectedObjects];
}

-(void)pasteToSelectedIU:(id)sender{
    IUBox *pasteTarget;
    BOOL pasteTargetIsParent;
    //copy할 때 현재 select가 된 object 를 저장했다가 paste에서도 똑같으면 parent에 copy
    if ([self.selectedObjects isEqualToArray:pasteboard] || _pasteRepeatCount) {
        //paste to parent
        if (_pasteRepeatCount == 0) {
            pasteTarget = [(IUBox*)[self.selectedObjects firstObject] parent];
        }
        else {
            pasteTarget = _lastPastedIU.parent;
        }
        pasteTargetIsParent = YES;
    }
    
    //copy할때와 paste할때 selection이 달라졌으면 selection 밑에 add
    else {
        //paste to selection
        pasteTarget = [self.selectedObjects firstObject];
        while (1) {
            if (pasteTarget == nil) {
                NSAssert(0, @"pasteTarget");
                return;
            }
            if ([pasteTarget shouldAddIUByUserInput]) {
                break;
            }
            pasteTarget = pasteTarget.parent;
        }
        pasteTargetIsParent = NO;
    }
    
    if([pasteTarget isMemberOfClass:[IUPage class]]){
        pasteTarget = (IUBox *)((IUPage *)pasteTarget).pageContent;
    }
    
    NSMutableArray *copiedArray = [NSMutableArray array];

    for (IUBox *box in pasteboard) {
        NSError *err;
        if([box canCopy]){
            IUBox *newBox = [box copy];
            newBox.name = newBox.htmlID;
            
            for (NSNumber *width in newBox.css.allEditWidth) {
                NSDictionary *tagDictionary;
                if (_pasteRepeatCount){
                    tagDictionary = [_lastPastedIU.css tagDictionaryForWidth:[width integerValue]];
                }
                else {
                    tagDictionary = [newBox.css tagDictionaryForWidth:[width integerValue]];
                }
                NSNumber *x = [tagDictionary valueForKey:IUCSSTagX];
                
                if (x) {
                    if (pasteTargetIsParent) {
                        NSNumber *newX = [NSNumber numberWithInteger:([x integerValue] + 10)];
                        [newBox.css setValue:newX forTag:IUCSSTagX forWidth:[width integerValue]];
                    }
                    else {
                        [newBox.css setValue:@(10) forTag:IUCSSTagX forWidth:[width integerValue]];
                    }
                }
                
                NSNumber *y = [tagDictionary valueForKey:IUCSSTagY];
                if (y) {
                    if (pasteTargetIsParent) {
                        NSNumber *newY = [NSNumber numberWithInteger:([y integerValue] + 10)];
                        [newBox.css setValue:newY forTag:IUCSSTagY forWidth:[width integerValue]];
                    }
                    else {
                        [newBox.css setValue:@(10) forTag:IUCSSTagY forWidth:[width integerValue]];
                    }
                }
                
            }
            BOOL result = [pasteTarget addIU:newBox error:&err];
            _lastPastedIU = newBox;
            [copiedArray addObject:newBox];
            [self rearrangeObjects];
            NSAssert(result, @"Add");
        }
    }
    [self _setSelectedObjects:copiedArray];
    _pasteRepeatCount ++;
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
    _selectedTextRange = NSMakeRange(0, 0);
    BOOL result = [super setSelectionIndexPaths:indexPaths];
    [self didChangeValueForKey:@"selectedTextRange"];
    return result;
}

- (BOOL)setSelectionIndexPath:(NSIndexPath *)indexPath{
    [self willChangeValueForKey:@"selectedTextRange"];
    _selectedTextRange = NSMakeRange(0, 0);
    BOOL result = [super setSelectionIndexPath:indexPath];
    [self didChangeValueForKey:@"selectedTextRange"];
    return result;
}


-(void)trySetSelectedObjectsByIdentifiers:(NSArray *)identifiers{
    [JDLogUtil log:IULogAction key:@"canvas selected objects" string:[identifiers description]];
    IUSheet *document = [self.content firstObject];
    
    NSString *firstIdentifier = [identifiers firstObject];
    if ([firstIdentifier containsString:@"ImportedBy_"]) { // it's imported!
        NSArray *IUChain = [firstIdentifier componentsSeparatedByString:@"_"];
        NSAssert(IUChain.count == 3, @"import in import");
        
        //get import class
        NSString *importIdentifier = [IUChain objectAtIndex:1];
        IUImport *import = [self IUBoxByIdentifier:importIdentifier];
        
        //get sheet
        IUSheet *sheet = import.prototypeClass;
        
        //get all selected IUs
        NSMutableArray *objIdentifiers = [NSMutableArray array];
        for (NSString *identifier in identifiers) {
            [objIdentifiers addObject:[[identifier componentsSeparatedByString:@"_"] objectAtIndex:2]];
        }
        
        NSArray *selectedIUs = [self IUBoxesByIdentifiers:objIdentifiers];
        
        
        //get all index paths of each selected iu

        NSMutableArray *indexPaths = [NSMutableArray array];
        for (IUBox *selectedIU in selectedIUs) {
            [indexPaths addObjectsFromArray:[self indexPathsOfObject:selectedIU]];
        }
        
        NSIndexPath *sheetPath = [self indexPathOfObject:sheet];
        NSPredicate *selectIndexPathPredicate = [NSPredicate predicateWithBlock:^BOOL(NSIndexPath *path, NSDictionary *bindings) {
            if ([path containsIndexPath:sheetPath]) {
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
        [self _setSelectedObjects:selectedChildren];
    }
    //paste repeat count zero
    _pasteRepeatCount = 0;
}


-(void)setSelectedObjectsByIdentifiers:(NSArray *)identifiers{
    [JDLogUtil log:IULogAction key:@"canvas selected objects" string:[identifiers description]];
    IUSheet *document = [self.content firstObject];
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

-(NSArray*)selectedIdentifiersWithImportIdentifier{
    //indexpath chain 중에 iuimport 가 있는지 검사
    IUImport *import = self.importIUInSelectionChain;
    if (import) {
        NSMutableArray *retArray = [NSMutableArray array];
        NSArray *htmlIDs = [self.selectedObjects valueForKeyPath:@"htmlID"];
        for (NSString *htmlID in htmlIDs) {
            [retArray addObject:[NSString stringWithFormat:@"ImportedBy_%@_%@", import.htmlID, htmlID]];
        }
        return retArray;
    }
    else {
        return [self.selectedObjects valueForKey:@"htmlID"];
    }
}

-(id)IUBoxByIdentifier:(NSString *)identifier{
    NSArray *findIUs = [self IUBoxesByIdentifiers:[NSArray arrayWithObject:identifier]];
    if(findIUs.count == 0){
        JDInfoLog(@"there is no IUID");
        return nil;
    }
    return findIUs[0];
}

-(NSArray *)IUBoxesByIdentifiers:(NSArray *)identifiers{
    IUSheet *document = [self.content firstObject];
    NSArray *allChildren = [[document allChildren] arrayByAddingObject:document];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUBox *iu, NSDictionary *bindings) {
        if ([identifiers containsString:iu.htmlID]) {
            return YES;
        }
        return NO;
    }];

    NSArray *filteredChildren = [allChildren filteredArrayUsingPredicate:predicate];
    return filteredChildren;
}


-(NSString*)keyPathFromControllerToTextCSSProperty:(NSString *)property{
    return [@"controller.selection.textController" stringByAppendingPathExtension:property];
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

-(IUImport*)importIUInSelectionChain{
    NSIndexPath *firstPath = [[self.selectionIndexPaths firstObject] indexPathByRemovingLastIndex];
    if(firstPath){
        NSArray *chain = [self IUChainOfIndexPath:firstPath];
        
        for (IUBox *box in chain) {
            if ([box isKindOfClass:[IUImport class]]) {
                return (IUImport *)box;
            }
        }
    }
    return nil;
}


-(NSArray*)IUChainOfIndexPath:(NSIndexPath*)path{
    NSMutableArray *retArray = [NSMutableArray array];
    IUBox *currentObj = [[self content] firstObject];
    [retArray addObject:currentObj];
    for (NSUInteger i=1; i<path.length ; i++) {
        NSInteger index = [path indexAtPosition:i];
        currentObj = [currentObj.children objectAtIndex:index];
        [retArray addObject:currentObj];
    }
    return retArray;
}

-(IUBox*)firstDeepestBox{
    IUBox *box = [[self content] firstObject];
    while ([box.children count] > 0) {
        box = [box.children objectAtIndex:0];
    }
    return box;
}

@end
