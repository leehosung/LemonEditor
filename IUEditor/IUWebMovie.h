//
//  IUWebMovie.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUHTML.h"

@interface IUWebMovie : IUHTML

@property BOOL      thumbnail;
@property  NSString *thumbnailPath;
@property (nonatomic) NSString *webMovieSource;

@end
