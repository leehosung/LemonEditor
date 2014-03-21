//
//  NSTextField+DragAndDrop.h
//  Mango
//
//  Created by JD on 13. 9. 18..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>

@interface NSTextField_DragAndDrop : NSTextField <NSDraggingDestination>
@property NSString* dValue;
@end
