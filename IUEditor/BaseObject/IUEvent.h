//
//  IUEvent.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    IUEventActionTypeClick,
    IUEventActionTypeHover,
    
}IUEventActionType;

typedef enum{
    IUEventVisibleTypeVertical,
    IUEventVisibleTypeHorizontal,
    
}IUEventVisibleType;

@interface IUEvent : NSObject

//trigger
@property NSString *variable;
@property NSInteger maxValue, initialValue;
@property IUEventActionType actionType;

//receiver
@property BOOL  enableVisible;
@property NSString *eqVisibleVariable;
@property (nonatomic) NSString *eqVisible;
@property NSInteger eqVisibleDuration;
@property IUEventVisibleType directionType;

@property BOOL enableFrame;
@property NSString *eqFrameVariable;
@property (nonatomic) NSString *eqFrame;
@property NSInteger eqFrameDuration;
@property CGFloat   eqFrameWidth, eqFrameHeight;

@end
