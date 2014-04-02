//
//  PointLayer.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 25..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "PointLayer.h"
#import "IULog.h"
#import "CursorRect.h"
#import "JDUIUtil.h"

@implementation InnerPointLayer

-(id)initWithType:(IUPointLayerPosition)aType frame:(NSRect)aFrame{
    self = [super init];
    if (self){
        type = aType;
        
        [self setFrame:aFrame];
        self.backgroundColor = [[NSColor lightGrayColor] CGColor];
        self.borderColor = [[NSColor blackColor] CGColor];
        self.borderWidth = 1.0f;
        
        [self disableAction];

    }
    return self;
}

-(CALayer *)hitTest:(CGPoint)p{
    if (NSPointInRect(p, self.frame)){
        return self;
    }
    return nil;
}

-(void)updatedFrame:(NSRect)aFrame{
    [self setFrame:aFrame];
}

-(IUPointLayerPosition)type{
    return type;
}

@end

@implementation PointLayer

- (id)initWithIUID:(NSString *)aIUID withFrame:(NSRect)frame{
    self = [super init];
    if(self){
        IUID = aIUID;
        iuFrame = frame;
        for(int i=0; i<IUInnerPointLayerCount; i++){
            NSRect innerFrame = [self makeInnerFrameWithType:i];
            InnerPointLayer *newInnerLayer = [[InnerPointLayer alloc] initWithType:(IUPointLayerPosition)i frame:innerFrame];
            [self addSublayer:newInnerLayer];
        }
        [self disableAction];

    }
    return self;
}


- (CALayer *)hitTest:(CGPoint)p{
    CGPoint convertedPoint = [self convertPoint:p fromLayer:nil];
    return [super hitTest:convertedPoint];
}
- (void)updateFrame:(NSRect)frame{
    iuFrame = frame;
    for(InnerPointLayer *layer in self.sublayers){
        NSRect innerFrame = [self makeInnerFrameWithType:[layer type]];
        [layer updatedFrame:innerFrame];
    }
    [self setNeedsDisplay];
}

- (NSRect)makeNewFrameWithType:(IUPointLayerPosition)type withDiffPoint:(NSPoint)diffPoint{
    
    NSRect frame;
    switch (type) {
        case IUPointLayerPositionLeftUp:
            frame = NSMakeRect(iuFrame.origin.x+diffPoint.x, iuFrame.origin.y+diffPoint.y, iuFrame.size.width-diffPoint.x, iuFrame.size.height-diffPoint.y);
            break;
        case IUPointLayerPositionLeftMiddle:
            frame = NSMakeRect(iuFrame.origin.x+diffPoint.x, iuFrame.origin.y, iuFrame.size.width-diffPoint.x, iuFrame.size.height);
            break;
        case IUPointLayerPositionLeftDown:
             frame = NSMakeRect(iuFrame.origin.x+diffPoint.x, iuFrame.origin.y, iuFrame.size.width-diffPoint.x, iuFrame.size.height+diffPoint.y);
            break;
        case IUPointLayerPositionUp:
            frame = NSMakeRect(iuFrame.origin.x, iuFrame.origin.y+diffPoint.y, iuFrame.size.width, iuFrame.size.height-diffPoint.y);
            break;
        case IUPointLayerPositionDown:
            frame = NSMakeRect(iuFrame.origin.x, iuFrame.origin.y, iuFrame.size.width, iuFrame.size.height+diffPoint.y);
            break;
        case IUPointLayerPositionRightUp:
            frame = NSMakeRect(iuFrame.origin.x, iuFrame.origin.y+diffPoint.y, iuFrame.size.width+diffPoint.x, iuFrame.size.height-diffPoint.y);
            break;
        case IUPointLayerPositionRightMiddle:
            frame = NSMakeRect(iuFrame.origin.x, iuFrame.origin.y, iuFrame.size.width+diffPoint.x, iuFrame.size.height);
            break;
        case IUPointLayerPositionRightDown:
            frame = NSMakeRect(iuFrame.origin.x, iuFrame.origin.y, iuFrame.size.width+diffPoint.x, iuFrame.size.height+diffPoint.y);
            break;
        default:
            IULog(@"Error : this type cannot be");
            break;
    }
    return frame;
    
}

- (NSString *)iuID{
    return IUID;
}

- (NSRect)makeInnerFrameWithType:(IUPointLayerPosition)type{
    NSPoint point;
    switch (type) {
        case IUPointLayerPositionLeftUp:
            point = NSMakePoint(iuFrame.origin.x, iuFrame.origin.y);
            break;
        case IUPointLayerPositionLeftMiddle:
            point = NSMakePoint(iuFrame.origin.x, iuFrame.origin.y+(iuFrame.size.height)/2);
            break;
        case IUPointLayerPositionLeftDown:
            point = NSMakePoint(iuFrame.origin.x, iuFrame.origin.y+iuFrame.size.height);
            break;
        case IUPointLayerPositionUp:
            point = NSMakePoint(iuFrame.origin.x+(iuFrame.size.width)/2, iuFrame.origin.y);
            break;
        case IUPointLayerPositionDown:
            point = NSMakePoint(iuFrame.origin.x+(iuFrame.size.width)/2, iuFrame.origin.y+iuFrame.size.height);
            break;
        case IUPointLayerPositionRightUp:
            point = NSMakePoint(iuFrame.origin.x+iuFrame.size.width, iuFrame.origin.y);
            break;
        case IUPointLayerPositionRightMiddle:
            point = NSMakePoint(iuFrame.origin.x+iuFrame.size.width,  iuFrame.origin.y+(iuFrame.size.height)/2);
            break;
        case IUPointLayerPositionRightDown:
            point = NSMakePoint(iuFrame.origin.x+iuFrame.size.width, iuFrame.origin.y+iuFrame.size.height);
            break;
        default:
            IULog(@"Error : this type cannot be");
            break;
    }
    NSRect frame = NSMakeRect(round(point.x-IUPointSize/2), round(point.y-IUPointSize/2), IUPointSize, IUPointSize);
    return frame;
}


- (NSMutableArray *)cursorArray{
    
    NSMutableArray *array = [NSMutableArray array];
    //default hotSpotSize from resizeCursor;
    NSPoint hotSpot =NSMakePoint(12, 12);
    
    for(InnerPointLayer *layer in self.sublayers){
        CursorRect *newCursorRect = [[CursorRect alloc] init];
        newCursorRect.frame = layer.frame;
        
        switch (layer.type) {
            case IUPointLayerPositionLeftDown:
            case IUPointLayerPositionRightUp:{
                NSImage *img = [NSImage imageNamed:@"ResizeNE-SW"];
                NSCursor *cursor = [[NSCursor alloc] initWithImage:img hotSpot:hotSpot];
                newCursorRect.cursor = cursor;
                break;
            }
            case IUPointLayerPositionLeftUp:
            case IUPointLayerPositionRightDown:{
                NSImage *img = [NSImage imageNamed:@"ResizeNW-SE"];
                NSCursor *cursor = [[NSCursor alloc] initWithImage:img hotSpot:hotSpot];
                newCursorRect.cursor = cursor;
                break;
            }
            case IUPointLayerPositionUp:
            case IUPointLayerPositionDown:
                newCursorRect.cursor = [NSCursor resizeUpDownCursor];
                break;
            case IUPointLayerPositionRightMiddle:
            case IUPointLayerPositionLeftMiddle:
                newCursorRect.cursor = [NSCursor resizeLeftRightCursor];
                break;
            default:
                IULog(@"Error : this type cannot be");
                break;
        }
        
        [array addObject:newCursorRect];
    }
    
    return array;
}

@end
