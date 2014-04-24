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
//    _project.delegate = self;
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
    
    //folder
    if(item.indexPath.length == 1 ||
       [representObject isKindOfClass:[IUDocumentGroupNode class]] ||
       [representObject isKindOfClass:[IUResourceGroupNode class]] ){
        
        NSTableCellView *folder = [outlineView makeViewWithIdentifier:@"folder" owner:self];
        return folder;

    }
    //file
    else{
        NSString *cellIdentifier;

        if ([[item representedObject] isKindOfClass:[IUDocumentNode class]]){
            IUDocumentNode *node = [item representedObject];
            if([node.parent.name isEqualToString:@"Pages"]){
                cellIdentifier = @"pageFile";
            }
            else if([node.parent.name isEqualToString:@"Backgrounds"]){
                cellIdentifier = @"backgroundFile";
            }
            else if ([node.parent.name isEqualToString:@"Classes"]){
                cellIdentifier = @"classFile";
            }
        }
        else if( [[item representedObject] isKindOfClass:[IUResourceNode class]] ){
            IUResourceGroupNode *node = [item representedObject];
            
            if([node.parent.name isEqualToString:@"Image"]){
                cellIdentifier = @"imageFile";
            }
            else if([node.parent.name isEqualToString:@"Video"]){
                cellIdentifier = @"videoFile";
            }
            else if([node.parent.name isEqualToString:@"CSS"]){
                cellIdentifier = @"cssFile";
            }
            else if([node.parent.name isEqualToString:@"JS"]){
                cellIdentifier = @"JSFile";
            }
        }
        assert(cellIdentifier != nil);
        
        NSTableCellView *file = [outlineView makeViewWithIdentifier:cellIdentifier owner:self];
        return file;
    }
    
    
    return nil;
}

@end
