//
//  JDWebUtil.h
//  SOIDX2
//
//  Created by jdyang on 10. 9. 5..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
		
#import <Foundation/Foundation.h>
@interface JDWebUtil : NSObject

+(NSData*)dataWithContentOfURL:(NSURL*)url post:(NSDictionary*)post;

@end
