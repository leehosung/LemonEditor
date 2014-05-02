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
+(NSString*)createProject:(NSDictionary*)setting error:(NSError**)error{
    IUDjangoProject *project = [[IUDjangoProject alloc] init];
    project.name = [setting objectForKey:IUProjectKeyAppName];
    project.buildDirectoryName = @"../templates";
    
    NSString *dir = [setting objectForKey:IUProjectKeyDirectory];
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
    IUPage *page = [[IUPage alloc] initWithManager:nil option:nil];
    page.htmlID = @"Page1Index";
    
    IUDocumentNode *pageNode = [[IUDocumentNode alloc] init];
    pageNode.document = page;
    pageNode.name = @"Index";
    [pageDir addNode:pageNode];
    
    IUBackground *background = [[IUBackground alloc] initWithManager:nil option:nil];
    background.htmlID = @"Background1";
    background.name = @"Background1";
    
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
    return project.path;
}
@end
