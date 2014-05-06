//
//  IUHTML.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 15..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUHTML.h"

@implementation IUHTML

-(id)initWithManager:(IUIdentifierManager*)manager option:(NSDictionary *)option{
    self = [super initWithManager:manager option:option];
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

-(BOOL)shouldAddIU{
    return NO;
}

-(BOOL)hasInnerHTML{
    if(_innerHTML){
        return YES;
    }
    return NO;
}
-(BOOL)shouldEditText{
    return NO;
}
-(void)setInnerHTML:(NSString *)aInnerHTML{
    _innerHTML = aInnerHTML;
    JDInfoLog(@"%@", aInnerHTML);

    [self.delegate IUHTMLIdentifier:self.htmlID HTML:self.html withParentID:self.htmlID];
}

@end
