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
    for ( IUResourceGroup *group in _rootGroup.children) {
        for ( IUResourceFile *file in group.children) {
            if ([file.name isEqualToString:imageName]) {
                return file;
            }
        }
    }
    return nil;
}

-(NSArray*)videoFiles{
    assert(_rootGroup.children[1]);
    return [_rootGroup.children[1] children];
}

-(NSArray*)imageFiles{
    assert(_rootGroup.children[0]);
    return [_rootGroup.children[0] children];
}

-(NSArray*)imageAndVideoFiles{
    return [[self imageFiles] arrayByAddingObjectsFromArray:self.videoFiles];
}


- (IUResourceFile*)insertResourceWithContentOfPath:(NSString*)path{
    NSString *fileName = [path lastPathComponent];

    //check duplicated name
    //if name is duplicated, alert and return

    IUResourceFile *existedFile = [self resourceFileWithName:fileName];
    if (existedFile) {
        [JDLogUtil alert:@"Existed file"];
        return nil;
    }

    //get uti at path
    //if it is image,
    //add to resource image group
    //send kvo message : imagefiles
    

    if ([JDFileUtil isImageFileExtension:[path pathExtension]]) {
        IUResourceGroup *imageGroup = _rootGroup.children[0];
        return [imageGroup addResourceFileWithContentOfPath:path];
        [[NSNotificationCenter defaultCenter] postNotificationName:IUImageResourceDidChange object:self];
    }
    
    //if is is video,
    //add to video greoup
    //send kvo message : videofiles

    else if ([JDFileUtil isMovieFileExtension:[path pathExtension]]) {
        IUResourceGroup *movieGroup = _rootGroup.children[1];
        return [movieGroup addResourceFileWithContentOfPath:path];
        [[NSNotificationCenter defaultCenter] postNotificationName:IUVideoResourceDidChange object:self];
    }
    return nil;
}

@end
