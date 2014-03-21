//
//  JDObjectExtension.h
//  Mango
//
//  Created by JD on 13. 3. 31..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#define kJDKeyPath @"JDKeyPath"
#define kJDContext @"JDContext"

@interface NSObject(JDObjectExtension)

-(void)addObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context;

-(void)removeObserver:(NSObject*)observer forKeyPaths:(NSArray*)keyPaths;

- (void)observeValueForKeyPath:(NSString *)_keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
-(void)removeObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths context:(void *)context;
-(void)addObserver:(NSObject *)observer forKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options contexts:(NSArray*)contexts;
@end
