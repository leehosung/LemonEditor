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
//url을 넘기고 싶으면 IUProjectKeyProjectPath를 key로 option에 넣어야함.
- (void)newDocument:(id)sender withOption:(NSDictionary *)option;

@end
