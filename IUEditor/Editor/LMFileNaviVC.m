//
//  LMFileNaviVC.m
//  IUEditor
//
//  Created by JD on 3/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviVC.h"

@interface LMFileNaviVC ()
@property (strong, nonatomic) IBOutlet NSTreeController *treeController;

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
    NSLog(@"selection");
}


-(void)setTreeController:(NSTreeController *)treeController{
    _treeController = treeController;
    [treeController addObserver:self forKeyPath:@"selection" options:0 context:nil];
}


-(void)selectionDidChange:(NSDictionary*)dict{
    [self willChangeValueForKey:@"selection"];
    _selection = [_treeController.selectedObjects firstObject];
    [self didChangeValueForKey:@"selection"];
}


-(void)setProject:(IUProject *)project{
    _project = project;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    // Everything is setup in bindings
    NSTableCellView *cell= [outlineView makeViewWithIdentifier:@"cell" owner:self];
    return cell;
}


@end
