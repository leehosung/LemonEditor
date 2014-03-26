//
//  LMWidgetLibraryVC.m
//  IUEditor
//
//  Created by JD on 3/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWidgetLibraryVC.h"
#import "LMGeneralObject.h"

@interface LMWidgetLibraryVC ()

@property (weak) IBOutlet NSCollectionView *collectionV;
@end

@implementation LMWidgetLibraryVC{
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)setWidgetProperties:(NSArray*)array{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        LMGeneralObject *obj = [[LMGeneralObject alloc] init];
        obj.title = dict[@"className"];
        obj.image = [NSImage imageNamed:dict[@"classImage"]];
        [temp addObject:obj];
    }
    [self willChangeValueForKey:@"widgets"];
    _widgets = [NSArray arrayWithArray:temp];
    [self didChangeValueForKey:@"widgets"];
}

@end
