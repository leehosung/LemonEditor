//
//  LMHelpWC.h
//  IUEditor
//
//  Created by jd on 6/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMPDFHelpWC : NSWindowController

+ (LMPDFHelpWC *)sharedPDFHelpWC;
- (void)setHelpDocumentWithKey:(NSString *)key;

@end
