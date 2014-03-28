//
//  IUEditorTests.m
//  IUEditorTests
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IUProject.h"
#import "NSObject+JDExtension.h"

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

-(void)bindingTest{
    id a;
    id b;
    
}

-(void)testPrintProjectProperty{
    NSArray *jdproperty = [IUProject properties];
    NSLog([jdproperty description]);
}

- (void)testProjectInit{
}

- (void)testProjectLoad{
}


@end
