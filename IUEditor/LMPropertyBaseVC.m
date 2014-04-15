//
//  LMPropertyBaseVC.m
//  IUEditor
//
//  Created by jd on 4/11/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBaseVC.h"

@interface LMPropertyBaseVC ()
#pragma mark -
#pragma mark default
@property (weak) IBOutlet NSOutlineView *outlineV;

#pragma mark each IU
/* @@@important
* IUBoxTitleV, IUBoxContentV
* 각각의 property view는 titleV와 contentV처럼 위와 같은
* name convention 을 가진다.
*/
@property (strong) IBOutlet NSView *IUBoxTitleV;
@property (strong) IBOutlet NSView *IUBoxContentV;

@property (strong) IBOutlet NSView *IUHTMLTitleV;
@property (strong) IBOutlet NSView *IUHTMLContentV;

#pragma mark property View
@property (weak) IBOutlet NSComboBox *linkCB;
@property (unsafe_unretained) IBOutlet NSTextView *innerHTMLTextV;

@end

@implementation LMPropertyBaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib{
    
    [_linkCB bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"link"] options:nil];
    [_innerHTMLTextV bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"innerHTML"]  options:nil];
}

-(void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];

}

-(void)selectedObjectsDidChange:(NSDictionary *)change{
    [_outlineV reloadData];
}

#pragma mark -
#pragma mark outlineView

//return number of child
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(NSString *)item{
    if(self.controller.selectedObjects.count == 0){
        return 0;
    }
    if(item == nil){
        NSArray *classPedigree = [[self.controller.selection class] classPedigreeTo:[IUBox class]];
        return classPedigree.count;
    }
    else if([item containsString:@"TitleV"]){
        return 1;
    }
    else{
        return 0;
    }
}
//return child item
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(NSString *)item{
    
    //root
    if(item == nil){
        //view title
        NSArray *classPedigree = [[self.controller.selection class] classPedigreeTo:[IUBox class]];
        NSString *viewID = [NSString stringWithFormat:@"%@TitleV", classPedigree[index]];
        return viewID;
    }
    //view content
    else{
        if([item containsString:@"TitleV"]){
            NSString *classID = [item stringByReplacingOccurrencesOfString:@"TitleV" withString:@""];
            NSString *viewID = [NSString stringWithFormat:@"%@ContentV", classID];
            return viewID;
        }
        
    }
    JDWarnLog(@"there is no child");
    return nil;
}



- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(NSString *)item{
    
    if([item containsString:@"TitleV"]){
        return YES;
    }
    return  NO;
}



- (id)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSString *)item{
    return [self valueForKey:item];
}


- (id)valueForUndefinedKey:(NSString *)key{
    JDWarnLog(@"there is no define view : %@", key);
    return nil;
}
 



@end
