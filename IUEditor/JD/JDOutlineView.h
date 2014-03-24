//
//  JDOutlineView.h
//  Mango
//
//  Created by JD on 13. 2. 5..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>

@protocol JDOutlineViewDataSource <NSObject>
//-(NSMenu*)defaultMenuForRow:(NSInteger)row;
@end

@interface JDOutlineView : NSOutlineView{
}

- (void)selectItem:(id)item;

/*
- (id)selectedView;

@property IBOutlet id <JDOutlineViewDataSource> JDDataSource;
@property NSInteger rightClickedIndex;
@property IBOutlet id enterKeyDelegate;
@property IBOutlet id deleteKeyDelegate;
*/
@end