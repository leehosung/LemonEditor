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

-(void)IUClassIdentifier:(NSString *)identifier CSSUpdated:(NSString*)css forWidth:(NSInteger)width;
-(void)IUClassIdentifier:(NSString *)identifier CSSRemovedforWidth:(NSInteger)width;

-(void)IUHTMLIdentifier:(NSString*)identifier textHTML:(NSString *)html withParentID:(NSString *)parentID nearestID:(NSString *)nID index:(NSUInteger)index;
-(void)IUHTMLIdentifier:(NSString *)identifier HTML:(NSString *)html withParentID:(NSString *)parentID;

-(void)IUClassIdentifier:(NSString *)classIdentifier addClass:(NSString *)className;
-(void)IUClassIdentifier:(NSString *)classIdentifier removeClass:(NSString *)className;
-(void)updateTextRangeFromID:(NSString *)fromID toID:(NSString *)toID;

//-(NSRect)IUPercentFrame:(NSString*)identifier;

-(void)IURemoved:(NSString*)identifier withParentID:(NSString *)parentID;

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
@class IUProject;

@interface IUBox : NSObject <NSCoding, IUCSSDelegate, NSCopying>{
    NSMutableArray *_m_children;
    IUProject *_project;
}

@property (readonly) IUCSS *css; //used by subclass
@property (readonly) IUEvent *event;


-(id)initWithProject:(IUProject*)project options:(NSDictionary*)options;
-(IUDocument *)document;
-(IUProject *)project;

/**
 @brief Example usage:
 */
- (void)fetch;

// this is IU setting
@property (nonatomic, weak) IUIdentifierManager *identifierManager;
@property (nonatomic, copy) NSString *htmlID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) id<IUSourceDelegate> delegate;
@property (weak) IUBox    *parent;
@property NSArray   *mutables;


-(NSString *)cssID;
// followings are IU build setting;
-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width;

//source
-(NSString*)html;
-(NSString*)cssForWidth:(NSInteger)width isHover:(BOOL)isHover;

//user interface status
@property (readonly) BOOL enableXUserInput;
@property (readonly) BOOL enableYUserInput;
@property (readonly) BOOL enableWidthUserInput;
@property (readonly) BOOL enableHeightUserInput;

-(void)enableDelegate:(id)sender;
-(void)disableDelegate:(id)sender;


-(NSArray*)children;
@property (readonly) NSMutableArray *referenceChildren;
-(NSMutableArray*)allChildren;

-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error;
-(BOOL)addIU:(IUBox *)iu error:(NSError**)error;
-(BOOL)removeIUAtIndex:(NSUInteger)index;
-(BOOL)removeIU:(IUBox *)iu;
-(BOOL)shouldRemoveIUByUserInput;
-(BOOL)changeIUIndex:(IUBox*)iu to:(NSUInteger)index error:(NSError**)error;

-(BOOL)addIUReference:(IUBox *)iu error:(NSError**)error;

- (void)setPixelFrame:(NSRect)frame;
- (void)setPercentFrame:(NSRect)frame;
- (void)setPosition:(NSPoint)position;
- (void)movePosition:(NSPoint)point withParentSize:(NSSize)parentSize;
- (void)startDragSession;
- (void)increaseSize:(NSSize)size withParentSize:(NSSize)parentSize;
- (void)insertImage:(NSString *)imageName;


@property (nonatomic, copy) NSString *link, *divLink;
@property (nonatomic, copy) NSString *textVariable;

-(BOOL)hasX;
-(BOOL)hasY;
-(BOOL)hasWidth;
-(BOOL)hasHeight;

-(BOOL)shouldAddIUByUserInput;


-(void)startGrouping;
-(void)endGrouping;


@property (nonatomic) BOOL flow;
- (BOOL)flowChangeable;

@property (nonatomic) BOOL floatRight;
- (BOOL)floatRightChangeable;

@property (nonatomic) BOOL center;
- (BOOL)centerChangeable;

@property NSString *pgVisibleCondition;


- (void)updateCSSForEditViewPort;

@property float opacityMove;
@property float xPosMove;
//0 for default, 1 for H1, 2 for H2
@property NSUInteger textType;

@end