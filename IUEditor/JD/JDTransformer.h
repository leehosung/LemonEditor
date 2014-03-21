//
//  JDTransformer.h
//  Mango
//
//  Created by JD on 13. 2. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@interface JDNilToZeroTransformer : NSValueTransformer

@end

@interface JDNilToHundredTransformer : NSValueTransformer

@end


@interface JDNilToEmptyStringTransformer : NSValueTransformer

@end


@interface JDNameTransformer : NSValueTransformer

@end

@interface IUTextAlignmentTransformer : NSValueTransformer

@end

@interface JDFirstIndexOfIndexSetTransformer : NSValueTransformer

@end

@interface JDNSColorToCGColorTransformer : NSValueTransformer

@end

@interface JDAttrStringToStringTransformer : NSValueTransformer

@end