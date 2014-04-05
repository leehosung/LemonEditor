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

@protocol IUDelegate <NSObject>
@required
-(void)IU:(NSString*)identifier HTMLChanged:(NSString*)html;
-(void)IU:(NSString*)identifier CSSChanged:(NSString*)css forWidth:(int)width;
-(void)IU:(NSString*)identifier insertedTo:(NSString*)parentIdentifier atIndex:(NSInteger)index CSS:(NSString*)css HTML:(NSString*)html;
-(void)IURemoved:(NSString*)identifier;
@end


#define IUCSSDefaultFrame -1


@interface IUObj : NSObject <NSCoding, IUCSSDelegate>

@property (readonly) IUCSS *css; //used by subclass


@property (readonly) NSArray *children;
-(NSMutableArray*)allChildren;

//initialize
-(id)initWithProject:(IUProject*)project setting:(NSDictionary*)setting;
@property IUProject *project;

// this is IU setting
@property (nonatomic) NSString *htmlID;
@property (nonatomic) NSString *name;
@property id<IUDelegate> delegate;

// followings are IU build setting;
-(NSDictionary*)HTMLAtributes;
-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width;

//source
-(NSString*)html;
-(NSString*)cssForWidth:(NSInteger)width;

//user interface status
@property (readonly) BOOL draggable;
@property (readonly) BOOL disableXInput;
@property (readonly) BOOL disableYInput;
@property (readonly) BOOL disableWidthInput;
@property (readonly) BOOL disableHeightInput;


@end