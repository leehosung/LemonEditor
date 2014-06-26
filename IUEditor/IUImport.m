//
//  IURender.m
//  IUEditor
//
//  Created by jd on 4/24/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUImport.h"
#import "IUBox.h"
#import "IUClass.h"

@implementation IUImport

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.prototypeClass = [aDecoder decodeObjectForKey:@"_prototypeClass"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_prototypeClass forKey:@"_prototypeClass"];
}

- (id)copyWithZone:(NSZone *)zone{
    IUImport *iu = [super copyWithZone:zone];
    iu.prototypeClass = _prototypeClass;
    return iu;
}

- (void)setPrototypeClass:(IUClass *)prototypeClass{
    [self willChangeValueForKey:@"children"];
    [_prototypeClass removeReference:self];
    
    _prototypeClass = prototypeClass;
    _prototypeClass.delegate = self.delegate;
 
    [_prototypeClass addReference:self];
    if (self.delegate) {
        [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.parent.htmlID];
        for (IUBox *iu in [prototypeClass.allChildren arrayByAddingObject:prototypeClass]) {
            [self.delegate IUClassIdentifier:iu.cssID CSSUpdated:[iu cssForWidth:IUCSSMaxViewPortWidth isHover:NO] forWidth:IUCSSMaxViewPortWidth];
        }
    }
    [self didChangeValueForKey:@"children"];
}


- (void)setDelegate:(id<IUSourceDelegate>)delegate{
    [super setDelegate:delegate];
    _prototypeClass.delegate = delegate;
}

- (NSArray*)children{
    if (_prototypeClass == nil) {
        return [NSArray array];
    }
    return @[_prototypeClass];
}

- (BOOL)shouldAddIUByUserInput{
    return NO;
}


@end
