//
//  JDOutlineView.m
//  Mango
//
//  Created by JD on 13. 2. 5..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDOutlineView.h"

@implementation JDOutlineView


- (void)selectItem:(id)item {
    NSInteger itemIndex = [self rowForItem:item];
    if (itemIndex < 0) {
        [self expandParentsOfItem: item];
        itemIndex = [self rowForItem:item];
        if (itemIndex < 0)
            return;
    }
    
    [self selectRowIndexes: [NSIndexSet indexSetWithIndex: itemIndex] byExtendingSelection: NO];
}


- (void)expandParentsOfItem:(id)_item {
    id item = _item;
    NSInteger itemIndex;

    while (1) {
        while (item != nil) {
            id parent = [self parentForItem:_item];
            if (![self isExpandable: parent])
                break;
            if (![self isItemExpanded: parent])
                [self expandItem: parent];
            item = parent;
        }
        itemIndex = [self rowForItem:_item];
        if (itemIndex < 0) {
            item = _item;
            if (item == nil) {
                return;
            }
        }
        else{
            break;
        }
    }
}


-(NSMenu*)menuForEvent:(NSEvent*)evt
{
    NSPoint pt = [self convertPoint:[evt locationInWindow] fromView:nil];
    NSInteger row=[self rowAtPoint:pt];
    self.rightClickedIndex = row;

    if ([self.JDDataSource respondsToSelector:@selector(defaultMenuForRow:)]) {
        return [self.JDDataSource defaultMenuForRow:row];
    }
    else{
        return [super menuForEvent:evt];
    }
}



- (void)keyDown:(NSEvent *)event
{
    if (self.keyDelegate) {
        if ([self.keyDelegate keyDown:event]) {
            return;
        }
    }

    [super keyDown:event];
    
}

- (id)selectedView{
    NSInteger col = [self selectedColumn];
    NSInteger row = [self selectedRow];
    return [self viewAtColumn:col row:row makeIfNecessary:YES];

}

#pragma mark -
#pragma mark mouseEvent
- (void)mouseDown:(NSEvent *)theEvent
{
    if([[self delegate] respondsToSelector:@selector(mouseDown:)]){
        [[self delegate] performSelector:@selector(mouseDown:) withObject:theEvent];
    }
    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent{
    if([[self delegate] respondsToSelector:@selector(mouseUp:)]){
        [[self delegate] performSelector:@selector(mouseUp:) withObject:theEvent];
    }
    [super mouseUp:theEvent];
}

@end
