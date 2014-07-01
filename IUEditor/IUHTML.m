//
//  IUHTML.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 15..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUHTML.h"

@implementation IUHTML

-(id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        _innerHTML = @"<div>test IUHTML</div>";
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUHTML class] properties]];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeFromObject:self withProperties:[[IUHTML class] properties]];

}

- (id)copyWithZone:(NSZone *)zone{
    IUHTML *html = [super copyWithZone:zone];
    if(html){
        html.innerHTML = [_innerHTML copy];
    }
    return html;
}

-(BOOL)shouldAddIUByUserInput{
    return NO;
}

-(BOOL)hasInnerHTML{
    if(_innerHTML){
        return YES;
    }
    return NO;
}

-(void)setInnerHTML:(NSString *)aInnerHTML{
    _innerHTML = aInnerHTML;
    JDInfoLog(@"%@", aInnerHTML);
    [self updateHTML];
}

@end
