//
//  IUImageUtil.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 1..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUImageUtil.h"

@implementation IUImageUtil
// [image writeToFile:[NSURL fileURLWithPath:@"/some/path/image.png"]];
+ (NSString *)writeToFile:(NSImage *)image filePath:(NSString *)filePath fileName:(NSString *)fileName checkFileName:(BOOL)checkFileName
{

    
    
    NSBitmapImageRep *bitmapRep = nil;
    
    for (NSImageRep *imageRep in [image representations])
    {
        if ([imageRep isKindOfClass:[NSBitmapImageRep class]])
        {
            bitmapRep = (NSBitmapImageRep *)imageRep;
            break; // stop on first bitmap rep we find
        }
    }
    
    if (!bitmapRep)
    {
        bitmapRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    }
    
    NSString *extension = [[fileName lastPathComponent] pathExtension] ;
    NSString *currentName = fileName;

    if(extension.length == 0)
    {
        extension = @"png";
        currentName = [fileName stringByAppendingPathExtension:extension];

    }
    
    //Modify FileName!
    NSString *currentPath = [filePath stringByAppendingPathComponent:currentName];
    
    
    if (checkFileName == YES &&
        ([[NSFileManager defaultManager] fileExistsAtPath:currentPath] || fileName == nil)) { // check same fileName
        if(fileName ==nil) fileName = @"img";
        int i=0;
        while (1) {
            i++;
            fileName = [NSString stringWithFormat:@"%@_%d",fileName, i];
            currentName = [fileName stringByAppendingPathExtension:extension];
            currentPath = [filePath stringByAppendingPathComponent:currentName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:currentPath] == NO) {
                break;
            }
        }
        
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:currentPath];
    NSData *imageData = [bitmapRep representationUsingType:[self fileTypeForFile:[fileURL lastPathComponent]] properties:nil];
    [imageData writeToURL:fileURL atomically:YES];
    
    return currentName;
}



+ (NSBitmapImageFileType)fileTypeForFile:(NSString *)file
{
    NSString *extension = [[file pathExtension] lowercaseString];
    
    if ([extension isEqualToString:@"png"])
    {
        return NSPNGFileType;
    }
    else if ([extension isEqualToString:@"gif"])
    {
        return NSGIFFileType;
    }
    else if ([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"])
    {
        return NSJPEGFileType;
    }
    else
    {
        return NSTIFFFileType;
    }
}
@end
