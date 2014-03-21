//
//  IUFrameSizeTableView.m
//  WebGenerator
//
//  Created by JD on 12/24/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import "JDKeyDelegatedTableView.h"

@implementation JDKeyDelegatedTableView

- (void)keyDown:(NSEvent *)event
{
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    if ([self.keyDelegate tableView:self keyDown:key]) {
        return;
    }
    [super keyDown:event];
}

- (BOOL)textShouldEndEditing:(NSText *)textObject{
    [self.keyDelegate tableView:self endEditing:textObject row:self.editedRow column:self.editedColumn];
    return YES;
}

@end
