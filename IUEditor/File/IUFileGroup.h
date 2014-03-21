//
//  IUDirectoryNode.h
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IUFileGroup : NSTreeNode  <NSCoding>{
    NSString *_name;
}
-(id)initWithName:(NSString*)name;

-(NSString*)name;


@end
