//
//  PointTextLayer.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 3. 27..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "PointTextLayer.h"
#import "JDUIUtil.h"
#import "JDLogUtil.h"

@implementation PointTextLayer

- (id)initWithIUID:(NSString *)aIUID withFrame:(NSRect)frame type:(PointTextType)aType{
    self = [super init];
    if (self) {
        IUID = aIUID;
        iuFrame = frame;
        type = aType;
        
        self.backgroundColor = [[NSColor clearColor] CGColor];
        [self setFontSize:10];
        [self setForegroundColor:[[NSColor blackColor] CGColor]];
        
        [self disableAction];
        [self draw];
    }
    return self;
    
}
- (NSSize)defaultSize{
    return NSMakeSize(60, 20);
}
- (void)updateFrame:(NSRect)frame{
    iuFrame = frame;
    [self draw];
    
}

- (void)draw{
    NSRect textRect;
    
    switch(type){
        case PointTextTypeOrigin:
            self.string = [[NSString alloc] initWithFormat:@"(%.0f, %.0f)",
                           iuFrame.origin.x, iuFrame.origin.y];
            
            textRect  = NSMakeRect(iuFrame.origin.x - self.defaultSize.width,
                                   iuFrame.origin.y-self.defaultSize.height+5,
                                   self.defaultSize.width, self.defaultSize.height);
            
            [self setAlignmentMode:kCAAlignmentRight];
            break;
        case PointTextTypeSize:
            self.string = [[NSString alloc] initWithFormat:@"(%.0f, %.0f)",
                           iuFrame.size.width, iuFrame.size.height];
            
            textRect  = NSMakeRect(iuFrame.origin.x + iuFrame.size.width,
                                   iuFrame.origin.y + iuFrame.size.height,
                                   self.defaultSize.width, self.defaultSize.height);
            
            [self setAlignmentMode:kCAAlignmentLeft];
            break;
        default:
            JDWarnLog( @"this type cannot be");
            break;
    }
    
    [self setFrame:textRect];

}
- (NSString *)iuID{
    return IUID;
}


@end
