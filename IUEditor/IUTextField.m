//
//  IUTextField.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUTextField.h"

@implementation IUTextField
-(NSMutableDictionary*)HTMLAttributes{
    NSMutableDictionary *dict = [super HTMLAttributes];
    if (_formName) {
        [dict setObject:_formName forKey:@"name"];
    }
    return dict;
}
@end
