//
//  IUObj.m
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUObj.h"
#import "NSObject+JDExtension.h"
#import "NSCoder+JDExtension.h"

@implementation IUObj{
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [aDecoder decodeToObject:self withProperties:[[IUObj class] properties]];
        _css = [aDecoder decodeObjectForKey:@"css"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeFromObject:self withProperties:[[IUObj class] properties]];
    [aCoder encodeObject:self.css forKey:@"css"];
}

-(id)initWithDefaultSetting{
    self = [super init];{
        _children = [NSMutableArray array];
        _css = [[IUCSS alloc] init];
    }
    return self;
}

-(NSString*) outputHTML{
    
}
-(NSString*) outputCSS{
    
}

-(NSString*) editorHTML{
    
}
-(NSString*) editorCSS{
    
}


@end
