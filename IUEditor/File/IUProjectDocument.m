    //
//  IUProjectDocument.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 9..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUProjectDocument.h"
#import "IUProjectController.h"
#import "LMWC.h"

static NSString *iuDataName = @"iuData";
static NSString *resourcesName = @"Resource";
static NSString *jsResourceName = @"JS";
static NSString *imageResourceName = @"Image";
static NSString *videoResourceName = @"Video";
static NSString *cssResourceName = @"CSS";


@interface IUProjectDocument ()

@property (strong) NSFileWrapper *documentFileWrapper;

@end

@implementation IUProjectDocument{
    BOOL isLoaded;
}

- (id)initWithType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    self = [super initWithType:typeName error:outError];
    if(self){
            NSString *path = [@"~/Library/Autosave Information/IUProjTemp" stringByExpandingTildeInPath];
            NSDictionary *dict = @{IUProjectKeyAppName: @"IUEditor1",
                                   IUProjectKeyGit: @(NO),
                                   IUProjectKeyHeroku: @(NO),
                                   IUProjectKeyDirectory: path};
            
            NSError *error;
            IUProject *newProject = [[IUProject alloc] initWithCreation:dict error:&error];
            if (error != nil) {
                assert(0);
            }
            _project = newProject;
            //        [super saveDocument:sender];
        }
    return self;
}


- (id)initWithContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    self = [super initWithContentsOfURL:url ofType:typeName error:outError];
    if(self){
        isLoaded = YES;
    }
    return self;
}

- (LMWC *)lemonWindowController{
    return [[self windowControllers] objectAtIndex:0];
}

- (void)makeWindowControllers{
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [self addWindowController:wc];
    
    
}


- (void)showWindows{
    [super showWindows];
    //[[self lemonWindowController] selectFirstDocument];
   
}


- (void)setFileURL:(NSURL *)fileURL{
    [super setFileURL:fileURL];
    NSString *filePath = [fileURL relativePath];
    NSString *appName = [[fileURL lastPathComponent] stringByDeletingPathExtension];
    
    
    if(_project && [filePath isEqualToString:_project.path] == NO){
        
        _project.name = appName;
        _project.path = filePath;


//        [[self lemonWindowController].window setTitle:[NSString stringWithFormat:@"[%@] %@", [_project.className substringFromIndex:2], _project.path]];
    }
    
}



- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError
{
    // If the document was not read from file or has not previously been saved,
    // it doesn't have a file wrapper, so create one.
    //
    if ([self documentFileWrapper] == nil)
    {
        NSFileWrapper *docfileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [self setDocumentFileWrapper:docfileWrapper];
    }
    
    NSDictionary *fileWrappers = [[self documentFileWrapper] fileWrappers];
    //save iudata
    if( [fileWrappers objectForKey:iuDataName] != nil ){
        NSFileWrapper *iuDataWrapper = [fileWrappers objectForKey:iuDataName];
        [[self documentFileWrapper] removeFileWrapper:iuDataWrapper];
    }
    
    if(_project){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_project];
        NSFileWrapper *iuDataWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
        [iuDataWrapper setPreferredFilename:iuDataName];
        [[self documentFileWrapper] addFileWrapper:iuDataWrapper];
    }

    //save resource files
    NSFileWrapper *resourceWrapper = [fileWrappers objectForKey:resourcesName];
    if (resourceWrapper== nil){
        resourceWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [resourceWrapper setPreferredFilename:resourcesName];
        [[self documentFileWrapper] addFileWrapper:resourceWrapper];

    }
    
    
    NSFileWrapper *cssWrapper = [[resourceWrapper fileWrappers] objectForKey:cssResourceName];
    NSFileWrapper *jsWrapper = [[resourceWrapper fileWrappers] objectForKey:jsResourceName];
    NSFileWrapper *imageWrapper = [[resourceWrapper fileWrappers] objectForKey:imageResourceName];
    NSFileWrapper *videoWrapper = [[resourceWrapper fileWrappers] objectForKey:videoResourceName];

    
    if(cssWrapper == nil){
        cssWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [cssWrapper setPreferredFilename:cssResourceName];
        [resourceWrapper addFileWrapper:cssWrapper];
    }
    if(jsWrapper == nil){
        jsWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [jsWrapper setPreferredFilename:jsResourceName];
        [resourceWrapper addFileWrapper:jsWrapper];

    }
    if(imageWrapper == nil){
        imageWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [imageWrapper setPreferredFilename:imageResourceName];
        [resourceWrapper addFileWrapper:imageWrapper];

    }
    if(videoWrapper == nil){
        videoWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [videoWrapper setPreferredFilename:videoResourceName];
        [resourceWrapper addFileWrapper:videoWrapper];
    }
    
    //add css resource
    [self fileWrapper:cssWrapper removeFileNotInArray:_project.resourceManager.cssFiles];
    for(IUResourceFile *resourceFile in _project.resourceManager.cssFiles){
        [self fileWrapper:cssWrapper addResourceNode:resourceFile];
    }
    
    [self fileWrapper:jsWrapper removeFileNotInArray:_project.resourceManager.jsFiles];
    for(IUResourceFile *resourceFile in _project.resourceManager.jsFiles){
        [self fileWrapper:jsWrapper addResourceNode:resourceFile];
    }

    [self fileWrapper:imageWrapper removeFileNotInArray:_project.resourceManager.imageFiles];
    for(IUResourceFile *resourceFile in _project.resourceManager.imageFiles){
        [self fileWrapper:imageWrapper addResourceNode:resourceFile];
    }

    [self fileWrapper:videoWrapper removeFileNotInArray:_project.resourceManager.videoFiles];
    for(IUResourceFile *resourceFile in _project.resourceManager.videoFiles){
        [self fileWrapper:videoWrapper addResourceNode:resourceFile];
    }

    
    
    
    //save
    
    return [self documentFileWrapper];
    
}

- (int)fileWrapper:(NSFileWrapper *)fileWrapper removeFileNotInArray:(NSArray *)array{
    NSMutableArray *removeArray = [NSMutableArray array];
    for(NSFileWrapper *resourceWrapper in [fileWrapper fileWrappers]){
        if([array containsObject:[resourceWrapper preferredFilename]] == NO){
            [removeArray addObject:resourceWrapper];
        }
    }
    int i=0;
    for(NSFileWrapper *resourceWrapper in removeArray){
        [fileWrapper removeFileWrapper:resourceWrapper];
        i++;
    }
    return i;
}


- (NSString *)fileWrapper:(NSFileWrapper *)fileWrapper addResourceNode:(IUResourceFile *)resource{
    if([[fileWrapper fileWrappers] objectForKey:resource.name] == nil){
        NSFileWrapper *resourceWrapper = [[NSFileWrapper alloc] initWithURL:[NSURL fileURLWithPath:resource.originalFilePath] options:0 error:nil];
        [resourceWrapper setPreferredFilename:resource.name];
        return [fileWrapper addFileWrapper:resourceWrapper];
    }
    return resource.name;
}


- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError
{

    BOOL readSuccess= NO;
    NSDictionary *fileWrappers = [fileWrapper fileWrappers];

    NSFileWrapper *iuDataWrapper = [fileWrappers objectForKey:iuDataName];

    if(iuDataWrapper){
        NSData *iuData = [iuDataWrapper regularFileContents];
        _project = [NSKeyedUnarchiver unarchiveObjectWithData:iuData];
        
        if(_project){
            _project.path = [[self fileURL] path];
            readSuccess = YES;
        }

    }
    
    [self setDocumentFileWrapper:fileWrapper];

    return readSuccess;

}


- (void)saveDocument:(id)sender{
    [super saveDocument:sender];

    if([sender isKindOfClass:[IUProjectController class]]){
        isLoaded = YES;

    }
}

+ (BOOL)autosavesInPlace
{
    return YES;
}


@end
