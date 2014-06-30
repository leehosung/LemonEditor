//
//  PGTextField.h
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"

typedef enum{
    IUTextFieldTypeDefault,
    IUTextFieldTypePassword,
}IUTextFieldType;

@interface PGTextField : IUBox

@property (nonatomic) NSString  *inputName;
@property (nonatomic) NSString  *placeholder;
@property (nonatomic) NSString  *inputValue;
@property (nonatomic) IUTextFieldType type;

@end
