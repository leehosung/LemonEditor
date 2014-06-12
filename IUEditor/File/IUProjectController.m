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
    BOOL isSaved;
}

- (void)awakeFromNib{
    
}

- (void)newDocument:(id)sender{
    isSaved = NO;
    [super newDocument:sender];
}
- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError *__autoreleasing *)outError{
    id document = [self makeUntitledDocumentOfType:[self defaultType] error:outError];
    [self addDocument:document];

    if(isSaved){
        [document makeWindowControllers];
        [document showWindows];
    }
    return document;
}

- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    id document = [super makeUntitledDocumentOfType:typeName error:outError];
    
    if(document){
        NSURL *url = [self fileURLForNewDocumentOfType:typeName];
        if(url != nil){
            [document saveToURL:url ofType:typeName forSaveOperation:NSSaveOperation delegate:nil didSaveSelector:nil contextInfo:nil];
            isSaved = YES;
        }
    }
    
    return document;
    
}

- (NSURL *)fileURLForNewDocumentOfType:(NSString *)typeName{
    int i=0;
    while(1){
        NSURL *url = [[JDFileUtil util] openSavePanelWithAllowFileTypes:@[typeName] withTitle:@"IU New Project"];
        id openedDocument = [self documentForURL:url];
        if(openedDocument){
            [JDLogUtil alert:@"Same File Name is Opened" title:@"Warning"];
        }
        else{
            return url;
        }
        //safe escape code
        if(i > 10000){
            return nil;
        }
    }
    return nil;
    
}


@end
