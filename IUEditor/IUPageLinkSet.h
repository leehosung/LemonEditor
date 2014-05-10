//
//  IUPageLinkSet.h
//  IUEditor
//
//  Created by jd on 5/8/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"

@interface IUPageLinkSet : IUBox
@property NSString  *pageCountVariable;
@property IUAlign   pageLinkAlign;
@property NSColor   *selectedButtonBGColor;
@property NSColor   *defaultButtonBGColor;
@property float     buttonMargin;
@end