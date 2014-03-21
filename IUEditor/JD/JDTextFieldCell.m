//
//  JDTextFieldCell.m
//  Mango
//
//  Created by JD on 13. 7. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDTextFieldCell.h"

@implementation JDTextFieldCell

- (NSRect)titleRectForBounds:(NSRect)theRect{
	NSRect newRect = [super titleRectForBounds:theRect];
    
	// When the text field is being
	// edited or selected, we have to turn off the magic because it screws up
	// the configuration of the field editor.  We sneak around this by
	// intercepting selectWithFrame and editWithFrame and sneaking a
	// reduced, centered rect in at the last minute.
	if (mIsEditingOrSelecting == NO)
	{
		// Get our ideal size for current text
		NSSize textSize = [self cellSizeForBounds:theRect];
        
		// Center that in the proposed rect
		float heightDelta = newRect.size.height - textSize.height;
		if (heightDelta > 0)
		{
			newRect.size.height -= heightDelta;
			newRect.origin.y += (heightDelta / 2);
		}
	}
	
	return newRect;
}

- (NSRect)drawingRectForBounds:(NSRect)theRect
{
	// Get the parent's idea of where we should draw
	NSRect newRect = [super drawingRectForBounds:theRect];
    
	// When the text field is being
	// edited or selected, we have to turn off the magic because it screws up
	// the configuration of the field editor.  We sneak around this by
	// intercepting selectWithFrame and editWithFrame and sneaking a
	// reduced, centered rect in at the last minute.
	if (mIsEditingOrSelecting == NO)
	{
		// Get our ideal size for current text
		NSSize textSize = [self cellSizeForBounds:theRect];
        
		// Center that in the proposed rect
		float heightDelta = newRect.size.height - textSize.height;
		if (heightDelta > 0)
		{
			newRect.size.height -= heightDelta;
			newRect.origin.y += (heightDelta / 2);
		}
	}
	
	return newRect;
}
 

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
	aRect = [self drawingRectForBounds:aRect];
	mIsEditingOrSelecting = YES;
	[super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
	mIsEditingOrSelecting = NO;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
	aRect = [self drawingRectForBounds:aRect];
	mIsEditingOrSelecting = YES;
	[super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
	mIsEditingOrSelecting = NO;
}

@end
