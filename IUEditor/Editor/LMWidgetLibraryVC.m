//
//  LMWidgetLibraryVC.m
//  IUEditor
//
//  Created by JD on 3/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWidgetLibraryVC.h"
#import "LMGeneralObject.h"
#import "IUObj.h"

@interface LMWidgetLibraryVC ()

@property (weak) IBOutlet NSCollectionView *collectionV;
@end

@implementation LMWidgetLibraryVC{
    NSArray *widgetProperties;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard{
    NSUInteger index = [indexes firstIndex];
    LMGeneralObject *object = [[collectionView itemAtIndex:index] representedObject];
    NSString *className = object.title;
    NSDictionary *setting = object.dict;
    
    IUObj *obj = [[NSClassFromString(className) alloc] initWithProject:_project setting:setting];
    
    Class class = NSClassFromString(className);
    obj.htmlID = [self.project requestNewID:class];
    obj.name = obj.htmlID;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [pasteboard setData:data forType:@"IUObj"];
    return YES;
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
