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
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption]];
    
    NSDictionary *updateBinding = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:YES]]
                                   forKeys:@[NSContinuouslyUpdatesValueBindingOption]];

    [_altTextTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"altText"] options:updateBinding];
    [_fileNameComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.videoNames" options:bindingOption];
    [_controlBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableControl"] options:bindingOption];
    [_loopBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableLoop"] options:bindingOption];
    [_autoplayBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableAutoPlay"] options:bindingOption];
    [_coverBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"cover"] options:bindingOption];
    [_muteBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableMute"] options:bindingOption];
    
    NSString *videoPath =[self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"]];
    if(videoPath){
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

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}

- (IBAction)clickFileNameComboBox:(id)sender {
   NSString *videoFileName =  [[self.fileNameComboBox selectedCell] stringValue];
    gettingInfo = YES;
    if(videoFileName && videoFileName.length > 0){
        
        //get thumbnail from video file
        NSURL *movefileURL;
        if ([videoFileName isHTTPURL]) {
            movefileURL = [NSURL URLWithString:videoFileName];
        }
        else{
            NSString * moviefilePath = [self.resourceManager absolutePathForResource:videoFileName];
            movefileURL = [NSURL fileURLWithPath:moviefilePath];
        }
        NSImage *thumbnail = [self thumbnailOfVideo:movefileURL];
        
        if(thumbnail){
            //save thumbnail
            NSString *videoname = [[videoFileName lastPathComponent] stringByDeletingPathExtension];
            NSString *thumbFileName = [[NSString alloc] initWithFormat:@"%@_thumbnail.png", videoname];
            
            IUResourceGroupNode *imageGroupNode = [self.resourceManager imageNode];
            NSString *imageAbsolutePath = [NSString stringWithFormat:@"%@/", imageGroupNode.absolutePath];
            thumbFileName = [IUImageUtil writeToFile:thumbnail filePath:imageAbsolutePath fileName:thumbFileName checkFileName:NO];
            
            
            //save image resourceNode
            //TODO: resource nodes (이미 존재했을때 안넣을것)
            IUResourceNode *thumbnailNode = [[IUResourceNode alloc] initWithName:thumbFileName type:IUResourceTypeImage];
            NSString *thumbImgPath = [NSString stringWithFormat:@"%@%@", imageAbsolutePath, thumbFileName];
            if([imageGroupNode containName:thumbFileName] == NO){
                [imageGroupNode addResourceNode:thumbnailNode path:thumbImgPath];
            }
            
            
            IUResourceGroupNode *videoGroupNode = [self.resourceManager videoNode];
            NSString *posterPath = [NSString stringWithFormat:@"%@/%@", imageGroupNode.relativePath, thumbFileName];
            [self setValue:posterPath forKeyPath:[_controller keyPathFromControllerToProperty:@"posterPath"] ];
            
            NSString *videoPath = [NSString stringWithFormat:@"%@/%@", videoGroupNode.relativePath, videoFileName];
            [self setValue:videoPath forKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"] ];
            
            [self setValue:@(thumbnail.size.width) forKeyPath:[self CSSBindingPath:IUCSSTagWidth]];
            [self setValue:@(thumbnail.size.height) forKeyPath:[self CSSBindingPath:IUCSSTagHeight]];
            
            
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
