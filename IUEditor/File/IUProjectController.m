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
    NSDictionary *newDocumentOption;
}


- (void)newDocument:(id)sender{
    isSaved = NO;
    [super newDocument:sender];
}

- (void)newDocument:(id)sender withOption:(NSDictionary *)option{
    newDocumentOption = option;
    [self newDocument:sender];
}

- (void)openDocument:(id)sender{
    [super openDocument:sender];
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
            [(IUProjectDocument *)document makeNewProjectWithOption:newDocumentOption URL:url];
            newDocumentOption = nil;
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

- (void)openDocumentWithContentsOfURL:(NSURL *)url display:(BOOL)displayDocument completionHandler:(void (^)(NSDocument *, BOOL, NSError *))completionHandler{
    [super openDocumentWithContentsOfURL:url display:displayDocument completionHandler:completionHandler];
}

//TODO : open last Document

- (void)reopenDocumentForURL:(NSURL *)urlOrNil withContentsOfURL:(NSURL *)contentsURL display:(BOOL)displayDocument completionHandler:(void (^)(NSDocument *, BOOL, NSError *))completionHandler{
    [super reopenDocumentForURL:urlOrNil withContentsOfURL:contentsURL display:displayDocument completionHandler:completionHandler];
}

- (id)makeDocumentForURL:(NSURL *)urlOrNil withContentsOfURL:(NSURL *)contentsURL ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    return [super makeDocumentForURL:urlOrNil withContentsOfURL:contentsURL ofType:typeName error:outError];
}


@end
