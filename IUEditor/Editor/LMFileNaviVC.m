//
//  LMFileNaviVC.m
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviVC.h"
#import "IUDocumentNode.h"
#import "IUResourceNode.h"
#import "NSTreeController+JDExtension.h"

@interface LMFileNaviVC ()

@end

@implementation LMFileNaviVC{
    BOOL    viewLoadedOK;
    BOOL    loaded;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)selectionIndexPathsDidChange{
    JDTraceLog( @"selection");
}




-(void)selectionDidChange:(NSDictionary*)dict{
    [self willChangeValueForKey:@"selection"];
    _selection = [_documentController.selectedObjects firstObject];
    [self didChangeValueForKey:@"selection"];
}

-(void)setProject:(IUProject *)project{
    _project = project;
    _project.delegate = self;
    [_documentController setContent:_project];
    [_documentController addObserver:self forKeyPath:@"selection" options:0 context:nil];
    
}

-(void)selectFirstDocument{
    //find first document
    IUDocumentNode *documentNode;
    NSArray *arr = [_project allChildren];
    for (int i=0; i<[arr count]; i++) {
        if ([[arr objectAtIndex:i] isKindOfClass:[IUDocumentNode class]]) {
            documentNode = [arr objectAtIndex:i];
            break;
        }
    }
    [_documentController setSelectedObject:documentNode];
}


- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    
    id representObject = [item representedObject];
    
    //root
    if(item.indexPath.length == 1){
        NSTableCellView *root= [outlineView makeViewWithIdentifier:@"root" owner:self];
        return root;

    }
    //folder
    else if([representObject isKindOfClass:[IUDocumentGroupNode class]]){
        IUDocumentGroupNode *groupNode = representObject;
        NSTableCellView *folder;
        if([groupNode.name isEqualToString:@"Pages"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"Masters"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"Resource"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"Image"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"CSS"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"JS"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else{
            JDErrorLog(@"there is no group");
        }
        return folder;

    }
    //folder
    else if([representObject isKindOfClass:[IUResourceGroupNode class]]){
        IUResourceGroupNode *groupNode = representObject;
        NSTableCellView *folder;
        if([groupNode.name isEqualToString:@"Resource"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"Image"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"CSS"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else if([groupNode.name isEqualToString:@"JS"]){
            folder= [outlineView makeViewWithIdentifier:@"pageFolder" owner:self];
        }
        else{
            JDErrorLog(@"there is no group");
        }
        return folder;
    }
    //file
    else{
        NSTableCellView *file;
        if ([[item representedObject] isKindOfClass:[IUDocumentNode class]]){
            file= [outlineView makeViewWithIdentifier:@"pageFile" owner:self];
        }
        else if( [[item representedObject] isKindOfClass:[IUResourceNode class]] ){

            file= [outlineView makeViewWithIdentifier:@"pageFile" owner:self];
        }
        
        return file;
    }
    
    
    return nil;
}

@end
