//
//  CommandEditorTests.m
//  CommandEditorTests
//
//  Created by jd on 5/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IUProject.h"
@interface CommandEditorTests : XCTestCase

@end

@implementation CommandEditorTests

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

- (void)testCreateProject
{
    IUProject *project = [[IUProject alloc] initWithCreation:@{IUProjectKeyDirectory:[@"~/IUProjects/temp" stringByExpandingTildeInPath], IUProjectKeyAppName:@"testproj"} error:nil];
    XCTAssertNotNil(project, @"project creation");
}

@end
