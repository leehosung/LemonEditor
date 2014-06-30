    //
//  IUProjectDocument.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 9..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUProjectDocument.h"
#import "IUProjectController.h"

static NSString *iuDataName = @"iuData";

//set metadata
static NSString *metaDataFileName = @"metaData.plist";
static NSString *MetaDataKey = @"value2";            // special string value in MetaData.plist


@interface IUProjectDocument ()

@property (strong) NSFileWrapper *documentFileWrapper;
@property NSMutableDictionary *metaDataDict;

@end

@implementation IUProjectDocument{
    BOOL isLoaded;
}

- (id)init{
    self = [super init];
    if(self){
    
        self.metaDataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             @"IUEditor", MetaDataKey,
                             nil];
    

    }
    return self;
}

//open document
- (id)initWithContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    return [super initWithContentsOfURL:url ofType:typeName error:outError];
}

//open autosaving document
- (id)initForURL:(NSURL *)urlOrNil withContentsOfURL:(NSURL *)contentsURL ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    return [super initForURL:urlOrNil withContentsOfURL:contentsURL ofType:typeName error:outError];
}

//make new document
- (id)initWithType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    self = [super initWithType:typeName error:outError];
    if(self){

    }
    return self;
}

- (BOOL)makeNewProjectWithOption:(NSDictionary *)option URL:(NSURL *)url{
    if ([option objectForKey:IUProjectKeyConversion]) {
        IUProjectType projectType = [[option objectForKey:IUProjectKeyType] intValue];
        Class projectFactory = NSClassFromString([IUProject stringProjectType:projectType]);
        
        NSError *error;
        IUProject *newProject = [(IUProject*)[projectFactory alloc] initWithProject:[option objectForKey:IUProjectKeyConversion] options:option error:&error];
        if (error != nil) {
            assert(0);
        }
        _project = newProject;
        return YES;
    }
    
    else {
        NSMutableDictionary *projectDict;
        IUProjectType projectType;
        if(option){
            projectDict = [option mutableCopy];
            projectType = [[option objectForKey:IUProjectKeyType] intValue];
            [projectDict removeObjectForKey:IUProjectKeyType];
        }
        else{
            projectType = IUProjectTypeDefault;
            projectDict = [NSMutableDictionary dictionary];
            [projectDict setObject:@(NO) forKey:IUProjectKeyGit];
            [projectDict setObject:@(NO) forKey:IUProjectKeyHeroku];
        }
        
        NSString *filePath = [url relativePath];
        NSString *appName = [[url lastPathComponent] stringByDeletingPathExtension];
        
        [projectDict setObject:filePath forKey:IUProjectKeyProjectPath];
        [projectDict setObject:appName forKey:IUProjectKeyAppName];
        
        NSError *error;
        
        IUProject *newProject = [[NSClassFromString([IUProject stringProjectType:projectType]) alloc] initWithCreation:projectDict error:&error];
        if (error != nil) {
            assert(0);
        }
        if(newProject){
            _project = newProject;
            return YES;
        }
        return NO;
    }
}

#pragma mark - menu

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem{
    
    if(menuItem.action == @selector(duplicateDocument:)){
        return NO;
    }
    
    return [super validateMenuItem:menuItem];
}

#pragma mark -

- (LMWC *)lemonWindowController{
    if([[self windowControllers] count] > 0){
        return [[self windowControllers] objectAtIndex:0];
    }
    return nil;
}

- (void)makeWindowControllers{
    LMWC *wc = [[LMWC alloc] initWithWindowNibName:@"LMWC"];
    [self addWindowController:wc];
    
}


- (void)showWindows{
    [super showWindows];
    [self showLemonSheet];
}

- (void)showLemonSheet{
    
    if(isLoaded && [self lemonWindowController]){
        [[self lemonWindowController] reloadCurrentDocument];
    }
    else if([self lemonWindowController]){
        [[self lemonWindowController] selectFirstDocument];
        isLoaded = YES;
    }
    
}

- (void)changeProjectPath:(NSURL *)fileURL{
    NSString *filePath = [fileURL relativePath];
    NSString *appName = [[fileURL lastPathComponent] stringByDeletingPathExtension];
    
    
    if(_project && [filePath isEqualToString:_project.path] == NO){
        
        _project.name = appName;
        _project.path = filePath;
        
        [self showLemonSheet];
        
    }

}

