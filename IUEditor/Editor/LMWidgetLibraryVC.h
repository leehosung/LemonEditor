//
//  LMWidgetLibraryVC.h
//  IUEditor
//
//  Created by JD on 3/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMWidgetLibraryVC : NSViewController
-(void)setWidgetProperties:(NSArray*)array;
@property (nonatomic, readonly) NSArray *widgets;
@end