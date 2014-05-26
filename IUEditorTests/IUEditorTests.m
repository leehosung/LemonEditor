//
//  IUEditorTests.m
//  IUEditorTests
//
//  Created by JD on 3/17/14.
//  Copyright (c)@(20)14 JDLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IUProject.h"
#import "NSObject+JDExtension.h"
#import "NSIndexPath+JDExtension.h"

@interface IUEditorTests : XCTestCase

@end



@implementation IUEditorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIndex{
    NSIndexPath *path = [NSIndexPath indexPathWithIndex:5];
    path = [path indexPathByAddingIndex:10];
    path = [path indexPathByAddingIndex:8];
    
    NSIndexPath *retPath = [NSIndexPath indexPathWithIndexPath:path length:2];
    XCTAssertEqual(retPath.length, 2, @"length");
    XCTAssertEqual([retPath indexAtPosition:0], 5, @"eq1");
    XCTAssertEqual([retPath indexAtPosition:1], 10, @"eq2");
    
}


@end
