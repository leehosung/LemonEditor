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
#import "LMStartNewPresentationVC.h"

@interface LMStartNewVC ()
@property (weak) IBOutlet NSButton *typeDefaultB;
@property (weak) IBOutlet NSButton *typePresentationB;
@property (weak) IBOutlet NSButton *typeDjangoB;

@end

@implementation LMStartNewVC{
    LMStartNewDefaultVC *defaultVC;
    LMStartNewDjangoVC    *djangoVC;
    LMStartNewPresentationVC *presentationVC;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaultVC = [[LMStartNewDefaultVC alloc] initWithNibName:@"LMStartNewDefaultVC" bundle:nil];
        djangoVC = [[LMStartNewDjangoVC alloc] initWithNibName:@"LMStartNewDjangoVC" bundle:nil];
        presentationVC = [[LMStartNewPresentationVC alloc] initWithNibName:@"LMStartNewPresentationVC" bundle:nil];
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
    
    [_prevB setTarget:self];
    [_prevB setAction:@selector(pressPrevB)];
}

- (void)show{
    [_prevB setEnabled:NO];
    [_nextB setEnabled:YES];
    
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}

- (void)pressNextB{
    
    
    if (_typeDefaultB.state) {
        [self.view addSubview:defaultVC.view];
        [defaultVC show];
        [_prevB setEnabled:YES];
  //      [_prevB setTarget:self];
  //      [_prevB setAction:@selector(pressPrevB)];
    }
    else if (_typePresentationB.state){
        [self.view addSubview:presentationVC.view];
        [presentationVC show];
        [_prevB setEnabled:YES];
   //     [_prevB setTarget:self];
   //     [_prevB setAction:@selector(pressPrevB)];
    }
    else if (_typeDjangoB.state){
        [self.view addSubview:djangoVC.view];
        [djangoVC show];
        [_prevB setEnabled:YES];
    //    [_prevB setTarget:self];
    //    [_prevB setAction:@selector(pressPrevB)];
    }

}

- (void)pressPrevB{
    [defaultVC.view removeFromSuperview];
    [djangoVC.view removeFromSuperview];
    [presentationVC.view removeFromSuperview];
    [_nextB setEnabled:YES];
    [_prevB setEnabled:NO];
    
  //  [_nextB setTarget:self];
  //  [_nextB setAction:@selector(pressNextB)];
}

@end
