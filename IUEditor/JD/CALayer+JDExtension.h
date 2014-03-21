//
//  CALayer+JDExtension.h
//  Mango
//
//  Created by JD on 13. 8. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JDExtension)
-(void)setCenter:(NSPoint)point;
- (void)bringSublayerToFront:(CALayer *)layer;
- (void)sendSublayerToBack:(CALayer *)layer;
@end
