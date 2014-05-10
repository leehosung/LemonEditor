//
//  IUDjangoProject.h
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUProject.h"

@interface IUDjangoProject : IUProject
+(IUDjangoProject*)createProject:(NSDictionary*)setting error:(NSError**)error;

//setting:
//IUProjectKeyAppName (optional)
//IUProjectKeyDirectory (required)
+(IUDjangoProject*)convertProject:(IUProject*)project setting:(NSDictionary*)setting error:(NSError**)error;
@end
