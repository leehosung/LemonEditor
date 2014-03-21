//
//  JDGitUtil.h
//  Mango
//
//  Created by JD on 13. 5. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@interface JDGitUtil : NSObject

-(id)initWithFilePath:(NSString*)filePath;
-(BOOL)gitInit;
-(BOOL)addAll;
-(BOOL)commit:(NSString*)commitMsg;
-(BOOL)push:(NSString*)remote branch:(NSString*)branch;
@end
