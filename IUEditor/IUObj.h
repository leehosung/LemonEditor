//
//  IUObj.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCSS.h"
#import "IUProject.h"


#define IUCSSDefaultFrame -1


@interface IUObj : NSObject <NSCoding>

+(id)IU;
@property (readonly) IUCSS *css; //used by subclass


@property (readonly) NSArray *children;
-(NSMutableArray*)allChildren;

//initialize
-(id)initWithProject:(IUProject*)project setting:(NSDictionary*)setting;
@property IUProject *project;

// this is IU setting
@property (nonatomic) NSString *htmlID;
@property (nonatomic) NSString *name;

// followings are IU build setting;
-(NSDictionary*)HTMLAtributes;
-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width;

// overide folloing method
-(void)prepareEditor;

//user interface status
@property (readonly) BOOL draggable;
@property (readonly) BOOL disableXInput;
@property (readonly) BOOL disableYInput;
@property (readonly) BOOL disableWidthInput;
@property (readonly) BOOL disableHeightInput;


@end
