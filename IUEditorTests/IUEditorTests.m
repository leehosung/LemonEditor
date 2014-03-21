//
//  IUEditorTests.m
//  IUEditorTests
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IUProject.h"

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

- (void)testProjectInit{
    NSString *testDir = [@"~/iutest" stringByExpandingTildeInPath];
    NSError *error;
    IUProject *project = [[IUProject alloc] initAtDirectory:testDir name:@"projectName" git:0 heroku:NO error:&error];
    project = nil;
    XCTAssertNil(error, @"error");
}

- (void)testProjectLoad{
    NSString *testDir = [@"~/iutest/projectName.iuproject" stringByExpandingTildeInPath];
    NSError *error;
    IUProject *project = [IUProject projectWithContentsOfPackage:testDir];
    XCTAssertTrue([[project name] isEqualToString:@"projectName"], @"project wrong");
}


@end
