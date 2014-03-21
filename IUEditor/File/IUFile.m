//
//  IUFileNode.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUFile.h"
#import "IUPage.h"

@interface IUFile()
-(IUDocument*)representedObject;
@end


@implementation IUFile{
    
}

-(id)initAsPageWithName:(NSString*)name{
    IUPage *page = [[IUPage alloc] initWithDefaultSetting];

    self = [super initWithRepresentedObject:page];
    if (self) {
    }
    return self;
}

-(void)fetch{
    [self.representedObject fetch];
}

-(IUDocument*)representedObject{
    return [super representedObject];
}

@end
