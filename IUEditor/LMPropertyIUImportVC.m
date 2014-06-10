//
//  LMPropertyIURenderVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUImportVC.h"
#import "IUSheetGroup.h"
#import "IUClass.h"

@interface LMPropertyIUImportVC ()
@property (strong) IBOutlet NSArrayController *classDocumentsArrayController;
@end

@implementation LMPropertyIUImportVC {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib{
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToProperty:@"prototypeClass"] options:0 context:nil];
    [_classDocumentsArrayController addObserver:self forKeyPath:@"selection" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *prototypePath = [_controller keyPathFromControllerToProperty:@"prototypeClass"];
    IUClass* prototype = [self valueForKeyPath:prototypePath];

    if ([keyPath isEqualToString:@"selection"]) {
        //selection changed
        [self setValue:prototype forKeyPath:prototypePath];
    }
}





@end
