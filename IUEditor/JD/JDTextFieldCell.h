//
//  JDTextFieldCell.h
//  Mango
//
//  Created by JD on 13. 7. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>

@interface JDTextFieldCell :  NSTextFieldCell
{
	BOOL mIsEditingOrSelecting;
    BOOL mIsDrawBG;
}



@end