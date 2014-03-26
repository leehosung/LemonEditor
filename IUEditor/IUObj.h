//
//  IUObj.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCSS.h"

#define IUCSSDefaultFrame -1

@interface IUObj : NSObject <NSCoding>

+(id)IU;
@property (readonly) IUCSS *css; //used by subclass


@property (readonly) NSMutableArray *children;

// this is IU setting
@property (nonatomic) NSString *resourceID;
@property (nonatomic) NSString *name;

@property (nonatomic) BOOL      hover;
@property (nonatomic) BOOL      editHoverStatus;

-(NSString*) outputHTML;
-(NSString*) outputCSSForDefault;

-(NSString*) editorHTML;
-(NSString*) editorCSSForHover;


// overide folloing method
-(id)initWithDefaultSetting;
-(id)loadWithDict:(NSDictionary*)dict error:(NSError**)error;
-(void)prepareEditor;

//user interface status
@property (readonly) BOOL draggable;
@property (readonly) BOOL disableXInput;
@property (readonly) BOOL disableYInput;
@property (readonly) BOOL disableWidthInput;
@property (readonly) BOOL disableHeightInput;

-(IUObj*)iuHitTest:(NSPoint)point;



@end
