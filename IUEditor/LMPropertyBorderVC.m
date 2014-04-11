//
//  LMPropertyApperenceVC.m
//  IUEditor
//
//  Created by jd on 4/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBorderVC.h"

@interface LMPropertyBorderVC ()
@property (weak) IBOutlet NSTextField *borderTF;
@property (weak) IBOutlet NSTextField *borderTopTF;
@property (weak) IBOutlet NSTextField *borderRightTF;
@property (weak) IBOutlet NSTextField *borderLeftTF;
@property (weak) IBOutlet NSTextField *borderBottomTF;
@end



@implementation LMPropertyBorderVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (NSString*)CSSBindingPath:(IUCSSTag)tag{
    return [@"controller.selection.css.assembledTagDictionary." stringByAppendingString:tag];
}


-(void)awakeFromNib{
}

-(void)setController:(IUController *)controller{
    _controller = controller;
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth] options:0 context:nil];
    [controller addObserver:self forKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth] options:0 context:nil];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderTopWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth]];
        [_borderTopTF setStringValue:value];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderLeftWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth]];
        [_borderLeftTF setStringValue:value];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderRightWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth]];
        [_borderRightTF setStringValue:value];
    }
    else if ([[keyPath pathExtension] isSameTag:IUCSSTagBorderBottomWidth]) {
        id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth]];
        [_borderBottomTF setStringValue:value];
    }
    id value = [_controller valueForKeyPath:[@"selection.css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderWidth]];
    [_borderTF setStringValue:value];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{
    NSTextField *changedField = [obj object];
    id value = @(_borderTF.integerValue);
    if (changedField == _borderTF) {
        for (IUBox *box in _controller.selectedObjects) {
            [box startGrouping];
        }
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth]];
        [_controller.selection setValue:value forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth]];
        for (IUBox *box in _controller.selectedObjects) {
            [box endGrouping];
        }
    }
    else if (changedField == _borderTopTF) {
        [_controller.selection setValue:@(_borderTopTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderTopWidth]];
    }
    else if (changedField == _borderLeftTF) {
        [_controller.selection setValue:@(_borderLeftTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderLeftWidth]];
    }
    else if (changedField == _borderRightTF) {
        [_controller.selection setValue:@(_borderRightTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderRightWidth]];
    }
    else if (changedField == _borderBottomTF) {
        [_controller.selection setValue:@(_borderBottomTF.integerValue) forKeyPath:[@"css.assembledTagDictionary" stringByAppendingPathExtension:IUCSSTagBorderBottomWidth]];
    }
}


@end