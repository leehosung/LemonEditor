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
* 각각의 이름은 identifier로 저장
*/
@property (strong) IBOutlet NSView *IUBoxTitleV;
@property (strong) IBOutlet NSView *IUBoxContentV;

@property (strong) IBOutlet NSView *IUHTMLTitleV;
@property (strong) IBOutlet NSView *IUHTMLContentV;
@property (strong) IBOutlet NSView *IUWebMovieTitleV;
@property (strong) IBOutlet NSView *IUWebMovieContentV;

#pragma mark property View
@property (weak) IBOutlet NSComboBox *linkCB;
@property (unsafe_unretained) IBOutlet NSTextView *innerHTMLTextV;
@property (unsafe_unretained) IBOutlet NSTextView *webMovieSourceTextV;

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
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSContinuouslyUpdatesValueBindingOption]];
    [_innerHTMLTextV bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"innerHTML"]  options:bindingOption];
    [_webMovieSourceTextV bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"webMovieSource"]  options:bindingOption];
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
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(NSView *)item{
    
    if(self.controller.selectedObjects.count == 0){
        return 0;
    }
    
    if(item == nil){
        NSArray *classPedigree = [self viewArrayInClassPedigree];
        return classPedigree.count;
    }
    else if([[item identifier] containsString:@"TitleV"]){
        return 1;
    }
    else{
        return 0;
    }
}
//return child item
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(NSView *)item{
    //root
    if(item == nil){
        //view title
        NSArray *classPedigree = [self viewArrayInClassPedigree];
        NSString *viewID = [NSString stringWithFormat:@"%@TitleV", classPedigree[index]];
        return [self valueForKey:viewID];
    }
    //view content
    else{
        NSString *identifier = [item identifier];
        if([identifier containsString:@"TitleV"]){
            NSString *classID = [identifier stringByReplacingOccurrencesOfString:@"TitleV" withString:@""];
            NSString *viewID = [NSString stringWithFormat:@"%@ContentV", classID];
            return [self valueForKey:viewID];
        }
        
    }
    JDWarnLog(@"there is no child");
    return nil;
}



- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(NSView *)item{
    
    if([[item identifier] containsString:@"TitleV"]){
        return YES;
    }
    return  NO;
}



- (id)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    return item;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(NSView *)item{
    assert(item != nil);
    CGFloat height = item.frame.size.height;
    if(height <=0){
        height = 0.1;
    }
    return height;
   
}

-(NSArray *)viewArrayInClassPedigree{
    NSMutableArray *viewArray = [NSMutableArray array];
    NSArray *classPedigree = [[self.controller.selection class] classPedigreeTo:[IUBox class]];

    for(NSString *className in classPedigree){
        NSString *viewID = [NSString stringWithFormat:@"%@TitleV", className];
        if([self valueForKey:viewID]){
            [viewArray addObject:className];
        }
    }
    return viewArray;
}
- (id)valueForUndefinedKey:(NSString *)key{
    JDWarnLog(@"there is no define view : %@", key);
    return nil;
}



@end
