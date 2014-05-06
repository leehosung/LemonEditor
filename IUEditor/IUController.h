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
@class IUImport;
@interface IUController : NSTreeController

-(NSArray*)selectedPedigree;

-(void)setSelectedObjectsByIdentifiers:(NSArray*)identifiers;
-(void)trySetSelectedObjectsByIdentifiers:(NSArray *)identifiers;

-(NSArray*)selectedIdentifiers;
-(NSArray*)selectedIdentifiersWithImportIdentifier;

-(IUBox *)IUBoxByIdentifier:(NSString *)identifier;

-(NSString*)keyPathFromControllerToCSSTag:(IUCSSTag)tag;
-(NSString*)keyPathFromControllerToEventTag:(IUEventTag)tag;
-(NSString*)keyPathFromControllerToProperty:(NSString*)property;

-(IUImport*)importIUInSelectionChain;

@property _binding_ NSRange selectedTextRange;

@end
