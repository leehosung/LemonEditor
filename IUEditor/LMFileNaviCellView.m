//
//  LMFileNaviCellView.m
//  IUEditor
//
//  Created by jd on 5/27/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMFileNaviCellView.h"
#import "IUSheet.h"

@implementation LMFileNaviCellView

- (void)startEditing{
    //set focus
    [self.textField setEditable:YES];
    [self.textField becomeFirstResponder];

}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    NSString *textValue = fieldEditor.string;
    assert(_project.identifierManager);
    IUBox *box = [_project.identifierManager IUWithIdentifier:textValue];
    if (box != nil) {
        [JDUIUtil hudAlert:@"IU with same name exists" second:1];
        return NO;
    }
    if (textValue.length == 0) {
        return NO;
    }

    IUSheet *doc = self.objectValue;
    doc.name = textValue;
    doc.htmlID = textValue;

    return YES;
}

@end
