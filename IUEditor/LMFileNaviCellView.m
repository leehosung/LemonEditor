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
    assert(_project.identifierManager);
    
    NSString *textValue = fieldEditor.string;
    
    NSCharacterSet *characterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    if([textValue rangeOfCharacterFromSet:characterSet].location != NSNotFound){
        [JDUIUtil hudAlert:@"Name should be alphabet or digit" second:1];
        return NO;
    }
    
    IUBox *box = [_project.identifierManager IUWithIdentifier:textValue];
    if (box != nil) {
        [JDUIUtil hudAlert:@"IU with same name exists" second:1];
        return NO;
    }
    if (textValue.length == 0) {
        return NO;
    }
    
    IUSheet *doc = self.objectValue;
    if([textValue isEqualToString:@"doc.name"] == NO){
        [_project.identifierManager unregisterIUs:@[doc]];
        [_project.identifierManager registerIUs:@[doc]];
        doc.htmlID = textValue;
        doc.name = textValue;
    }
    
    return YES;
}

@end
