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

@interface LMStartNewVC ()
@property (weak) IBOutlet NSButton *typeDefaultB;
@property (weak) IBOutlet NSButton *typePresentationB;
@property (weak) IBOutlet NSButton *typeDjangoB;

@end

@implementation LMStartNewVC{
    LMStartNewDefaultVC *defaultVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaultVC = [[LMStartNewDefaultVC alloc] initWithNibName:@"LMStartNewDefaultVC" bundle:nil];
    }
    return self;
}

- (void)setNextB:(NSButton *)nextB{
    _nextB = nextB;
    defaultVC.nextB = nextB;
}

- (IBAction)pressDefaultNew:(id)sender {
    LMAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate newDocument:nil];
}
- (IBAction)pressDjangoNew:(id)sender {
    LMAppDelegate *delegate = [NSApplication sharedApplication].delegate;
    [delegate newDjangoDocument:nil];
}

- (IBAction)pressProjectTypeB:(NSButton*)sender {
    self.typeDefaultB.state = 0;
    self.typePresentationB.state = 0;
    self.typeDjangoB.state = 0;

    sender.state = 1;
}


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
        [_prevB setEnabled:YES];
        [defaultVC show];
    }
    else if (_typePresentationB.state){
        
    }
    else if (_typeDjangoB.state){
        
    }
}

- (void)pressPrevB{
    [defaultVC.view removeFromSuperview];
    [_nextB setEnabled:YES];
    
    [_nextB setTarget:self];
    [_nextB setAction:@selector(pressNextB)];
}

@end
