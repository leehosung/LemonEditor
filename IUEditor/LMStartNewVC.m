		//
//  LMStartNewVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewVC.h"
#import "LMAppDelegate.h"
#import "LMStartWC.h"
#import "LMStartNewDefaultVC.h"
#import "LMStartNewDjangoVC.h"
#import "LMStartNewPresentationVC.h"

@interface LMStartNewVC ()
@property (weak) IBOutlet NSButton *typeDefaultB;
@property (weak) IBOutlet NSButton *typePresentationB;
@property (weak) IBOutlet NSButton *typeDjangoB;

@property (weak) IBOutlet NSView *contentV;

@property (weak) IBOutlet NSButton *prevB;
@property (weak) IBOutlet NSButton *nextB;

@end

@implementation LMStartNewVC{
    LMStartNewDefaultVC         *defaultVC;
    LMStartNewDjangoVC          *djangoVC;
    LMStartNewPresentationVC    *presentationVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaultVC = [[LMStartNewDefaultVC alloc] initWithNibName:@"LMStartNewDefaultVC" bundle:nil];
        djangoVC = [[LMStartNewDjangoVC alloc] initWithNibName:@"LMStartNewDjangoVC" bundle:nil];
        presentationVC = [[LMStartNewPresentationVC alloc] initWithNibName:@"LMStartNewPresentationVC" bundle:nil];
        
        defaultVC.parentVC = self;
        djangoVC.parentVC = self;
        presentationVC.parentVC = self;
    }
    return self;
}

- (void)awakeFromNib{
    defaultVC.prevB = _prevB;
    djangoVC.prevB = _prevB;
    presentationVC.prevB = _prevB;
    
    defaultVC.nextB = _nextB;
    djangoVC.nextB = _nextB;
    presentationVC.nextB = _nextB;

    [self show];
}

- (void)show{
    [_prevB setHidden:NO];
    [_prevB setAction:@selector(pressPrevBtn)];
    [_nextB setAction:@selector(pressNextBtn)];
    
    [defaultVC.view removeFromSuperview];
    [djangoVC.view removeFromSuperview];
    [presentationVC.view removeFromSuperview];
    
    [_nextB setTarget:self];
    [_nextB setEnabled:YES];
    [_prevB setEnabled:NO];
}

- (IBAction)pressProjectTypeB:(NSButton*)sender {
    self.typeDefaultB.state = 0;
    self.typePresentationB.state = 0;
    self.typeDjangoB.state = 0;
    
    sender.state = 1;
}
- (void)pressNextBtn{

    if (_typeDefaultB.state) {
        [self.contentV addSubview:defaultVC.view];
        [defaultVC show];
    }
    else if (_typePresentationB.state){
        [self.contentV addSubview:presentationVC.view];
        [presentationVC show];
    }
    else if (_typeDjangoB.state){
        [self.contentV addSubview:djangoVC.view];
        [djangoVC show];
    }
}
- (void)pressPrevBtn{

    [_nextB setTarget:self];
    [_nextB setEnabled:YES];
    [_prevB setEnabled:NO];
}


@end