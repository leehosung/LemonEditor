
//
//  LMPropertyIUMovieVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUMovieVC.h"
#import <AVFoundation/AVFoundation.h>
#import "IUImageUtil.h"


@interface LMPropertyIUMovieVC ()
@property (weak) IBOutlet NSComboBox *fileNameComboBox;
@property (weak) IBOutlet NSTextField *altTextTF;

@property (weak) IBOutlet NSButton *controlBtn;
@property (weak) IBOutlet NSButton *loopBtn;
@property (weak) IBOutlet NSButton *autoplayBtn;
@property (weak) IBOutlet NSButton *coverBtn;
@property (weak) IBOutlet NSButton *muteBtn;

@end

@implementation LMPropertyIUMovieVC{
    BOOL gettingInfo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_altTextTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"altText"] options:@{NSContinuouslyUpdatesValueBindingOption: @(YES)}];
    [_fileNameComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.videoFiles" options:IUBindingDictNotRaisesApplicable];
    [_controlBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableControl"] options:IUBindingDictNotRaisesApplicable];
    [_loopBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableLoop"] options:IUBindingDictNotRaisesApplicable];
    [_autoplayBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableAutoPlay"] options:IUBindingDictNotRaisesApplicable];
    [_coverBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"cover"] options:IUBindingDictNotRaisesApplicable];
    [_muteBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableMute"] options:IUBindingDictNotRaisesApplicable];
    
    _fileNameComboBox.delegate = self;
    
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:@"selection"];


}

- (void)selectionContextDidChange:(NSDictionary *)change{
    id videoPath = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"]];
    
    if(videoPath == nil || videoPath == NSNoSelectionMarker){
        [_fileNameComboBox setStringValue:@""];
    }
    else if(videoPath){
        NSString *videoFileName = [videoPath lastPathComponent];
        NSInteger index = [_fileNameComboBox indexOfItemWithObjectValue:videoFileName];
        if(index >= 0){
            [_fileNameComboBox selectItemAtIndex:index];
        }
        else{
            [_fileNameComboBox setStringValue:videoPath];
        }
    }
}


- (void)controlTextDidChange:(NSNotification *)obj{
    NSComboBox *currentComboBox = obj.object;
    if([currentComboBox isEqualTo:_fileNameComboBox]){
        [self updateVideoFileName:[_fileNameComboBox stringValue]];
    }
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSComboBox *currentComboBox = notification.object;
    if([currentComboBox isEqualTo:_fileNameComboBox]){
        [self updateVideoFileName:[_fileNameComboBox objectValueOfSelectedItem]];
    }
}
- (void)updateVideoFileName:(NSString *)videoFileName{
    //FIXME: check video file name if not accurate
    
    gettingInfo = YES;
    if(videoFileName.length == 0){
        [self setValue:nil forKeyPath:[_controller keyPathFromControllerToProperty:@"posterPath"] ];
        [self setValue:nil forKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"] ];
    }
    else if(videoFileName && videoFileName.length > 0){
        
        //get thumbnail from video file
        NSURL *moviefileURL;
        if ([videoFileName isHTTPURL]) {
            moviefileURL = [NSURL URLWithString:videoFileName];
            [self setValue:moviefileURL.absoluteString forKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"] ];
        }
        else{
            IUResourceFile *videoFile = [self.resourceManager resourceFileWithName:videoFileName];
            if (videoFile == nil) {
                [self setValue:nil forKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"] ];
                return;
            }
            moviefileURL = [NSURL fileURLWithPath:videoFile.absolutePath];
            
            NSString *relativePath = videoFile.relativePath;
            [self setValue:relativePath forKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"] ];

        }
        NSImage *thumbnail = [self thumbnailOfVideo:moviefileURL];
        
        if(thumbnail){
            //save thumbnail
            NSString *videoname = [[videoFileName lastPathComponent] stringByDeletingPathExtension];
            NSString *thumbFileName = [[NSString alloc] initWithFormat:@"%@_thumbnail.png", videoname];
            
//            NSString *imageAbsolutePath = [NSString stringWithFormat:@"%@/", [self.resourceManager imageDirectory]];
            NSString *imageTmpAbsolutePath = NSTemporaryDirectory();

            thumbFileName = [IUImageUtil writeToFile:thumbnail filePath:imageTmpAbsolutePath fileName:thumbFileName checkFileName:NO];
            
            
            IUResourceFile *thumbFile = [_resourceManager resourceFileWithName:thumbFileName];
            if(thumbFile == nil){
                //save image resourceNode
                thumbFile = [_resourceManager insertResourceWithContentOfPath:[imageTmpAbsolutePath stringByAppendingPathComponent:thumbFileName]];
            }
            else{
                //overwirte image
                thumbFile = [_resourceManager overwriteResourceWithContentOfPath:[imageTmpAbsolutePath stringByAppendingPathComponent:thumbFileName]];
                
            }
            [self setValue:thumbFile.relativePath forKeyPath:[_controller keyPathFromControllerToProperty:@"posterPath"] ];
            
            
            [self setValue:@(thumbnail.size.width) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidth]];
            [self setValue:@(thumbnail.size.height) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeight]];
        }
        
    }
    
}


-(NSImage *)thumbnailOfVideo:(NSURL *)url{
    
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    CMTime actualTime;
    NSImage *thumbImg;
    
    CGImageRef halfWayImage = [generator copyCGImageAtTime:thumbTime actualTime:&actualTime error:nil];
    if(halfWayImage != NULL){
        thumbImg =[[NSImage alloc] initWithCGImage:halfWayImage size:NSZeroSize];
        CGImageRelease(halfWayImage);
    }
    
    
    
    return thumbImg;
    
}

@end
