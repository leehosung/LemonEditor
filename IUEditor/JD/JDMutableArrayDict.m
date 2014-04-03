//
//  JDArrayDict.m
//  Mango
//
//  Created by JD on 13. 3. 20..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDMutableArrayDict.h"

@implementation JDMutableArrayDict

@synthesize dict;
@synthesize array;

- (id)init{
	if (self=[super init]) {
		dict=[[NSMutableDictionary alloc]init];
		array=[[NSMutableArray	alloc]init];
	}
	return self;
}


//NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:dict forKey:@"dict"];
	[aCoder encodeObject:array forKey:@"array"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	if (self=[super init]) {
		self.dict=[[aDecoder decodeObjectForKey:@"dict"] mutableCopy];
		self.array=[[aDecoder decodeObjectForKey:@"array"] mutableCopy];
	}
	return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len{
	return [array countByEnumeratingWithState:state objects:buffer count:len];
}

- (id)objectAtIndex:(NSUInteger)index{
	return [array objectAtIndex:index];
}

- (id)objectForKey:(id)aKey{
	return [dict objectForKey:aKey];
}

- (void)setObject:(id)obj forKey:(id)key{
    [self willChangeValueForKey:@"dict"];
    [self willChangeValueForKey:@"array"];
	[dict setObject:obj forKey:key];
//    [[self mutableArrayValueForKey:@"array"] addObject:obj];
	[array addObject:obj];
    [self didChangeValueForKey:@"dict"];
    [self didChangeValueForKey:@"array"];
}

- (void)insertObject:(id)anObject forKey:(id)key atIndex:(NSUInteger)index{
    [self willChangeValueForKey:@"dict"];
    [self willChangeValueForKey:@"array"];
	[dict setObject:anObject forKey:key];
    //[[self mutableArrayValueForKey:@"array"] insertObject:anObject atIndex:index];
	[array insertObject:anObject atIndex:index];
    [self didChangeValueForKey:@"dict"];
    [self didChangeValueForKey:@"array"];

    
}


- (NSUInteger)indexOfObject:(id)anObject{
	return [array indexOfObject:anObject];
}

- (NSUInteger)count{
	return [array count];
}

- (void)removeObjectForKey:(id)key{
    id obj = [dict objectForKey:key];
    [self willChangeValueForKey:@"dict"];
    [self willChangeValueForKey:@"array"];
    [dict removeObjectForKey:key];
    [array removeObject:obj];
    [self didChangeValueForKey:@"dict"];
    [self didChangeValueForKey:@"array"];
}

-(void)removeAllObjects{
    [self willChangeValueForKey:@"dict"];
    [self willChangeValueForKey:@"array"];
    [dict removeAllObjects];
    [array removeAllObjects];
    [self didChangeValueForKey:@"dict"];
    [self didChangeValueForKey:@"array"];
}

@end