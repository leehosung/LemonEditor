//
//  PGPageLinkSet.h
//  IUEditor
//
//  Created by jd on 5/8/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"

@interface PGPageLinkSet : IUBox
@property (nonatomic) NSString  *pageCountVariable;
@property (nonatomic) IUAlign   pageLinkAlign;
@property (nonatomic) NSColor   *selectedButtonBGColor;
@property (nonatomic) NSColor   *defaultButtonBGColor;
@property (nonatomic) float     buttonMargin;
@end