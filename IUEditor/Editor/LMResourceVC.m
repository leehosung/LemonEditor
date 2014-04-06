//
//  LMResourceVC.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMResourceVC.h"
#import "IUResourceNode.h"

@interface LMResourceVC ()
@property NSArray *contents;
@end

@implementation LMResourceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)setNode:(IUResourceGroupNode *)node{
    _node = node;
    [node addObserver:self forKeyPath:@"allChildren" options:NSKeyValueObservingOptionInitial context:nil];
}

-(void)allChildrenDidChange:(NSDictionary*)change{
    NSArray *array = self.node.allChildren;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(IUNode *node, NSDictionary *bindings) {
        if ([node isKindOfClass:[IUResourceNode class]]) {
            if ( ((IUResourceNode*)node).type == IUResourceNodeTypeImage) {
                return YES;
            }
        }
        return NO;
    }];
                              
    self.contents = [array filteredArrayUsingPredicate:predicate];
}

@end
