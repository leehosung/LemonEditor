//
//  LMFileNaviCellView.m
//  IUEditor
//
//  Created by jd on 5/27/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviCellView.h"

@implementation LMFileNaviCellView

- (void)startEditing{
    //set focus
    [self.textField setEditable:YES];
    [self.textField becomeFirstResponder];

}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    NSString *textValue = fieldEditor.string;
    if (textValue.length == 0) {
        return NO;
    }
    IUNode *node = [_project nodeWithName:textValue];
    if (node) {
        [JDLogUtil alert:@"Duplicated Name"];
        return NO;
    }
    return YES;
}

@end
