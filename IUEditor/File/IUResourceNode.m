//
//  IUResourceNode.m
//  IUEditor
//
//  Created by JD on 3/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUResourceNode.h"
#import "IUResourceGroupNode.h"
#import "IUProject.h"

@implementation IUResourceNode{
    IUResourceType _type;
}


-(id)initWithName:(NSString*)name type:(IUResourceType)type{
    self = [super init];
    self.name = name;
    _type = type;
        
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
    _type = [aDecoder decodeInt32ForKey:@"type"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt32:_type forKey:@"type"];
}

-(NSString*)absolutePath{
    if ([self.parent isKindOfClass:[IUProject class]]) {
        return [((IUProject*)self.parent).absoluteDirectory stringByAppendingPathComponent:self.name];
    }
    return [self.parent.absolutePath stringByAppendingPathComponent:self.name];
}

-(NSString*)relativePath{
    return [self.parent.relativePath stringByAppendingPathComponent:self.name];
}


-(NSImage*)image{
    NSImage *image;
    switch (_type) {
        case IUResourceTypeImage:
            image = [[NSImage alloc] initWithContentsOfFile:self.absolutePath];
            break;
        case IUResourceTypeVideo:
            image = [NSImage imageNamed:@"tool_movie"];
        default:
            break;
    }

    
    return image;
}


@end
