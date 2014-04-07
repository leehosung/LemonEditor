//
//  IUObj.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCSS.h"

@protocol IUSourceDelegate <NSObject>
@required
@property NSInteger selectedFrameWidth;

-(void)IU:(NSString*)identifier HTMLChanged:(NSString*)html;
-(void)IU:(NSString*)identifier CSSChanged:(NSString*)css forWidth:(NSInteger)width;
-(void)IU:(NSString*)identifier insertedTo:(NSString*)parentIdentifier atIndex:(NSInteger)index CSS:(NSString*)css HTML:(NSString*)html;
-(void)IURemoved:(NSString*)identifier;
@end


#define IUCSSDefaultFrame -1

@class IUObj;
@class IUDocument;

@interface IUObj : NSObject <NSCoding, IUCSSDelegate>

@property (readonly) IUCSS *css; //used by subclass
-(IUDocument *)document;

//initialize
-(id)initWithSetting:(NSDictionary*)setting;

// this is IU setting
@property (nonatomic, copy) NSString *htmlID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) id<IUSourceDelegate> delegate;
@property IUObj    *parent;
@property NSArray   *mutables;

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

-(void)enableDelegate:(id)sender;
-(void)disableDelegate:(id)sender;


-(NSArray*)children;
@property (readonly) NSMutableArray *referenceChildren;
-(NSMutableArray*)allChildren;

-(BOOL)insertIU:(IUObj *)iu atIndex:(NSInteger)index  error:(NSError**)error;
-(BOOL)addIU:(IUObj *)iu error:(NSError**)error;
-(BOOL)addIUReference:(IUObj *)iu error:(NSError**)error;
-(BOOL)removeIU:(IUObj *)iu;

- (void)moveX:(NSInteger)x Y:(NSInteger)y;
- (void)increaseWidth:(NSInteger)width height:(NSInteger)height;
@end