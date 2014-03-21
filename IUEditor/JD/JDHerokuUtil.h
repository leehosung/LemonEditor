//
//  JDHerokuUtil.h
//  Mango
//
//  Created by JD on 13. 5. 17..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@class JDHerokuUtil;

@protocol JDHerokuUtilLoginDelegate <NSObject>
@required

-(void)herokuUtil:(JDHerokuUtil*)util loginProcessFinishedWithResultCode:(NSInteger)resultCode;
@end


#define kNotiHerokuLogin @"kNotiHerokuLogin"

@interface JDHerokuUtil : NSObject{
}

-(id)init;
-(BOOL)create:(NSString*)appName resultLog:(NSString**)resultLog;
-(void)login:(NSString*)myid password:(NSString*)mypasswd;
-(BOOL)combineGitPath:(NSString*)path appName:(NSString*)appName;
-(void)updateLoginInfo;

@property NSString *loginID;
@property BOOL  logging;
@property BOOL  logined;
@property id <JDHerokuUtilLoginDelegate>    loginDelegate;

@end