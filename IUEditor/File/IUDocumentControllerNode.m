//
//  IUFileNode.m
//  IUEditor
//
//  Created by JD on 3/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocumentControllerNode.h"
#import "IUPage.h"

@interface IUDocumentControllerNode()
-(IUDocument*)representedObject;
@end


@implementation IUDocumentControllerNode{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.representedObject forKey:@"representedObject"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    id representedObject = [aDecoder decodeObjectForKey:@"representedObject"];
    self = [super initWithRepresentedObject:representedObject];
    if (self) {
    }
    return self;
}

-(id)initWithDocument:(IUDocument*)document name:(NSString*)name{
    IUDocumentController *documentController = [[IUDocumentController alloc] initWithDocument:document];
    self = [super initWithRepresentedObject:document];
    if (self) {
    }
    return self;
}


-(IUDocument*)representedObject{
    return [super representedObject];
}

@end