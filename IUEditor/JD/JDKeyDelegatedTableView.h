//
//  IUFrameSizeTableView.h
//  WebGenerator
//
//  Created by JD on 12/24/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol JDKeyDelegateTableViewProtocol <NSObject>
@required
-(BOOL)tableView:(NSTableView*)tableView keyDown:(unichar)key;
-(BOOL)tableView:(NSTableView*)tableView endEditing:(NSText *)textObject row:(NSUInteger)row column:(NSUInteger)column;
@end

@interface JDKeyDelegatedTableView : NSTableView
@property IBOutlet id <JDKeyDelegateTableViewProtocol> keyDelegate;
@end