- (void)setFileURL:(NSURL *)fileURL{
    [self changeProjectPath:fileURL];
    [super setFileURL:fileURL];
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
    NSFileWrapper *resourceWrapper = [fileWrappers objectForKey:IUResourceGroupName];
    if (resourceWrapper== nil){
        resourceWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [resourceWrapper setPreferredFilename:IUResourceGroupName];
        [[self documentFileWrapper] addFileWrapper:resourceWrapper];

    }
    
    
    NSFileWrapper *cssWrapper = [[resourceWrapper fileWrappers] objectForKey:IUCSSResourceGroupName];
    NSFileWrapper *jsWrapper = [[resourceWrapper fileWrappers] objectForKey:IUJSResourceGroupName];
    NSFileWrapper *imageWrapper = [[resourceWrapper fileWrappers] objectForKey:IUImageResourceGroupName];
    NSFileWrapper *videoWrapper = [[resourceWrapper fileWrappers] objectForKey:IUVideoResourceGroupName];

    
    if(cssWrapper == nil){
        cssWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [cssWrapper setPreferredFilename:IUCSSResourceGroupName];
        [resourceWrapper addFileWrapper:cssWrapper];
    }
    if(jsWrapper == nil){
        jsWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [jsWrapper setPreferredFilename:IUJSResourceGroupName];
        [resourceWrapper addFileWrapper:jsWrapper];

    }
    if(imageWrapper == nil){
        imageWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [imageWrapper setPreferredFilename:IUImageResourceGroupName];
        [resourceWrapper addFileWrapper:imageWrapper];

    }
    if(videoWrapper == nil){
        videoWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        [videoWrapper setPreferredFilename:IUVideoResourceGroupName];
        [resourceWrapper addFileWrapper:videoWrapper];
    }
    
    //add css resource
    [self fileWrapper:cssWrapper removeFileNotInArray:[_project.resourceManager namesWithFiles:_project.resourceManager.cssFiles]];
    for(IUResourceFile *resourceFile in _project.resourceManager.cssFiles){
#if DEBUG
        [self fileWrapper:cssWrapper overwriteResourceNode:resourceFile];
#else
        [self fileWrapper:cssWrapper addResourceNode:resourceFile];
#endif
    }
    
    [self fileWrapper:jsWrapper removeFileNotInArray:[_project.resourceManager namesWithFiles:_project.resourceManager.jsFiles]];
    for(IUResourceFile *resourceFile in _project.resourceManager.jsFiles){
#if DEBUG
        [self fileWrapper:jsWrapper overwriteResourceNode:resourceFile];
#else
        [self fileWrapper:jsWrapper addResourceNode:resourceFile];
#endif
    }

    [self fileWrapper:imageWrapper removeFileNotInArray:[_project.resourceManager namesWithFiles:_project.resourceManager.imageFiles]];
    for(IUResourceFile *resourceFile in _project.resourceManager.imageFiles){
        [self fileWrapper:imageWrapper addResourceNode:resourceFile];
    }

    [self fileWrapper:videoWrapper removeFileNotInArray:[_project.resourceManager namesWithFiles:_project.resourceManager.videoFiles]];
    for(IUResourceFile *resourceFile in _project.resourceManager.videoFiles){
        [self fileWrapper:videoWrapper addResourceNode:resourceFile];
    }

    //save metadata
    // write the new file wrapper for our meta data
    NSFileWrapper *metaDataFileWrapper = [[[self documentFileWrapper] fileWrappers] objectForKey:metaDataFileName];
    if (metaDataFileWrapper != nil)
        [[self documentFileWrapper] removeFileWrapper:metaDataFileWrapper];

    NSError *plistError = nil;
    NSData *propertyListData = [NSPropertyListSerialization dataWithPropertyList:self.metaDataDict format:NSPropertyListXMLFormat_v1_0 options:0 error:&plistError];
    if (propertyListData == nil || plistError != nil)
    {
        NSLog(@"Could not create metadata plist data: %@", [plistError localizedDescription]);
        return nil;
    }
    
    NSFileWrapper *newMetaDataFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:propertyListData];
    [newMetaDataFileWrapper setPreferredFilename:metaDataFileName];
    
    [[self documentFileWrapper] addFileWrapper:newMetaDataFileWrapper];
    //save
    
    return [self documentFileWrapper];
    
}

- (int)fileWrapper:(NSFileWrapper *)fileWrapper removeFileNotInArray:(NSArray *)array{
    NSMutableArray *removeArray = [NSMutableArray array];
    for(NSString *resourceName in [fileWrapper fileWrappers]){
        if([array containsString:resourceName] == NO){
            [removeArray addObject:resourceName];
        }
    }
    int i=0;
    for(NSString *resourceName in removeArray){
        NSFileWrapper *resourceWrapper = [[fileWrapper fileWrappers] objectForKey:resourceName];
        [fileWrapper removeFileWrapper:resourceWrapper];
        i++;
    }
    return i;
}

#if DEBUG
- (NSString *)fileWrapper:(NSFileWrapper *)fileWrapper overwriteResourceNode:(IUResourceFile *)resource{
    NSFileWrapper *oldFileWrapper = [[fileWrapper fileWrappers] objectForKey:resource.name];
    if(oldFileWrapper){
        NSString *fileName = [[oldFileWrapper preferredFilename] stringByDeletingPathExtension];
        NSString *fileType = [[oldFileWrapper preferredFilename] pathExtension];
        NSString *path =  [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        resource.originalFilePath = path;

        [fileWrapper removeFileWrapper:oldFileWrapper];
    }
    return [self fileWrapper:fileWrapper addResourceNode:resource];

}
#endif

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
            [self changeProjectPath:[self fileURL]];
            readSuccess = YES;
        }

    }
    
    
    // load the metaData file from it's wrapper
    NSFileWrapper *metaDataFileWrapper = [fileWrappers objectForKey:metaDataFileName];
    if (metaDataFileWrapper != nil)
    {
        // we have meta data in this document
        //
        NSData *metaData = [metaDataFileWrapper regularFileContents];
        NSMutableDictionary *finalMetadata = [NSPropertyListSerialization propertyListWithData:metaData options:NSPropertyListImmutable format:NULL error:outError];
        self.metaDataDict = finalMetadata;
    }
    
    
    [self setDocumentFileWrapper:fileWrapper];

    return readSuccess;

}

+ (BOOL)autosavesInPlace
{
    return YES;
}


@end
