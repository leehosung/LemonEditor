//
//  CALayer+JDExtension.m
//  Mango
//
//  Created by JD on 13. 8. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "CALayer+JDExtension.h"
#import "JDUIUtil.h"

@implementation CALayer (JDExtension)
-(void)setCenter:(NSPoint)point{
    self.frame = NSRectModifyOrigin(self.frame, NSPointMake(point.x - self.frame.size.width/2,
                                                            point.y - self.frame.size.height/2));
}
- (void)bringSublayerToFront:(CALayer *)layer {
    CALayer *superlayer = layer.superlayer;
    [layer removeFromSuperlayer];
    [superlayer insertSublayer:layer atIndex:(unsigned)[superlayer.sublayers count]];
}

- (void)sendSublayerToBack:(CALayer *)layer {
    CALayer *superlayer = layer.superlayer;
    [layer removeFromSuperlayer];
    [superlayer insertSublayer:layer atIndex:0];
}
@end
