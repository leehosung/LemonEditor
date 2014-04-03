//
//  LMStackVC.m
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStackVC.h"
#import "IUController.h"

@interface LMStackVC ()

@property (weak) IBOutlet NSOutlineView *outlineV;
//@property (strong) IBOutlet IUController *controller;

@end

@implementation LMStackVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)awakeFromNib{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_IUController addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
    });
}


- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    NSTableCellView *cell= [outlineView makeViewWithIdentifier:@"cell" owner:self];
    return cell;
}

-(void)setDocument:(IUDocument *)document{
    _document = document;
    for (IUObj *iu in document.allChildren) {
        NSAssert(iu.name.length, @"%@ name is unset", [iu description]);
    }
}


@end