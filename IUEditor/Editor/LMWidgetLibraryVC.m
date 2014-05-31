//
//  LMWidgetLibraryVC.m
//  IUEditor
//
//  Created by JD on 3/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMWidgetLibraryVC.h"
#import "LMGeneralObject.h"
#import "IUBox.h"
#import "LMWC.h"

@interface LMWidgetLibraryVC ()

@property (weak) IBOutlet NSTabView *collectionTabV;

@property (weak) IBOutlet NSCollectionView *primaryCollectionV;
@property (weak) IBOutlet NSCollectionView *secondaryCollectionV;

@property (weak) IBOutlet NSTabView *primaryTabView;
@property (weak) IBOutlet NSTabView *secondaryTabView;

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
    assert(_project);
    NSUInteger index = [indexes firstIndex];
    LMGeneralObject *object = [[collectionView itemAtIndex:index] representedObject];
    NSString *className = object.title;
    
    IUBox *obj = [[NSClassFromString(className) alloc] initWithProject:_project options:nil];
    if (obj == nil) {
        assert(0);
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [pasteboard setData:data forType:kUTTypeIUType];
    
    /* note  ----------------------------------------------------
    /  please check obj.retainCount is <1> at current point     /
    / ----------------------------------------------------------*/

    
    LMWC *lmWC = [NSApp mainWindow].windowController;
    lmWC.pastedNewIU = obj;
    
    return YES;
}


- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset{
    
    NSUInteger index = [indexes firstIndex];
    LMGeneralObject *object = [[collectionView itemAtIndex:index] representedObject];

    return object.image;
}


-(void)setWidgetProperties:(NSArray*)array{
    NSMutableArray *primaryArray = [NSMutableArray array];
    NSMutableArray *secondaryArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        
        BOOL isWidget = [dict[@"isWidget"] boolValue];
        if (isWidget){
            LMGeneralObject *obj = [[LMGeneralObject alloc] init];
            obj.title = dict[@"className"];
            NSString *imageName = dict[@"classImage"];
            obj.image = [NSImage imageNamed:imageName];
            obj.shortDesc = dict[@"shortDesc"];
            obj.longDesc = dict[@"longDesc"];
            int widgetClass = [dict[@"widgetClass"] intValue];
            if(widgetClass == WidgetClassTypePrimary){
                [primaryArray addObject:obj];
            }
            else if(widgetClass == WidgetClassTypeSecondary){
                [secondaryArray addObject:obj];
            }
        }
    }
    [self willChangeValueForKey:@"primaryWidgets"];
    _primaryWidgets = primaryArray;
    [self didChangeValueForKey:@"primaryWidgets"];

    [self willChangeValueForKey:@"secondaryWidgets"];
    _secondaryWidgets = secondaryArray;
    [self didChangeValueForKey:@"secondaryWidgets"];
}

- (IBAction)clickWidgetTabMatrix:(id)sender {
    NSInteger selectedIndex = [sender selectedRow];
    [_collectionTabV selectTabViewItemAtIndex:selectedIndex];
    
}

#pragma mark -
#pragma mark widget list - icon 

- (IBAction)clickPrimaryList:(id)sender {
    [_primaryTabView selectTabViewItemAtIndex:0];
}
- (IBAction)clickPrimaryIcon:(id)sender {
    [_primaryTabView selectTabViewItemAtIndex:1];
}

- (IBAction)clickSecondaryList:(id)sender {
    [_secondaryTabView selectTabViewItemAtIndex:0];
}
- (IBAction)clickSecondaryIcon:(id)sender {
    [_secondaryTabView selectTabViewItemAtIndex:1];
}

@end
