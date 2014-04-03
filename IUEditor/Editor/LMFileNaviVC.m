//
//  LMFileNaviVC.m
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviVC.h"
#import "IUDocumentNode.h"
#import "NSTreeController+JDExtension.h"

@interface LMFileNaviVC ()
@property (strong, nonatomic) IBOutlet NSTreeController *documentController;

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
    [_documentController setSelectionObject:documentNode];
}


- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    // Everything is setup in bindings
    NSTableCellView *cell= [outlineView makeViewWithIdentifier:@"cell" owner:self];
    return cell;
}


@end
