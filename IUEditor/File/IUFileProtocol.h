//
//  IUFileNode.h
//  IUEditor
//
//  Created by jd on 5/29/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IUFile <NSObject>
@required
@property NSString *name;
- (NSArray*)children;
- (id <IUFile>) parent;

@end
