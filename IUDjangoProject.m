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
#import "IUSheetGroup.h"

@implementation IUDjangoProject

- (id)init{
    self = [super init];
    return self;
}

+(IUDjangoProject*)createProject:(NSDictionary*)setting error:(NSError**)error{
    return nil;
}
+(IUDjangoProject*)convertProject:(IUProject*)project setting:(NSDictionary*)setting error:(NSError**)error{
    return nil;
}

- (BOOL)runnable{
    return YES;
}


#if 0
+(IUDjangoProject*)convertProject:(IUProject*)project setting:(NSDictionary*)setting error:(NSError**)error{
    IUDjangoProject *newProject = [[IUDjangoProject alloc] init];
    NSArray *properties = [IUProject propertiesWithOutProperties:@[@"delegate", @"buildDirectoryName", @"runnable"]];
    for (JDProperty *property in properties) {
        id v = [project valueForKey:property.name];
        [newProject setValue:v forKey:property.name];
    }
    
    if ([setting objectForKey:IUProjectKeyAppName]) {
        newProject.name = [setting objectForKey:IUProjectKeyAppName];
    }
    else {
        newProject.name = project.name;
    }
    assert(newProject.name);
    newProject.buildPath = @"../templates";
        
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    assert(dir);
    NSString *newPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"iuSource/%@.iu", newProject.name]];
    [newProject setPath:newPath];
    
    [JDFileUtil rmDirPath:[newProject.directory stringByAppendingPathExtension:@"*"]];
    ReturnNilIfFalse([JDFileUtil mkdirPath:newProject.directory]);

    //FIXME:
    /*
    //copy resource file
    NSString *src = project.resourceNode.absolutePath;
    
    for (IUNode *node in project.children) {
        [newProject addNode:node];
    }
    
    NSString *desc = newProject.resourceNode.absolutePath;
    */
    NSString *src;
    NSString *desc;
    NSError *err;
    [[NSFileManager defaultManager] removeItemAtPath:desc error:nil];
    [[NSFileManager defaultManager] copyItemAtPath:src toPath:desc error:&err];
    assert(err == nil);
    
    //resource file copy
    BOOL result = [newProject save];
    assert(result == YES);
    return newProject;
}

// return value : project path
+(IUDjangoProject*)createProject:(NSDictionary*)setting error:(NSError**)error{
    IUDjangoProject *project = [[IUDjangoProject alloc] init];
    project.name = [setting objectForKey:IUProjectKeyAppName];
    assert(project.name);
    project.buildPath = @"../templates";
    
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
    assert(dir);
    NSString *projectDir = [dir stringByAppendingPathComponent:@"iuProject"];
    NSString *pathAppend = [NSString stringWithFormat:@"iuProject/%@.iu", project.name];
    [project setPath: [dir stringByAppendingPathComponent:pathAppend]];
    [JDFileUtil rmDirPath:projectDir];
    ReturnNilIfFalse([JDFileUtil mkdirPath:project.directory]);
    
    //create document dir
    IUDocumentGroupNode *pageDir = [[IUDocumentGroupNode alloc] init];
    pageDir.name = @"Pages";
    [project addNode:pageDir];
    
    IUDocumentGroupNode *backgroundGroup = [[IUDocumentGroupNode alloc] init];
    backgroundGroup.name = @"Backgrounds";
    [project addNode:backgroundGroup];
    
    IUDocumentGroupNode *classGroup = [[IUDocumentGroupNode alloc] init];
    classGroup.name = @"Classes";
    [project addNode:classGroup];
    
    //create document
    IUPage *index = [[IUPage alloc] initWithIdentifierManager:nil option:nil];
    index.htmlID = @"Index";
    
    IUDocumentGroup *indexNode = [[IUDocumentGroup alloc] init];
    indexNode.document = index;
    indexNode.name = @"Index";
    [pageDir addNode:indexNode];

    //create document
    IUPage *gallery = [[IUPage alloc] initWithIdentifierManager:nil option:nil];
    gallery.htmlID = @"Gallery";
    
    IUDocumentGroup *galleryNode = [[IUDocumentGroup alloc] init];
    galleryNode.document = gallery;
    galleryNode.name = @"Gallery";
    [pageDir addNode:galleryNode];
    
    //create document
    IUPage *registerPage = [[IUPage alloc] initWithIdentifierManager:nil option:nil];
    registerPage.htmlID = @"Register";
    
    IUDocumentGroup *registerNode = [[IUDocumentGroup alloc] init];
    registerNode.document = registerPage;
    registerNode.name = @"Register";
    [pageDir addNode:registerNode];
    
    //create document
    IUPage *contactPage = [[IUPage alloc] initWithIdentifierManager:nil option:nil];
    contactPage.htmlID = @"Contact";
    
    IUDocumentGroup *contactNode = [[IUDocumentGroup alloc] init];
    contactNode.document = contactPage;
    contactNode.name = @"Contact";
    [pageDir addNode:contactNode];
    


    IUBackground *background = [[IUBackground alloc] initWithIdentifierManager:nil option:@{kIUBackgroundOptionEmpty:@(YES)}];
    background.htmlID = @"Background1";
    background.name = @"Background1";
    index.background = background;
    gallery.background = background;
    contactPage.background = background;
    registerPage.background = background;
    
    IUDocumentGroup *backgroundNode = [[IUDocumentGroup alloc] init];
    backgroundNode.document = background;
    backgroundNode.name = @"Background1";
    [backgroundGroup addNode:backgroundNode];
    
    IUClass *class = [[IUClass alloc] initWithIdentifierManager:nil option:nil];
    class.htmlID = @"Picture";
    class.name = @"Picture";
    
    IUDocumentGroup *classNode = [[IUDocumentGroup alloc] init];
    classNode.document = class;
    classNode.name = @"Picture";
    [classGroup addNode:classNode];
    
    IUClass *class2 = [[IUClass alloc] initWithIdentifierManager:nil option:nil];
    class2.htmlID = @"Class2";
    class2.name = @"Class2";
    
    IUDocumentGroup *classNode2 = [[IUDocumentGroup alloc] init];
    classNode2.document = class2;
    classNode2.name = @"Class2";
    [classGroup addNode:classNode2];
    
    
    [project initializeResource];
    ReturnNilIfFalse([project save]);
    return project;
}
#endif
@end
