//
//  SizeView.m
//  IUCanvas
//
//  Created by ChoiSeungmi on 2014. 4. 1..
//  Copyright (c) 2014년 ChoiSeungmi. All rights reserved.
//

#import "SizeView.h"
#import "JDUIUtil.h"
#import "LMCanvasView.h"
#import "LMCanvasVC.h"

@implementation SizeTextField : NSTextField
- (id)init{
    self = [super init];
    if (self){
        [self setBezeled:NO];
        [self setDrawsBackground:NO];
        [self setEditable:NO];
        [self setSelectable:NO];
        [self setAlignment:NSCenterTextAlignment];
    }
    return self;
}


- (NSView *)hitTest:(NSPoint)aPoint{
    return nil;
}

@end


@implementation SizeView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        //textField
        sizeTextField = [[SizeTextField alloc] init];
       
        //sizeBox
        sizeArray = [NSMutableArray array];
        boxManageView = [[NSView alloc] init];
        selectIndex = 0;
        [self addSubviewVeriticalCenterInFrameWithFrame:sizeTextField height:sizeTextField.attributedStringValue.size.height];
        [self addSubviewFullFrame:boxManageView positioned:NSWindowBelow relativeTo:sizeTextField];
        
       
    }
    return self;
}

- (void)resetCursorRects{
    InnerSizeBox *maxBox = (InnerSizeBox *)boxManageView.subviews[0];
    [self addCursorRect:[maxBox frame] cursor:[NSCursor pointingHandCursor]];
}

#pragma mark -

- (NSArray *)sortedArray{
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    return [sizeArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
}

#pragma mark -
#pragma mark select

- (void)selectBox:(InnerSizeBox *)selectBox{
    NSUInteger newSelectIndex = [boxManageView.subviews indexOfObject:selectBox];
    
    if(newSelectIndex != selectIndex){
        InnerSizeBox *deselectBox = [boxManageView.subviews objectAtIndex:selectIndex];
        [deselectBox deselect];
        
        selectIndex = newSelectIndex;
    }
    
    NSInteger selectedWidth = selectBox.frameWidth;
    
    [sizeTextField setStringValue:[NSString stringWithFormat:@"%ld", selectedWidth]];
    [(LMCanvasView *)self.superview setWidthOfMainView:selectedWidth];
    ((LMCanvasVC *)self.delegate).selectedFrameWidth = selectedWidth;
    [((LMCanvasVC *)self.delegate) refreshGridFrameDictionary];
}

#pragma mark -
#pragma mark add, remove width
- (NSInteger)nextSmallSize:(NSInteger)size{
    NSNumber *sizeNumber = [NSNumber numberWithInteger:size];
    NSInteger index = [[self sortedArray] indexOfObject:sizeNumber]+1;
    
    if(index < boxManageView.subviews.count){
        InnerSizeBox *nextBox = (InnerSizeBox *)boxManageView.subviews[index];
        return nextBox.frameWidth;
    }
    else{
        return 0;
    }
}
- (void)setMaxWidth{
    InnerSizeBox *maxBox = (InnerSizeBox *)boxManageView.subviews[0];
    if(maxBox){
        ((LMCanvasVC *)self.delegate).maxFrameWidth = maxBox.frameWidth;
    }
}

- (id)addFrame:(NSInteger)width{
    NSNumber *widthNumber = [NSNumber numberWithInteger:width];
    [sizeArray addObject:widthNumber];
    NSRect boxFrame = NSMakeRect(0, 0, width, self.frame.size.height);
    InnerSizeBox *newBox = [[InnerSizeBox alloc] initWithFrame:boxFrame width:width];
    newBox.boxDelegate = self;
    NSInteger index = [[self sortedArray] indexOfObject:widthNumber];
    
    if(index > 0){
        //view가 중간에 들어갈때
        //size 큰것보다 하나 위로 들어감
        NSView *preView = boxManageView.subviews[index-1];
        [boxManageView addSubviewLeftInFrameWithFrame:newBox positioned:NSWindowAbove relativeTo:preView];
    }
    else if(boxManageView.subviews.count == 0){
        [boxManageView addSubviewLeftInFrameWithFrame:newBox];
    }
    else{
        //maximumsize임
        NSView *frontView = boxManageView.subviews[boxManageView.subviews.count-1];
        [boxManageView addSubviewLeftInFrameWithFrame:newBox positioned:NSWindowBelow relativeTo:frontView];
    }
    [self setMaxWidth];
    return newBox;

}
- (void)removeFrame:(NSInteger)width{
    NSNumber *widthNumber = [NSNumber numberWithInteger:width];
    NSInteger index = [[self sortedArray] indexOfObject:widthNumber];
    
    NSView *removeView = boxManageView.subviews[index];
    [removeView removeFromSuperview];
    [self setMaxWidth];
}

@end
