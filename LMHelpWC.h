//
//  LMHelpWC.h
//  IUEditor
//
//  Created by jd on 6/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMHelpWC : NSWindowController

+ (LMHelpWC *)sharedHelpWC;
- (void)showHelpDocumentWithKey:(NSString *)key;
- (void)showHelpWebURL:(NSURL*)url withTitle:(NSString*)title;
@end
