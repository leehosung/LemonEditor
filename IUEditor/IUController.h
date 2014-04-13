//
//  IUTreeController.h
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUBox.h"

@class IUDocument;
@interface IUController : NSTreeController 

-(void)setSelectedObjectsByIdentifiers:(NSArray*)identifiers;
-(NSArray*)selectedIdentifiers;

-(IUBox *)IUBoxByIdentifier:(NSString *)identifier;

-(NSString*)keyPathFromControllerToCSSTag:(IUCSSTag)tag;
-(NSString*)keyPathFromControllerToProperty:(NSString*)property;

@end
