//
//  IUBox.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCSS.h"
#import "IUIdentifierManager.h"

@class IUIdentifierManager;

@protocol IUSourceDelegate <NSObject>
@required
@property _binding_ NSInteger selectedFrameWidth;
@property _binding_ NSInteger maxFrameWidth;

-(void)IU:(NSString *)identifier CSSChanged:(NSString*)css forWidth:(NSInteger)width;
-(void)IU:(NSString*)identifier textHTML:(NSString *)html withParentID:(NSString *)parentID nearestID:(NSString *)nID index:(NSUInteger)index;
-(void)IU:(NSString *)identifier HTML:(NSString *)html withParentID:(NSString *)parentID;
-(void)IU:(NSString *)identifier setLink:(NSString *)link;

-(void)IURemoved:(NSString*)identifier;

- (NSPoint)distanceFromIU:(NSString *)iuName to:(NSString *)parentName;
- (NSSize)frameSize:(NSString *)identifier;
- (void)changeIUPageHeight:(CGFloat)pageHeight;

@end


@class IUBox;
@class IUDocument;

@interface IUBox : NSObject <NSCoding, IUCSSDelegate>

@property (readonly) IUCSS *css; //used by subclass
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
-(NSArray *)HTMLOneAttribute;
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
@end