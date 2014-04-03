//
//  CanvasWindow.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 24..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "LMWindow.h"
#import "LMWC.h"
#import "JDUIUtil.h"
#import "JDLogUtil.h"
#import "IUDefinition.h"

@implementation LMWindow


#pragma mark -
#pragma mark mouse

-(void)sendEvent:(NSEvent *)theEvent{
    
    [self.canvasView receiveEvent:theEvent];
    [super sendEvent:theEvent];

}

@end
