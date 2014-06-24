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
    NSDictionary *newDocumentOption;
}


- (void)newDocument:(id)sender{
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

    return document;
}

- (void)newDocument:(NSDocument *)document didSave:(BOOL)didSaveSuccessfully  contextInfo:(void  *)contextInfo{
    if(contextInfo){
        BOOL isSaved = [(__bridge id)contextInfo boolValue];
        if(isSaved){
            [document makeWindowControllers];
            [document showWindows];
            return;
        }
    }
    //new project를 만들다가 실패했을 경우에는 document controller에서 지움.
    [self removeDocument:document];
    
}

- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    id document = [super makeUntitledDocumentOfType:typeName error:outError];
    
    if(document){
        //option으로 url이 넘어옴.
        NSURL *url;
        if ([newDocumentOption objectForKey:IUProjectKeyProjectPath]) {
            url = [NSURL fileURLWithPath:[newDocumentOption objectForKey:IUProjectKeyProjectPath]];
        }
        else {
            url = [self fileURLForNewDocumentOfType:typeName];
        }
        
        if( url ){
            [(IUProjectDocument *)document makeNewProjectWithOption:newDocumentOption URL:url];
            newDocumentOption = nil;
            [document saveToURL:url ofType:typeName forSaveOperation:NSSaveOperation delegate:self didSaveSelector:@selector(newDocument:didSave:contextInfo:) contextInfo:(__bridge void *)([NSNumber numberWithBool:YES])];
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


- (void)reopenDocumentForURL:(NSURL *)urlOrNil withContentsOfURL:(NSURL *)contentsURL display:(BOOL)displayDocument completionHandler:(void (^)(NSDocument *, BOOL, NSError *))completionHandler{
    [super reopenDocumentForURL:urlOrNil withContentsOfURL:contentsURL display:YES completionHandler:completionHandler];
}


@end
