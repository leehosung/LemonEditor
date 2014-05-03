//
//  LMStartNewVC.m
//  IUEditor
//
//  Created by jd on 5/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMStartNewVC.h"
#import "LMAppDelegate.h"

#import "LMStartNewDefaultVC.h"
#import "LMStartNewDjangoVC.h"
#import "LMStartNewPresenationVC.h"

@interface LMStartNewVC ()
@property (weak) IBOutlet NSButton *typeDefaultB;
@property (weak) IBOutlet NSButton *typePresentationB;
@property (weak) IBOutlet NSButton *typeDjangoB;

@end

@implementation LMStartNewVC{
    LMStartNewDefaultVC *defaultVC;
    LMStartNewDjangoVC    *djangoVC;
    LMStartNewPresenationVC *presentationVC;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaultVC = [[LMStartNewDefaultVC alloc] initWithNibName:@"LMStartNewDefaultVC" bundle:nil];
        djangoVC = [[LMStartNewDjangoVC alloc] initWithNibName:@"LMStartNewDjangoVC" bundle:nil];
  //      presentationVC = [[LMStartNewPresenationVC alloc] initWithNibName:@"LMStartNewPresentationVC" bundle:nil];
    }
    return self;
}

- (void)setNextB:(NSButton *)nextB{
    _nextB = nextB;
    defaultVC.nextB = nextB;
    djangoVC.nextB = nextB;
    presentationVC.nextB = nextB;
}

- (IBAction)pressProjectTypeB:(NSButton*)sender {
    self.typeDefaultB.state = 0;
    self.typePresentationB.state = 0;
    self.typeDjangoB.state = 0;
    
    sender.state = 1;
}

/*
- (IBAction)pressDefaultNew:(id)sender {
    LMAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate newDocument:nil];
}

- (IBAction)pressDjangoNew:(id)sender {
    LMAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate newDjangoDocument:nil];
}
*/

- (void)show{
    [_prevB setEnabled:NO];
    [_nextB setEnabled:YES];
    
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
    
    [_prevB setTarget:self];
    [_prevB setAction:@selector(pressPrevB)];
}

- (void)pressNextB{

    if (_typeDefaultB.state) {
        [self.view addSubview:defaultVC.view];
        [defaultVC show];
        [_prevB setEnabled:YES];
    }
    else if (_typePresentationB.state){
        [self.view addSubview:presentationVC.view];
        [presentationVC show];
        [_prevB setEnabled:YES];
    }
    else if (_typeDjangoB.state){
        [self.view addSubview:djangoVC.view];
        [djangoVC show];
        [_prevB setEnabled:YES];
    }

}

- (void)pressPrevB{
    [defaultVC.view removeFromSuperview];
    [djangoVC.view removeFromSuperview];
    [presentationVC.view removeFromSuperview];
    [_nextB setEnabled:YES];
    [_prevB setEnabled:NO];
    
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}

@end
