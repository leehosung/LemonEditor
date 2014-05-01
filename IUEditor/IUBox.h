//
//  IUBox.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCSS.h"
#import "IUEvent.h"
#import "IUIdentifierManager.h"

@class IUIdentifierManager;

@protocol IUSourceDelegate <NSObject>
@required
@property _binding_ NSInteger selectedFrameWidth;
@property _binding_ NSInteger maxFrameWidth;

-(void)IU:(NSString *)identifier CSSUpdated:(NSString*)css forWidth:(NSInteger)width;
-(void)IU:(NSString *)identifier CSSRemovedforWidth:(NSInteger)width;

-(void)IU:(NSString*)identifier textHTML:(NSString *)html withParentID:(NSString *)parentID nearestID:(NSString *)nID index:(NSUInteger)index;
-(void)IU:(NSString *)identifier HTML:(NSString *)html withParentID:(NSString *)parentID;
-(void)IU:(NSString *)identifier setLink:(NSString *)link;
-(NSRect)IUPercentFrame:(NSString*)identifier;

-(void)IURemoved:(NSString*)identifier;

- (NSPoint)distanceFromIU:(NSString *)iuName to:(NSString *)parentName;
- (NSSize)frameSize:(NSString *)identifier;
- (void)changeIUPageHeight:(CGFloat)pageHeight;

/* 
 argument에 들어가는 것중에 dict, array는 string으로 보내서
 javascript내부에서 새로 var를 만들어서 사용
*/
- (id)callWebScriptMethod:(NSString *)function withArguments:(NSArray *)args;

@end


@class IUBox;
@class IUDocument;

@interface IUBox : NSObject <NSCoding, IUCSSDelegate>

@property (readonly) IUCSS *css; //used by subclass
@property (readonly) IUEvent *event;

-(IUDocument *)document;

//initialize
-(id)initWithManager:(IUIdentifierManager*)identifierManager;

// this is IU setting
@property (nonatomic, weak) IUIdentifierManager *identifierManager;
@property (nonatomic, copy) NSString *htmlID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id<IUSourceDelegate> delegate;
@property (weak) IUBox    *parent;
@property NSArray   *mutables;

// followings are IU build setting;
-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width;

//source
-(NSString*)html;
-(NSString*)cssForWidth:(NSInteger)width isHover:(BOOL)isHover;

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

-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error;
-(BOOL)addIU:(IUBox *)iu error:(NSError**)error;
-(BOOL)addIUReference:(IUBox *)iu error:(NSError**)error;
-(BOOL)removeIUAtIndex:(NSUInteger)index;
-(BOOL)removeIU:(IUBox *)iu;

- (void)setPixelFrame:(NSRect)frame;
- (void)setPercentFrame:(NSRect)frame;
- (void)setPosition:(NSPoint)position;
- (void)moveX:(NSInteger)x Y:(NSInteger)y;
- (void)increaseWidth:(NSInteger)width height:(NSInteger)height;
- (void)insertImage:(NSString *)imageName;


@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *textVariable;

-(BOOL)hasX;
-(BOOL)hasY;
-(BOOL)hasWidth;
-(BOOL)hasHeight;

-(BOOL)shouldEditText;


-(void)startGrouping;
-(void)endGrouping;

/// text managing

- (void)insertText:(NSString*)text withRange:(NSRange)range;
- (void)deleteTextInRange:(NSRange)range;
- (NSString*)textHTML;

//#define IUTextCursorLocationID    @"id"
//#define IUTextCursorLocationIndex @"index"
- (NSDictionary*)cursor;

@property (nonatomic) BOOL flow;
- (BOOL)flowChangeable;

@property (nonatomic) BOOL floatRight;
- (BOOL)floatRightChangeable;

- (void)updateCSSForEditViewPort;
@end