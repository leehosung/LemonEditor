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


@protocol IUSourceDelegate <NSObject>
@required

-(void)IUClassIdentifier:(NSString *)identifier CSSUpdated:(NSString*)css forWidth:(NSInteger)width;
-(void)IUClassIdentifier:(NSString *)identifier CSSRemovedforWidth:(NSInteger)width;
-(void)removeAllCSSWithIdentifier:(NSString *)identifier;

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

- (void)runJSAfterInsertIU:(IUBox *)iu;
- (void)runCSSJS;
/*
 argument에 들어가는 것중에 dict, array는 string으로 보내서
 javascript내부에서 새로 var를 만들어서 사용
*/
- (id)callWebScriptMethod:(NSString *)function withArguments:(NSArray *)args;

@end

typedef enum _IUPositionType{
    IUPositionTypeAbsolute,
    IUPositionTypeAbsoluteCenter,
    IUPositionTypeRelative,
    IUPositionTypeRelativeCenter,
    IUPositionTypeFloatLeft,
    IUPositionTypeFloatRight,
    IUPositionTypeFixed,
}IUPositionType;

typedef enum{
    IUTextTypeDefault,
    IUTextTypeH1,
    IUTextTypeH2,
}IUTextType;

typedef enum _IUOverflowType{
    IUOverflowTypeHidden,
    IUOverflowTypeVisible,
    IUOverflowTypeScroll,
}IUOverflowType;

@class IUBox;
@class IUSheet;
@class IUProject;

@interface IUBox : NSObject <NSCoding, IUCSSDelegate, NSCopying>{
    NSMutableArray *_m_children;
}

@property (readonly) IUCSS *css; //used by subclass
@property (readonly) IUEvent *event;


-(id)initWithProject:(IUProject*)project options:(NSDictionary*)options;


-(IUSheet *)sheet;


/**
 @brief return project of box
 @note if iu is not confirmed, return project argument at initialize process
 */
-(IUProject *)project;

- (void)connectWithEditor;

// this is IU setting
@property (copy) NSString *htmlID;
@property (copy, nonatomic) NSString *name;
@property (nonatomic, weak) id<IUSourceDelegate> delegate;
@property (weak) IUBox    *parent;
@property NSArray   *mutables;

#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
@property (nonatomic) NSString *text;
@property (nonatomic) BOOL lineHeightAuto;

- (void)updateAutoHeight;
#endif

-(NSString *)cssID;
// followings are IU build setting;
-(NSDictionary*)CSSAttributesForWidth:(NSInteger)width;

//source
-(NSString*)html;
-(NSString*)cssForWidth:(NSInteger)width isHover:(BOOL)isHover;

//user interface status
@property (readonly) BOOL canChangeXByUserInput;
@property (readonly) BOOL canChangeYByUserInput;
@property (readonly) BOOL canChangeWidthByUserInput;
@property (readonly) BOOL canChangeHeightByUserInput;


-(NSArray*)children;
@property (readonly) NSMutableArray *referenceChildren;
-(NSMutableArray*)allChildren;

-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error;
-(BOOL)addIU:(IUBox *)iu error:(NSError**)error;

/**
 removeIUAtIndex:
 @note removeIUAtIndex: uses removeIU: as implementation.
        unregister identifier automatically.
 */
-(BOOL)removeIUAtIndex:(NSUInteger)index;

/**
 removeIU:
 @note unregister identifier automatically.
 */
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
- (void)setImageName:(NSString *)imageName;
- (NSString *)imageName;

@property (nonatomic) id link, divLink;

-(BOOL)hasX;
-(BOOL)hasY;
-(BOOL)hasWidth;
-(BOOL)hasHeight;
- (BOOL)hasText;

-(BOOL)shouldAddIUByUserInput;


@property (nonatomic) IUPositionType positionType;
- (BOOL)canChangePositionType;

- (BOOL)canChangePositionAbsolute;
- (BOOL)canChangePositionRelative;
- (BOOL)canChangePositionFloatLeft;
- (BOOL)canChangePositionFloatRight;
- (BOOL)canChangePositionAbsoluteCenter;
- (BOOL)canChangePositionRelativeCenter;


- (BOOL)canCopy;

//@property (nonatomic) BOOL overflow;
- (BOOL)canChangeOverflow;

@property (nonatomic) IUOverflowType overflowType;

@property NSString *pgVisibleConditionVariable;
@property NSString *pgContentVariable;

- (void)updateCSSForEditViewPort;
- (void)updateCSSForMaxViewPort;
- (void)updateHTML;
- (void)updateJS;

@property float opacityMove;
@property float xPosMove;
//0 for default, 1 for H1, 2 for H2
@property IUTextType textType;

- (void)confirm;

- (NSArray *)helpDictionary;

//css 전체를 지울 때 사용
- (NSArray *)cssIdentifierArray;



@end