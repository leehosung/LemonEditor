//
//  IUDjangoProject.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDjangoProject.h"
#import "IUPage.h"
#import "IUBackground.h"
#import "IUClass.h"
#import "IUDocumentNode.h"

@implementation IUDjangoProject

+(IUDjangoProject*)convertProject:(IUProject*)project setting:(NSDictionary*)setting error:(NSError**)error{
    IUDjangoProject *newProject = [[IUDjangoProject alloc] init];
    NSArray *properties = [IUProject properties];
    for (JDProperty *property in properties) {
        id v = [project valueForKey:property.name];
        [newProject setValue:v forKey:property.name];
    }
    
    if ([setting objectForKey:IUProjectKeyAppName]) {
        newProject.name = [setting objectForKey:IUProjectKeyAppName];
    }
    assert(project.name);
    project.buildDirectoryName = @"../templates";
        
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    assert(dir);
    project.path = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/iuSource", project.name]];
    [JDFileUtil rmDirPath:[project.path stringByAppendingPathExtension:@"*"]];
    ReturnNilIfFalse([JDFileUtil mkdirPath:project.path]);

    //copy resource file
    NSString *src = project.resourceNode.absolutePath;
    
    for (IUNode *node in project.children) {
        [newProject addNode:node];
    }
    
    NSString *desc = newProject.resourceNode.absolutePath;
    
    NSError *err;
    [[NSFileManager defaultManager] copyItemAtPath:src toPath:desc error:&err];
    
    //resource file copy
    [newProject save];
    
    return newProject;
}

// return value : project path
+(IUDjangoProject*)createProject:(NSDictionary*)setting error:(NSError**)error{    IUDjangoProject *project = [[IUDjangoProject alloc] init];
    project.name = [setting objectForKey:IUProjectKeyAppName];
    assert(project.name);
    project.buildDirectoryName = @"../templates";
    
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    assert(dir);
    project.path = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/iuSource", project.name]];
    [JDFileUtil rmDirPath:[project.path stringByAppendingPathExtension:@"*"]];
    ReturnNilIfFalse([JDFileUtil mkdirPath:project.path]);
    
    //create document dir
    IUDocumentGroupNode *pageDir = [[IUDocumentGroupNode alloc] init];
    pageDir.name = @"Pages";
    [project addNode:pageDir];
    project.pageDocumentGroup = pageDir;
    
    IUDocumentGroupNode *backgroundGroup = [[IUDocumentGroupNode alloc] init];
    backgroundGroup.name = @"Backgrounds";
    [project addNode:backgroundGroup];
    project.backgroundDocumentGroup = backgroundGroup;
    
    IUDocumentGroupNode *classGroup = [[IUDocumentGroupNode alloc] init];
    classGroup.name = @"Classes";
    [project addNode:classGroup];
    project.classDocumentGroup = backgroundGroup;
    
    //create document
    IUPage *index = [[IUPage alloc] initWithManager:nil option:nil];
    index.htmlID = @"Index";
    
    IUDocumentNode *indexNode = [[IUDocumentNode alloc] init];
    indexNode.document = index;
    indexNode.name = @"Index";
    [pageDir addNode:indexNode];

    //create document
    IUPage *gallery = [[IUPage alloc] initWithManager:nil option:nil];
    gallery.htmlID = @"Gallery";
    
    IUDocumentNode *galleryNode = [[IUDocumentNode alloc] init];
    galleryNode.document = gallery;
    galleryNode.name = @"Gallery";
    [pageDir addNode:galleryNode];
    
    //create document
    IUPage *registerPage = [[IUPage alloc] initWithManager:nil option:nil];
    registerPage.htmlID = @"Register";
    
    IUDocumentNode *registerNode = [[IUDocumentNode alloc] init];
    registerNode.document = registerPage;
    registerNode.name = @"Register";
    [pageDir addNode:registerNode];
    
    //create document
    IUPage *contactPage = [[IUPage alloc] initWithManager:nil option:nil];
    contactPage.htmlID = @"Contact";
    
    IUDocumentNode *contactNode = [[IUDocumentNode alloc] init];
    contactNode.document = contactPage;
    contactNode.name = @"Contact";
    [pageDir addNode:contactNode];
    


    IUBackground *background = [[IUBackground alloc] initWithManager:nil option:@{kIUBackgroundOptionEmpty:@(YES)}];
    background.htmlID = @"Background1";
    background.name = @"Background1";
    index.background = background;
    gallery.background = background;
    contactPage.background = background;
    registerPage.background = background;
    
    IUDocumentNode *backgroundNode = [[IUDocumentNode alloc] init];
    backgroundNode.document = background;
    backgroundNode.name = @"Background1";
    [backgroundGroup addNode:backgroundNode];
    
    IUClass *class = [[IUClass alloc] initWithManager:nil option:nil];
    class.htmlID = @"Picture";
    class.name = @"Picture";
    
    IUDocumentNode *classNode = [[IUDocumentNode alloc] init];
    classNode.document = class;
    classNode.name = @"Picture";
    [classGroup addNode:classNode];
    
    IUClass *class2 = [[IUClass alloc] initWithManager:nil option:nil];
    class2.htmlID = @"Class2";
    class2.name = @"Class2";
    
    IUDocumentNode *classNode2 = [[IUDocumentNode alloc] init];
    classNode2.document = class2;
    classNode2.name = @"Class2";
    [classGroup addNode:classNode2];
    
    
    [project initializeResource];
    ReturnNilIfFalse([project save]);
    return project;
}
@end
