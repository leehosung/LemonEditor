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
@property (weak) IBOutlet NSCollectionView *collectionV;
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

-(void)setManager:(IUResourceManager *)manager{
    _manager = manager;
    [_collectionV bind:@"content" toObject:manager withKeyPath:@"imageResourceNodes" options:nil];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard{
    NSUInteger index = [indexes firstIndex];
    IUResourceNode *node = [_manager.imageResourceNodes objectAtIndex:index];
    
    [pasteboard setString:node.name forType:kUTTypeIUImageResource];
    return YES;
}

@end