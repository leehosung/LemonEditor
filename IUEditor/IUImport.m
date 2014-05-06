//
//  IURender.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUImport.h"
#import "IUBox.h"


@implementation IUImport

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _prototypeClass = [aDecoder decodeObjectForKey:@"_prototypeClass"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_prototypeClass forKey:@"_prototypeClass"];
}

- (void)setPrototypeClass:(IUClass *)prototypeClass{
    [_m_children removeObject:_prototypeClass];
//    [self.delegate IURemoved:_prototypeClass.htmlID];

    [_m_children addObject:prototypeClass];
    _prototypeClass = prototypeClass;
    if (_prototypeClass) {
        [self.delegate IU:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
        for (IUBox *iu in [prototypeClass.allChildren arrayByAddingObject:prototypeClass]) {
            [self.delegate IU:[self.htmlID stringByAppendingFormat:@"__%@", iu.htmlID] CSSUpdated:[iu cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
        }
    }
}

-(BOOL)shouldEditText{
    return NO;
}



@end
