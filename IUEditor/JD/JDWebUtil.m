//
//  SOWebUtil.m
//  SOIDX2
//
//  Created by jdyang on 10. 9. 5..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JDWebUtil.h"
#import "NSString+JDExtension.h"

@implementation JDWebUtil

+(NSData*)dataWithContentOfURL:(NSURL*)url post:(NSDictionary*)post{
    NSMutableString *dataStr = [NSMutableString string];
    for (NSString *key in post) {
        [dataStr appendFormat:@"%@=%@&", key, [post objectForKey:key]];
    }
    [dataStr trimWithCharacterInString:@"&"];
    
    NSData *data=[dataStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%ld", [data length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:data];
	NSURLResponse *response;
	NSError *error;
	NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error!=nil) {
        JDErrorLog( @"%s error", __func__);
	}
	return responseData;

}



@end