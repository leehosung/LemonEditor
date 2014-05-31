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
    [_fileNameComboBox bind:@"content" toObject:self withKeyPath:@"resourceManager.videoNames" options:IUBindingDictNotRaisesApplicable];
    [_controlBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableControl"] options:IUBindingDictNotRaisesApplicable];
    [_loopBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableLoop"] options:IUBindingDictNotRaisesApplicable];
    [_autoplayBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableAutoPlay"] options:IUBindingDictNotRaisesApplicable];
    [_coverBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"cover"] options:IUBindingDictNotRaisesApplicable];
    [_muteBtn bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableMute"] options:IUBindingDictNotRaisesApplicable];
    
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
        NSURL *moviefileURL;
        if ([videoFileName isHTTPURL]) {
            moviefileURL = [NSURL URLWithString:videoFileName];
            [self setValue:moviefileURL.absoluteString forKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"] ];
        }
        else{
            assert(0);
            //FIXME: 모듈 이동하여야 함
            // thumbnail 관리, video thumbnail 요청 등은
            // IUMovie 쪽이 아니라 ResourceManager 에서 전담해야함
            
            NSString * moviefilePath = [self.resourceManager absolutePathForResource:videoFileName];
            moviefileURL = [NSURL fileURLWithPath:moviefilePath];
            
            NSString *relativePath = [self.resourceManager relativePathForResource:videoFileName];
            [self setValue:relativePath forKeyPath:[_controller keyPathFromControllerToProperty:@"videoPath"] ];

        }
        NSImage *thumbnail = [self thumbnailOfVideo:moviefileURL];
        
        if(thumbnail){
            assert(0);
            /*
            //save thumbnail
            NSString *videoname = [[videoFileName lastPathComponent] stringByDeletingPathExtension];
            NSString *thumbFileName = [[NSString alloc] initWithFormat:@"%@_thumbnail.png", videoname];
            
            IUResourceGroup *imageGroupNode = [self.resourceManager imageNode];
            NSString *imageAbsolutePath = [NSString stringWithFormat:@"%@/", imageGroupNode.absolutePath];
            thumbFileName = [IUImageUtil writeToFile:thumbnail filePath:imageAbsolutePath fileName:thumbFileName checkFileName:NO];
            
            
            //save image resourceNode
            NSString *thumbImgPath = [NSString stringWithFormat:@"%@%@", imageAbsolutePath, thumbFileName];
            [_resourceManager insertResourceWithContentOfPath:thumbImgPath type:IUResourceTypeImage];
            
            
            
            NSString *posterPath = [NSString stringWithFormat:@"%@/%@", imageGroupNode.relativePath, thumbFileName];
            [self setValue:posterPath forKeyPath:[_controller keyPathFromControllerToProperty:@"posterPath"] ];
            
            
            [self setValue:@(thumbnail.size.width) forKeyPath:[self CSSBindingPath:IUCSSTagWidth]];
            [self setValue:@(thumbnail.size.height) forKeyPath:[self CSSBindingPath:IUCSSTagHeight]];
            
            */
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
