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
    BOOL isNewProject;
}

- (void)awakeFromNib{
    
}


- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    isNewProject = YES;
    //NSURL *saveURL = [[JDFileUtil util] openSavePanelWithAllowFileTypes:@[typeName] withTitle:@"New IUProject"];
//    id document = [super makeDocumentWithContentsOfURL:saveURL ofType:typeName error:nil];
    id document = [super makeUntitledDocumentOfType:typeName error:outError];
    isNewProject = YES;
//    [document saveDocument:self];
    return document;
    
}

- (void)addDocument:(NSDocument *)document{
    if(isNewProject){
        [document saveDocument:self];
        isNewProject = NO;
    }
    [super addDocument:document];
}


@end
