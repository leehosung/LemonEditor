//
//  LMStartPreviewWC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 30..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMStartPreviewWC.h"

static LMStartPreviewWC *gStartPreviewWindow = nil;

@interface LMStartPreviewWC ()

@property (weak) IBOutlet NSScrollView *imageScrollView;

@property (weak) IBOutlet NSTextField *nameTF;
@property (weak) IBOutlet NSTextField *descTF;
@property (weak) IBOutlet NSTextField *projectTypeTF;
@property (weak) IBOutlet NSTextField *sizeTF;
@property (weak) IBOutlet NSTextField *featureTF;

@property (weak) IBOutlet NSButton *prevBtn;
@property (weak) IBOutlet NSButton *nextBtn;
@property (weak) IBOutlet NSTextField *imageCountTF;

@property NSImageView *imageView;

@end

@implementation LMStartPreviewWC{
    NSInteger currentCount;
    LMStartItem *currentItem;

}

+ (LMStartPreviewWC *)sharedStartPreviewWindow{
    if(gStartPreviewWindow ==  nil){
        gStartPreviewWindow = [[LMStartPreviewWC alloc] initWithWindowNibName:@"LMStartPreviewWC"];
    }
    
    return gStartPreviewWindow;
}

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [_imageScrollView setDocumentView:_imageView];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self updateWindowValue];
}

- (void)awakeFromNib{

}

- (void)updateWindowValue{
    if(currentItem){
        
        [_nameTF setStringValue:currentItem.name];
        [_descTF setStringValue:currentItem.desc];
        
        switch (currentItem.projectType) {
            case IUProjectTypeDefault:
                [_projectTypeTF setStringValue:@"Default"];
                break;
            case IUProjectTypeDjango:
                [_projectTypeTF setStringValue:@"Django"];
                break;
            case IUProjectTypePresentation:
                [_projectTypeTF setStringValue:@"Presentation"];
                break;
            default:
                NSAssert(0, @"");
                break;
        }
        
        [_sizeTF setStringValue:currentItem.mqSizes];
        [_featureTF setStringValue:currentItem.feature];
        
        [self updateImageValue];
    }
}


- (BOOL)loadStartItem:(LMStartItem *)item{
    if(item){
        currentItem = item;
        currentCount = 1;
        
        [self updateWindowValue];
        return YES;
    }
    return NO;

}
- (IBAction)clickNextImageBtn:(id)sender {
    if(currentCount < currentItem.previewImageArray.count){
        currentCount++;
    }
    [self updateImageValue];
}

- (IBAction)clickPrevImageBtn:(id)sender {
    if(currentCount > 1){
        currentCount--;
    }
    [self updateImageValue];
    
}

- (void)showWindow:(id)sender{
    [super showWindow:sender];
    
    [[_imageScrollView contentView] scrollToPoint:NSMakePoint(0, [[_imageView image] size].height)];
    [_imageScrollView reflectScrolledClipView:[_imageScrollView contentView]];

}

- (void)updateImageValue{
    
    if(currentItem.previewImageArray.count > 0){
        [_imageCountTF setStringValue:[NSString stringWithFormat:@"%ld/%ld", currentCount, currentItem.previewImageArray.count]];
        NSImage *image = [NSImage imageNamed:currentItem.previewImageArray[currentCount-1]];
        [_imageView setImage:image];
    }

}





@end
