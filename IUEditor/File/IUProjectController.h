//
//  IUProjectController.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 10..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IUProjectController : NSDocumentController

//option - project type & project option
- (void)newDocument:(id)sender withOption:(NSDictionary *)option;

@end
