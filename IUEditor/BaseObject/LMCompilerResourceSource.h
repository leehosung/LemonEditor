//
//  LMCompilerResourceSource.h
//  IUEditor
//
//  Created by jd on 4/7/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LMCompilerResourceSource <NSObject>
-(NSString*)pathForResourceName:(NSString*)path;
@end
