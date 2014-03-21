//
//  NSTextField+DragAndDrop.m
//  Mango
//
//  Created by JD on 13. 9. 18..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "NSTextField+DragAndDrop.h"

@implementation NSTextField_DragAndDrop

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

-(void)awakeFromNib{
    [self bind:@"objectValue" toObject:self withKeyPath:@"dValue" options:0];
    [self registerForDraggedTypes:@[(id)kUTTypePlainText, (id)kUTTypeText]];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationEvery;
}


- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    NSPasteboard *pBoard = sender.draggingPasteboard;
    NSString *str =  [pBoard stringForType:(id)kUTTypePlainText];
    if (str == nil) {
        str = [pBoard stringForType:(id)kUTTypeText];
    }
    if (str!=nil) {
        self.dValue = str;
    }
    return YES;
}


@end
