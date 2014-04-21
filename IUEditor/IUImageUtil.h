//
//  IUImageUtil.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 1..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface IUImageUtil : NSImage

+ (NSString *)writeToFile:(NSImage *)image filePath:(NSString *)filePath fileName:(NSString *)fileName checkFileName:(BOOL)checkFileName;
+ (NSBitmapImageFileType)fileTypeForFile:(NSString *)file;

@end
