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
#import "IUDefinition.h"

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
    return [sizeArray sortedArrayUsingSelector:@selector(compare:)];
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
    

    CGFloat selectedWidth = selectBox.frame.size.width;
    
    [sizeTextField setStringValue:[NSString stringWithFormat:@"%.0f", selectedWidth]];
    [(LMCanvasView *)self.superview setWidthOfMainView:selectedWidth];
    ((LMCanvasVC *)self.delegate).selectedFrameWidth = (NSInteger)(floor(selectedWidth));
    [((LMCanvasVC *)self.delegate) refreshGridFrameDictionary];
}

#pragma mark -
#pragma mark add, remove width
- (void)setMaxWidth{
    InnerSizeBox *maxBox = (InnerSizeBox *)boxManageView.subviews[0];
    if(maxBox){
        NSInteger maxWidth = (NSInteger)(floor(maxBox.frame.size.width));
        ((LMCanvasVC *)self.delegate).maxFrameWidth = maxWidth;
    }
}

- (id)addFrame:(NSInteger)width{
    NSNumber *widthNumber = [NSNumber numberWithInteger:width];
    [sizeArray addObject:widthNumber];
    NSRect boxFrame = NSMakeRect(0, 0, width, self.frame.size.height);
    InnerSizeBox *newBox = [[InnerSizeBox alloc] initWithFrame:boxFrame];
    newBox.boxDelegate = self;
    NSInteger index = [[self sortedArray] indexOfObject:widthNumber];
    
    if(index > 0){
        NSView *preView = boxManageView.subviews[index-1];
        [boxManageView addSubviewLeftInFrameWithFrame:newBox positioned:NSWindowAbove relativeTo:preView];
    }
    else if(boxManageView.subviews.count == 0){
        [boxManageView addSubviewLeftInFrameWithFrame:newBox];
    }
    else{
        NSView *frontView = boxManageView.subviews[boxManageView.subviews.count-1];
        [boxManageView addSubviewLeftInFrameWithFrame:newBox positioned:NSWindowAbove relativeTo:frontView];
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
