//
//  LMRulerView.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMRulerView.h"

@implementation LMRulerView

- (id)init{
    self = [super init];
    if(self)
    {
        [self setLayer:[[CALayer alloc] init]];
        [self setWantsLayer:YES];
        
        CALayer *rulerLayer = [CALayer layer];
        NSImage *image = [NSImage imageNamed:@"ruler"];
        NSColor *rulerColor = [NSColor colorWithPatternImage:image];
        [rulerLayer setBackgroundColor:[rulerColor CGColor]];
        [rulerLayer setBounds:CGRectMake(0, 0, 0, 8)];
        
        [self.layer addSubLayerBottomFrame:rulerLayer];
        
    }
    return self;
}





@end
