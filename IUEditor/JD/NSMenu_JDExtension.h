//
//  NSMenu_JDExtension.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 12. 5..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMenu (JDExtension)

- (NSMenuItem *)addItemWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode target:(id)target;

@end
