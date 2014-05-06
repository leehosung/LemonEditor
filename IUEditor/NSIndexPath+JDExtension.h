//
//  NSIndexPath+JDExtension.h
//  IUEditor
//
//  Created by jd on 5/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (JDExtension)

+ (id)indexPathWithIndexPath:(NSIndexPath*)indexPath length:(NSUInteger)length;
- (BOOL)containsIndexPath:(NSIndexPath*)aIndexPath;

@end
