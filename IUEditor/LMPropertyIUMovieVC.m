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
    
    [_fileNameComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.videoNames" options:bindingOption];
    [_altTextTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"altText"] options:nil];
    [_controlBtn bind:@"state" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableControl"] options:bindingOption];
    [_loopBtn bind:@"state" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableLoop"] options:bindingOption];
    [_autoplayBtn bind:@"state" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableAutoPlay"] options:bindingOption];
    [_coverBtn bind:@"state" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"cover"] options:bindingOption];
    [_muteBtn bind:@"state" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableMute"] options:bindingOption];

}

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}

- (IBAction)clickFileNameComboBox:(id)sender {
   NSString *videoFileName =  [[self.fileNameComboBox selectedCell] stringValue];
    gettingInfo = YES;
    if(videoFileName){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void){
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
                [imageGroupNode addResourceNode:thumbnailNode path:thumbImgPath];
                
                
                IUResourceGroupNode *videoGroupNode = [self.resourceManager videoNode];
                NSString *videoPath = [NSString stringWithFormat:@"%@/%@", videoGroupNode.relativePath, videoFileName];
                [[_controller keyPathFromControllerToProperty:@"videoPath"] setValue:videoPath];
                NSString *posterPath = [NSString stringWithFormat:@"%@/%@", imageGroupNode.relativePath, thumbFileName];
                [[_controller keyPathFromControllerToProperty:@"posterPath"] setValue:posterPath];
                
                [[self CSSBindingPath:IUCSSTagWidth] setValue:@(thumbnail.size.width)];
                [[self CSSBindingPath:IUCSSTagHeight] setValue:@(thumbnail.size.height)];
                
            }
        });
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
