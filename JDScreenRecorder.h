//
//  LMScreenRecorder.h
//  IUEditor
//
//  Created by jd on 7/4/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JDScreenRecorder : NSObject <AVCaptureFileOutputRecordingDelegate> {
@private
    AVCaptureSession *mSession;
    AVCaptureMovieFileOutput *mMovieFileOutput;
    NSTimer *mTimer;
}

-(void)startRecord:(NSURL *)destPath;
-(void)finishRecord;

@end
