//
//  IUProjectController.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 10..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUProjectController.h"
#import "IUProjectDocument.h"

@implementation IUProjectController{
}

- (void)awakeFromNib{
    
}


- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    id document = [super makeUntitledDocumentOfType:typeName error:outError];
    
    NSURL *url = [[JDFileUtil util] openSavePanelWithAllowFileTypes:@[typeName] withTitle:@"IU New Project"];
    [document saveToURL:url ofType:typeName forSaveOperation:NSSaveOperation delegate:nil didSaveSelector:nil contextInfo:nil];
    return document;
    
}



@end
