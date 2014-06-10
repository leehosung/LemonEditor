//
//  JDFileUtil.h
//  Mango
//
//  Created by JD on 13. 2. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@interface JDFileUtil : NSObject <NSOpenSavePanelDelegate>{
    NSMutableDictionary *shellCommandDict;
}

+(JDFileUtil*)util;
+(BOOL)isFileImage:(NSURL*)url;
-(NSURL*)openFileByNSOpenPanel;
-(NSURL*)openFileByNSOpenPanel:(NSString*)title withExt:(NSArray*)extensions;
-(NSURL*)openDirectoryByNSOpenPanel:(NSString*)title;
-(NSURL*)openDirectoryByNSOpenPanel;


- (NSURL *)openSavePanelWithAllowFileTypes:(NSArray *)fileTypes withTitle:(NSString *)title;


+(NSInteger)execute:(NSString*)file atDirectory:(NSString*)runPath arguments:(NSArray*)arguments stdOut:(NSString**)stdOutLog stdErr:(NSString**)stdErrLog;


+(BOOL)touch:(NSString*)filePath;
+(void)rmDirPath:(NSString*)path;

+(BOOL)isImageFileExtension:(NSString*)extension;
+(BOOL)isMovieFileExtension:(NSString*)extension;

-(BOOL) appendToFile:(NSString*)path content:(NSString*)content;

-(NSError*)copyBundleItem:(NSString *)filename toDirectory:(NSString *)directoryPath;
- (BOOL) unzip:(NSString*)filePath toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory;
- (BOOL) unzipResource:(NSString*)resource toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory;
@end