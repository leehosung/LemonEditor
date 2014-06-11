//
//  LMResourceVC.m
//  IUEditor
//
//  Created by JD on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMResourceVC.h"
#import "IUResourceFile.h"

@interface LMResourceVC ()
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSCollectionView *collectionListV;
@property (weak) IBOutlet NSCollectionView *collectionIconV;
@property  NSArrayController *resourceArrayController;
@end

@implementation LMResourceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _resourceArrayController = [[NSArrayController alloc] init];
    }
    return self;
}

-(void)awakeFromNib{
    [_collectionListV bind:@"content" toObject:_resourceArrayController withKeyPath:@"arrangedObjects" options:nil];
    [_collectionIconV bind:@"content" toObject:_resourceArrayController withKeyPath:@"arrangedObjects" options:nil];
}

-(void)setManager:(IUResourceManager *)manager{
    _manager = manager;
    [_resourceArrayController bind:@"contentArray" toObject:manager withKeyPath:@"imageAndVideoFiles" options:nil];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard{
    NSUInteger index = [indexes firstIndex];
    IUResourceFile *node = [[_resourceArrayController arrangedObjects] objectAtIndex:index];
    if(node.type == IUResourceTypeImage){
        [pasteboard setString:node.name forType:kUTTypeIUImageResource];
        return YES;
    }
    
    else if (node.type == IUResourceTypeVideo){
        [JDUIUtil hudAlert:@"Only image is draggable" second:2];
    }
    else {
        assert(0);
    }

    return NO;
}

- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset{
    
    NSUInteger index = [indexes firstIndex];
    IUResourceFile *node = [[_resourceArrayController arrangedObjects] objectAtIndex:index];
    
    return node.image;
}


#pragma mark -
#pragma mark click BTN
- (IBAction)clickListBtn:(id)sender {
    [_tabView selectTabViewItemAtIndex:0];
}
- (IBAction)clickIconBtn:(id)sender {
    [_tabView selectTabViewItemAtIndex:1];
}

- (IBAction)clickAddResourceBtn:(id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setAllowsMultipleSelection:YES];
    
    if([openDlg runModal]){
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        
        // Loop through all the files and process them.
        for(int i = 0; i < [files count]; i++ )
        {
            NSURL* filePath = [files objectAtIndex:i];
            [_manager insertResourceWithContentOfPath:[filePath path]];
        }
    }
    
    [_resourceArrayController rearrangeObjects];
}
- (IBAction)clickRefreshBtn:(id)sender {
    [_resourceArrayController rearrangeObjects];
}

#pragma mark - 
#pragma mark addResource

- (void)addResource:(NSURL *)url type:(IUResourceType)type{
    [_manager insertResourceWithContentOfPath:[url relativePath]];
}


@end