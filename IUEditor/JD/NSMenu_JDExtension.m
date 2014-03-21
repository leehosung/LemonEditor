#import "NSMenu_JDExtension.h"

@implementation NSMenu (JDExtension)

- (NSMenuItem *)addItemWithTitle:(NSString *)aString action:(SEL)aSelector keyEquivalent:(NSString *)charCode target:(id)target{
    
    NSMenuItem *retItem = [[NSMenuItem alloc] initWithTitle:aString action:aSelector keyEquivalent:charCode];
    [retItem setTarget:target];
    
    [self addItem:retItem];
    
    return retItem;
    
}

@end