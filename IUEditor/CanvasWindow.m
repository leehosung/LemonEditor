//
//  CanvasWindow.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 24..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "CanvasWindow.h"
#import "LMWC.h"
#import "JDUIUtil.h"
#import "JDLogUtil.h"
#import "IUDefinition.h"

@implementation CanvasWindow


#pragma mark -
#pragma mark mouse

-(void)sendEvent:(NSEvent *)theEvent{
    
    [self.canvasView sendEvent:theEvent];
    [super sendEvent:theEvent];

}

@end
