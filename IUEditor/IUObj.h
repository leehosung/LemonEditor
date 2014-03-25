//
//  IUObj.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IUCSSDefaultFrame -1

@interface IUObj : NSObject <NSCoding>

+(id)IUObj;
+(NSArray*)propertyList;

// overide folloing method
-(id)initWithDefaultSetting;
-(id)loadWithDict:(NSDictionary*)dict error:(NSError**)error;
-(void)prepareEditor;


// user interface status
@property (readonly) BOOL draggable;
@property (readonly) BOOL disableXInput;
@property (readonly) BOOL disableYInput;
@property (readonly) BOOL disableWidthInput;
@property (readonly) BOOL disableHeightInput;

-(IUObj*)iuHitTest:(NSPoint)point;

// instance define
-(void)importFromDict:(NSDictionary*)dict;
-(NSMutableDictionary*)dict;
-(NSData*)serializedData;

@property (nonatomic) NSString *resourceID;
@property (nonatomic) NSString *HTMLID;
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL      focus;

-(NSString*) outputCSS;
-(NSString*) outputHTML;

@property (readonly) NSMutableArray *children;

@end
