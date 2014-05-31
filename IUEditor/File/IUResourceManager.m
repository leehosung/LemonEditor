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
    return [_rootGroup.children[1] children];
}

-(NSArray*)imageFiles{
    return [_rootGroup.children[0] children];
}

-(NSArray*)imageAndVideoFiles{
    return [[self imageFiles] arrayByAddingObjectsFromArray:self.videoFiles];
}


- (IUResourceFile*)insertResourceWithContentOfPath:(NSString*)path{
    assert(0);
    //check duplicated name
    //if name is duplicated, alert and return
    
    //get uti at path
    //if it is image,
    //add to resource image group
    //send kvo message : imagefiles and imageandvideofiles
    
    //if is is video,
    //add to video greoup
    //send kvo message : videofiles and imageandvideofiles
}

@end
