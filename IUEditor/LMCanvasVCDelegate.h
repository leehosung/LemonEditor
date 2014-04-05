//
//  LMCanvasVCDelegate.h
//  IUEditor
//
//  Created by JD on 4/5/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMCanvasVCDelegate <NSObject>
@required
-(void)IUSelected:(NSArray*)identifiers;
@end
