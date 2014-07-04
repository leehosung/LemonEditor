//
//  LMScreenRecorder.m
//  IUEditor
//
//  Created by jd on 7/4/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "JDScreenRecorder.h"

@implementation JDScreenRecorder
-(void)startRecord:(NSURL *)destPath
{
    // Create a capture session
    mSession = [[AVCaptureSession alloc] init];
    
    // Set the session preset as you wish
    mSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    // If you're on a multi-display system and you want to capture a secondary display,
    // you can call CGGetActiveDisplayList() to get the list of all active displays.
    // For this example, we just specify the main display.
    CGDirectDisplayID displayId = kCGDirectMainDisplay;
    
    // Create a ScreenInput with the display and add it to the session
    AVCaptureScreenInput *input = [[AVCaptureScreenInput alloc] initWithDisplayID:displayId];
    if (!input) {
        mSession = nil;
        return;
    }
    if ([mSession canAddInput:input])
        [mSession addInput:input];
    
    // Create a MovieFileOutput and add it to the session
    mMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([mSession canAddOutput:mMovieFileOutput])
        [mSession addOutput:mMovieFileOutput];
    
    // Start running the session
    [mSession startRunning];
    
    // Delete any existing movie file first
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destPath path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[destPath path] error:&err])
        {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
    
    // Start recording to the destination movie file
    // The destination path is assumed to end with ".mov", for example, @"/users/master/desktop/capture.mov"
    // Set the recording delegate to self
    [mMovieFileOutput startRecordingToOutputFileURL:destPath recordingDelegate:self];
}

-(void)finishRecord
{
    // Stop recording to the destination movie file
    [mMovieFileOutput stopRecording];
    mTimer = nil;
}

// AVCaptureFileOutputRecordingDelegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (error) {
        NSLog(@"Did finish recording to %@ due to error %@", [outputFileURL description], [error description]);
    }
    
    // Stop running the session
    [mSession stopRunning];
    
    // Release the session
    mSession = nil;
}
@end
