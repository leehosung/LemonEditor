//
//  JDGitUtil.m
//  Mango
//
//  Created by JD on 13. 5. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDGitUtil.h"
#import "JDFileUtil.h"

@implementation JDGitUtil{
    NSString *filePath;
}

-(id)initWithFilePath:(NSString*)_filePath{
    self = [super init];
    if (self) {
        filePath = _filePath;
    }
    return self;
}

-(BOOL)gitInit{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];
    NSString *log, *errLog;
    NSInteger result = [JDFileUtil execute:gitPath atDirectory:filePath arguments:@[@"init"] stdOut:&log stdErr:&errLog];
    NSLog (@"git init returned:\n%@ + %@", log, errLog);
    return !result;
}

-(BOOL)addAll{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];
    NSString *log, *errLog;
    NSInteger resultCode = [JDFileUtil execute:gitPath atDirectory:filePath arguments:@[@"add", @"."] stdOut:&log stdErr:&errLog];
    NSLog (@"git init returned:\n%@ + %@", log, errLog);
    return !resultCode;
}

-(BOOL)commit:(NSString*)commitMsg{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];
    NSString *msg = [NSString stringWithFormat:@"'%@'", commitMsg];
    NSString *log, *errLog;
    NSInteger resultCode = [JDFileUtil execute:gitPath atDirectory:filePath arguments:@[@"commit", @"-a", @"-m",msg] stdOut:&log stdErr:&errLog];
    NSLog (@"git init returned:\n%@ + %@", log, errLog);
    return !resultCode;

}

-(BOOL)push:(NSString*)remote branch:(NSString*)branch{
    NSString *gitPath = [[NSBundle mainBundle] pathForResource:@"git" ofType:@""];

    NSString *log, *errLog;
    NSInteger resultCode = [JDFileUtil execute:gitPath atDirectory:filePath arguments:[NSMutableArray arrayWithObjects:@"push", remote, branch, nil] stdOut:&log stdErr:&errLog];
    
    return !resultCode;
    
}

@end
