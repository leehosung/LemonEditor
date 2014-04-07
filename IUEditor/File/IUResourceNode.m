//
//  IUResourceNode.m
//  IUEditor
//
//  Created by JD on 3/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceNode.h"
#import "IUResourceGroupNode.h"

@implementation IUResourceNode{
    NSImage *_image;
    NSString *_UTI;
    IUResourceType _type;
}


-(id)initWithName:(NSString*)name type:(IUResourceType)type{
    self = [super init];
    self.name = name;
    _type = type;
    
    CFStringRef UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,                                                                       (__bridge CFStringRef)[self.name pathExtension],NULL);
    _UTI = (NSString *)CFBridgingRelease(UTIRef);
    
    return self;
}



-(id)init{
    assert(0);
    return nil;
}

-(IUResourceType)type{
    return _type;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _image = [aDecoder decodeObjectForKey:@"image"];
    _UTI = [aDecoder decodeObjectForKey:@"UTI"];
    _type = [aDecoder decodeInt32ForKey:@"type"];
    self.parent = [aDecoder decodeObjectForKey:@"parent"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_image forKey:@"image"];
    [aCoder encodeObject:_UTI forKey:@"UTI"];
    [aCoder encodeInt32:_type forKey:@"type"];
    [aCoder encodeObject:self.parent forKey:@"parent"];
}

-(NSString*)absolutePath{
    return [self.parent.absolutePath stringByAppendingPathComponent:self.name];
}

-(NSString*)relativePath{
    return [self.parent.relativePath stringByAppendingPathComponent:self.name];
}


-(NSImage*)image{
    return _image;
}

-(NSString*)UTI{
    return _UTI;
}



@end
