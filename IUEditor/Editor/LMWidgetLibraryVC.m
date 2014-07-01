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
@property (weak) IBOutlet NSCollectionView *PGCollectionV;

@property (weak) IBOutlet NSTabView *primaryTabView;
@property (weak) IBOutlet NSTabView *secondaryTabView;
@property (weak) IBOutlet NSTabView *PGTabView;

@property (weak) IBOutlet NSButton *primaryListB;
@property (weak) IBOutlet NSButton *primaryIconB;
@property (weak) IBOutlet NSButton *secondaryListB;
@property (weak) IBOutlet NSButton *secondaryIconB;
@property (weak) IBOutlet NSButtonCell *PGListB;
@property (weak) IBOutlet NSButton *PGIconB;

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
    [_project.identifierManager resetUnconfirmedIUs];
    NSUInteger index = [indexes firstIndex];
    LMGeneralObject *object = [[collectionView itemAtIndex:index] representedObject];
    NSString *className = object.title;
    
    IUBox *obj = [[NSClassFromString(className) alloc] initWithProject:_project options:nil];
    if (obj == nil) {
    //    assert(0);
        NSLog(@"objISNil");
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [pasteboard setData:data forType:kUTTypeIUType];
    
    /* note  ----------------------------------------------------
    /  please check obj.retainCount is <1> at current point     /
    / ----------------------------------------------------------*/

    
    LMWC *lmWC = [NSApp mainWindow].windowController;
    lmWC.pastedNewIU = obj;
    JDInfoLog([obj description], nil);
    
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
    NSMutableArray *PGArray = [NSMutableArray array];
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
            else if(widgetClass == WidgetClassTypePG){
                [PGArray addObject:obj];
            }
        }
    }
    [self willChangeValueForKey:@"primaryWidgets"];
    _primaryWidgets = primaryArray;
    [self didChangeValueForKey:@"primaryWidgets"];

    [self willChangeValueForKey:@"secondaryWidgets"];
    _secondaryWidgets = secondaryArray;
    [self didChangeValueForKey:@"secondaryWidgets"];
    
    [self willChangeValueForKey:@"PGWidgets"];
    _PGWidgets = PGArray;
    [self didChangeValueForKey:@"PGWidgets"];
}

- (IBAction)clickWidgetTabMatrix:(id)sender {
    NSInteger selectedIndex = [sender selectedRow];
    [_collectionTabV selectTabViewItemAtIndex:selectedIndex];
    
}

#pragma mark -
#pragma mark widget list - icon 

- (IBAction)clickPrimaryList:(id)sender {
    [_primaryTabView selectTabViewItemAtIndex:0];
    [_primaryListB setEnabled:NO];
    [_primaryIconB setEnabled:YES];
}
- (IBAction)clickPrimaryIcon:(id)sender {
    [_primaryTabView selectTabViewItemAtIndex:1];
    [_primaryIconB setEnabled:NO];
    [_primaryListB setEnabled:YES];
}

- (IBAction)clickSecondaryList:(id)sender {
    [_secondaryTabView selectTabViewItemAtIndex:0];
    [_secondaryListB setEnabled:NO];
    [_secondaryIconB setEnabled:YES];
}
- (IBAction)clickSecondaryIcon:(id)sender {
    [_secondaryTabView selectTabViewItemAtIndex:1];
    [_secondaryListB setEnabled:YES];
    [_secondaryIconB setEnabled:NO];
}

- (IBAction)clickPGList:(id)sender {
    [_PGTabView selectTabViewItemAtIndex:0];
    [_PGListB setEnabled:NO];
    [_PGIconB setEnabled:YES];

}
- (IBAction)clickPGIcon:(id)sender {
    [_PGTabView selectTabViewItemAtIndex:1];
    [_PGListB setEnabled:YES];
    [_PGIconB setEnabled:NO];
}
@end
