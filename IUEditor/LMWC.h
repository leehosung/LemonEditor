//
//  LMWC.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUDocumentController.h"

@interface LMWC : NSWindowController

@property (nonatomic) _binding_ id selectedDocument;
@property (nonatomic) _binding_ id selectedIU;

@property (weak) IBOutlet NSView *leftV;
@property (weak) IBOutlet NSView *centerV;
@property (weak) IBOutlet NSView *toolbarV;
@property (weak) IBOutlet NSView *rightV;
@property (weak) IBOutlet NSView *bottomV;

-(void)loadProject:(NSString*)path;
-(void)startNewProject;

@end
