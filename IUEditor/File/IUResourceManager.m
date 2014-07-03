//
//  IUResourceManager.m
//  IUEditor
//
//  Created by JD on 4/6/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceManager.h"

@interface IUResourceManager ()
@end

@implementation IUResourceManager{
    IUResourceGroup *_rootGroup;
}

- (void)setResourceGroup:(IUResourceGroup*)resourceRootGroup{
    _rootGroup = resourceRootGroup;
}



-(IUResourceFile*)resourceFileWithName:(NSString*)imageName{
    for ( IUResourceGroup *group in _rootGroup.childrenFiles) {
        for ( IUResourceFile *file in group.childrenFiles) {
            if ([file.name isEqualToString:imageName]) {
                return file;
            }
        }
    }
    return nil;
}

-(NSArray*)videoFiles{
    assert(_rootGroup.childrenFiles[1]);
    return [_rootGroup.childrenFiles[1] childrenFiles];
}

-(NSArray*)imageFiles{
    assert(_rootGroup.childrenFiles[0]);
    return [_rootGroup.childrenFiles[0] childrenFiles];
}

-(NSArray *)jsFiles{
    assert(_rootGroup.childrenFiles[2]);
    return [_rootGroup.childrenFiles[2] childrenFiles];
}
-(NSArray *)cssFiles{
    assert(_rootGroup.childrenFiles[3]);
    return [_rootGroup.childrenFiles[3] childrenFiles];
}

- (NSArray *)namesWithFiles:(NSArray *)files{
    NSMutableArray *names = [NSMutableArray array];
    for(IUResourceFile *file in files){
        NSString *name = file.name;
        [names addObject:name];
    }
    return names;
}

-(NSArray*)imageAndVideoFiles{
    return [[self imageFiles] arrayByAddingObjectsFromArray:self.videoFiles];
}

-(NSString*)imageDirectory{
    return [_rootGroup.childrenFiles[0] absolutePath];
}

- (IUResourceFile *)overwriteResourceWithContentOfPath:(NSString *)path{
    NSString *fileName = [path lastPathComponent];
    
    //double check duplicated name
    //if name is duplicated, alert and return
    
    IUResourceFile *existedFile = [self resourceFileWithName:fileName];
    if (existedFile == nil) {
        [JDLogUtil alert:@"this file is empty"];
        return nil;
    }
    
    //get uti at path
    //if it is image,
    //add to resource image group
    //send kvo message : imagefiles
    
    
    if ([JDFileUtil isImageFileExtension:[path pathExtension]]) {
        [self willChangeValueForKey:@"imageAndVideoFiles"];
        [self willChangeValueForKey:@"imageFiles"];
        existedFile.originalFilePath = path;
        [[[[NSApp mainWindow] windowController] document] saveDocument:self];
        
        [self didChangeValueForKey:@"imageFiles"];
        [self didChangeValueForKey:@"imageAndVideoFiles"];
        
        
        return existedFile;
    }
    
    //if is is video,
    //add to video greoup
    //send kvo message : videofiles
    
    else if ([JDFileUtil isMovieFileExtension:[path pathExtension]]) {
        [self willChangeValueForKey:@"imageAndVideoFiles"];
        [self willChangeValueForKey:@"movieFiles"];
        existedFile.originalFilePath = path;
        [self didChangeValueForKey:@"movieFiles"];
        [self didChangeValueForKey:@"imageAndVideoFiles"];
        
        [[[[NSApp mainWindow] windowController] document] saveDocument:self];
        
        return existedFile;
    }
    return nil;
  
}

- (void)removeResourceFile:(IUResourceFile*)file{
    if (file.type == IUResourceTypeImage ) {
        [self willChangeValueForKey:@"imageAndVideoFiles"];
        [self willChangeValueForKey:@"imageFiles"];
    }
    else if (file.type == IUResourceTypeVideo){
        [self willChangeValueForKey:@"imageAndVideoFiles"];
        [self willChangeValueForKey:@"videoFiles"];
    }
    
    [file.parent removeResourceFile:file];
    
    if (file.type == IUResourceTypeImage ) {
        [self didChangeValueForKey:@"imageAndVideoFiles"];
        [self didChangeValueForKey:@"imageFiles"];
    }
    else if (file.type == IUResourceTypeVideo){
        [self didChangeValueForKey:@"imageAndVideoFiles"];
        [self didChangeValueForKey:@"videoFiles"];
    }
}
- (IUResourceFile*)insertResourceWithContentOfPath:(NSString*)path{
    NSString *fileName = [path lastPathComponent];

    //check duplicated name
    //if name is duplicated, alert and return

    IUResourceFile *existedFile = [self resourceFileWithName:fileName];
    if (existedFile) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDLogUtil alert:[NSString stringWithFormat:@"'%@' file is already existed", fileName]];
        });
        return nil;
    }

    //get uti at path
    //if it is image,
    //add to resource image group
    //send kvo message : imagefiles
    

    if ([JDFileUtil isImageFileExtension:[path pathExtension]]) {
        [self willChangeValueForKey:@"imageAndVideoFiles"];
        [self willChangeValueForKey:@"imageFiles"];
        IUResourceGroup *group = _rootGroup.childrenFiles[0];
        IUResourceFile *file = [group addResourceFileWithContentOfPath:path];
        file.originalFilePath = path;
        [[[[NSApp mainWindow] windowController] document] saveDocument:self];

        [self didChangeValueForKey:@"imageFiles"];
        [self didChangeValueForKey:@"imageAndVideoFiles"];
        

        return file;
    }
    
    //if is is video,
    //add to video greoup
    //send kvo message : videofiles

    else if ([JDFileUtil isMovieFileExtension:[path pathExtension]]) {
        [self willChangeValueForKey:@"imageAndVideoFiles"];
        [self willChangeValueForKey:@"movieFiles"];
        IUResourceGroup *group = _rootGroup.childrenFiles[1];
        IUResourceFile *file = [group addResourceFileWithContentOfPath:path];
        file.originalFilePath = path;
        [self didChangeValueForKey:@"movieFiles"];
        [self didChangeValueForKey:@"imageAndVideoFiles"];
        
        [[[[NSApp mainWindow] windowController] document] saveDocument:self];
        
        return file;
    }
    return nil;
}

@end
