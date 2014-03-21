//
//  JDTextField.m
//  Mango
//
//  Created by JD on 13. 7. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDTextField.h"
#import "JDTextFieldCell.h"
@implementation JDTextField

-(void)setCell:(NSCell *)aCell{
    JDTextFieldCell *cell = [[JDTextFieldCell alloc] init];
    [super setCell:cell];
}

@end
