//
//  IUMovie.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 21..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUBox.h"

@interface IUMovie : IUBox

@property (nonatomic) NSString *videoPath;
@property NSString  *posterPath;
@property NSString  *altText;

@property BOOL enableControl, enableLoop, enableAutoPlay, enableMute;
@property BOOL cover;

@end
