//
//  IUSheetController.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUProject.h"
#import "IUSheet.h"

@interface IUSheetController : NSTreeController

-(id)initWithDocument:(IUSheet*)document;
-(NSString*)keyPathFromDocumentControllerToEventVariables;

@property (nonatomic, readonly) IUSheet *sheet;
@property (nonatomic) IUProject *project;


@end