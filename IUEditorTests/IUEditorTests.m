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
#import "IUTextManager.h"
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

- (void)testText8{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    [tm setFont:@"Gulim" atRange:NSMakeRange(2, 2)];
    [tm setFontSize:10 atRange:NSMakeRange(3, 2)];
    
    tm.editViewPortWidth = 360;
    [tm replaceText:@"qwer" atRange:NSMakeRange(5, 0)];
    [tm setFontSize:30 atRange:NSMakeRange(3, 2)];

    [tm removeMediaQuery:360];
    
    
    NSDictionary *resultDictionary = @{@(9999) : @{
            @"ObjTNode0" :         @{
                    @"font-name" : @"Helvetica",
                    @"font-size" :@(20),
                    },
            @"ObjTNode2" :         @{
                    @"font-name" : @"Gulim",
                    @"font-size" :@(20),
                    },
            @"ObjTNode3" :         @{
                    @"font-name" : @"Gulim",
                    @"font-size" : @(10),
                    },
            @"ObjTNode4" :         @{
                    @"font-name" : @"Helvetica",
                    @"font-size" : @(10),
                    },
            },
    };
    NSString *resultString = @"<span id='ObjTNode0'>AB</span><span id='ObjTNode2'>C</span><span id='ObjTNode3'>D</span><span id='ObjTNode4'>Eqwer</span>";
    XCTAssertEqualObjects(tm.css, resultDictionary, @"tt");
    XCTAssertEqualObjects(tm.HTML, resultString, @"tt");
}


- (void)testText7{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    [tm setFont:@"Gulim" atRange:NSMakeRange(2, 2)];
    [tm setFontSize:10 atRange:NSMakeRange(3, 2)];

    tm.editViewPortWidth = 360;
    [tm replaceText:@"qwer" atRange:NSMakeRange(5, 0)];
    [tm setFontSize:30 atRange:NSMakeRange(3, 2)];
    
    NSDictionary *resultDictionary = @{
        @(360) :     @{
            @"ObjTNode0" :         @{
                @"font-size" :@(20),
            },
            @"ObjTNode2" :         @{
                @"font-size" :@(20),
            },
            @"ObjTNode3" :         @{
                @"font-size" :@(30),
            },
            @"ObjTNode4" :         @{
                @"font-size" :@(30),
            },
            @"ObjTNode5" :         @{
                @"font-size" : @(10),
            },
        },
        @(9999) :     @{
            @"ObjTNode0" :         @{
                @"font-name" : @"Helvetica",
                @"font-size" :@(20),
            },
            @"ObjTNode2" :         @{
                @"font-name" : @"Gulim",
                @"font-size" :@(20),
            },
            @"ObjTNode3" :         @{
                @"font-name" : @"Gulim",
                @"font-size" : @(10),
            },
            @"ObjTNode4" :         @{
                @"font-name" : @"Helvetica",
                @"font-size" : @(10),
            },
            @"ObjTNode5" :         @{
                @"font-name" : @"Helvetica",
                @"font-size" : @(10),
            },
        },
        };
    NSString *resultString = @"<span id='ObjTNode0'>AB</span><span id='ObjTNode2'>C</span><span id='ObjTNode3'>D</span><span id='ObjTNode4'>E</span><span id='ObjTNode5'>qwer</span>";
    XCTAssertEqualObjects(tm.css, resultDictionary, @"tt");
    XCTAssertEqualObjects(tm.HTML, resultString, @"tt");

}


- (void)testText6{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    [tm setFont:@"Gulim" atRange:NSMakeRange(2, 2)];
    [tm setFontSize:10 atRange:NSMakeRange(3, 2)];
    [tm replaceText:@"qwer" atRange:NSMakeRange(5, 0)];
    NSString *resultString = @"<span id='ObjTNode0'>AB</span><span id='ObjTNode2'>C</span><span id='ObjTNode3'>D</span><span id='ObjTNode4'>Eqwer</span>";
    NSDictionary *firstDict =  @{@"font-name": @"Helvetica", @"font-size": @(20)};
    NSDictionary *secondDict =  @{@"font-name": @"Gulim", @"font-size": @(20)};
    NSDictionary *thirdDict = @{@"font-name": @"Gulim", @"font-size": @(10)};
    NSDictionary *fourthDict = @{@"font-name": @"Helvetica", @"font-size": @(10)};
    
    NSDictionary *resultDictionary = @{@(IUCSSMaxViewPortWidth):@{@"ObjTNode0":firstDict, @"ObjTNode2":secondDict, @"ObjTNode3": thirdDict, @"ObjTNode4":fourthDict}};
    XCTAssertEqualObjects(tm.css, resultDictionary, @"tt");
    XCTAssertEqualObjects(tm.HTML, resultString, @"tt");
}

- (void)testText1{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    NSString *resultString = @"<span id='ObjTNode0'>ABCDE</span>";
    NSDictionary *resultDictionary = @{@(IUCSSMaxViewPortWidth):@{@"ObjTNode0": @{@"font-name": @"Helvetica", @"font-size":@(20)}}};
    XCTAssertEqualObjects(tm.css, resultDictionary, @"tt");
    XCTAssertEqualObjects(tm.HTML, resultString, @"tt");
}

- (void)testText2{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    [tm setFont:@"Gulim" atRange:NSMakeRange(2, 2)];
    NSString *resultString = @"<span id='ObjTNode0'>AB</span><span id='ObjTNode2'>CD</span><span id='ObjTNode4'>E</span>";
    NSDictionary *firstDict =  @{@"font-name": @"Helvetica", @"font-size": @(20)};
    NSDictionary *secondDict =  @{@"font-name": @"Gulim", @"font-size": @(20)};
    NSDictionary *thirdDict = @{@"font-name": @"Helvetica", @"font-size": @(20)};

    NSDictionary *resultDictionary = @{@(IUCSSMaxViewPortWidth):@{@"ObjTNode0":firstDict, @"ObjTNode2":secondDict, @"ObjTNode4":thirdDict}};
    XCTAssertEqualObjects(tm.css, resultDictionary, @"CSS");
    XCTAssertEqualObjects(tm.HTML, resultString, @"HTML");
}

- (void)testText3{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    [tm setFont:@"Gulim" atRange:NSMakeRange(2, 2)];
    [tm setFontSize:10 atRange:NSMakeRange(3, 2)];
    NSString *resultString = @"<span id='ObjTNode0'>AB</span><span id='ObjTNode2'>C</span><span id='ObjTNode3'>D</span><span id='ObjTNode4'>E</span>";
    NSDictionary *firstDict =  @{@"font-name": @"Helvetica", @"font-size": @(20)};
    NSDictionary *secondDict =  @{@"font-name": @"Gulim", @"font-size": @(20)};
    NSDictionary *thirdDict = @{@"font-name": @"Gulim", @"font-size": @(10)};
    NSDictionary *fourthDict = @{@"font-name": @"Helvetica", @"font-size": @(10)};
    
    NSDictionary *resultDictionary = @{@(IUCSSMaxViewPortWidth):@{@"ObjTNode0":firstDict, @"ObjTNode2":secondDict, @"ObjTNode3": thirdDict, @"ObjTNode4":fourthDict}};
    XCTAssertEqualObjects(tm.css, resultDictionary, @"CSS");
    XCTAssertEqualObjects(tm.HTML, resultString, @"HTML");
}

- (void)testText4{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    
    tm.editViewPortWidth = 480;
    @try {
        [tm setFontSize:10 atRange:zeroRange];
    }
    @catch (NSException *exception) {
        NSString *resultString = @"<span id='ObjTNode0'>ABCDE</span>";
        NSDictionary *resultDictionary =@{@(9999):@{
                                                  @"ObjTNode0":@{@"font-name" : @"Helvetica",
                                                            @"font-size" : @(20)}}};
        XCTAssertEqualObjects(tm.css, resultDictionary, @"tt");
        XCTAssertEqualObjects(tm.HTML, resultString, @"tt");
        return;
    }
    XCTFail(@"exception not throw");

}

- (void)testText5{
    NSRange zeroRange = NSMakeRange(0, 0);
    IUTextManager *tm = [[IUTextManager alloc] init];
    tm.idKey = @"Obj";
    tm.editViewPortWidth = IUCSSMaxViewPortWidth;
    [tm setFont:@"Helvetica" atRange:zeroRange];
    [tm setFontSize:20 atRange:zeroRange];
    
    [tm replaceText:@"ABCDE" atRange:zeroRange];
    [tm setFont:@"Gulim" atRange:NSMakeRange(2, 2)];
    [tm setFontSize:10 atRange:NSMakeRange(3, 2)];
    [tm replaceText:@"qwer" atRange:NSMakeRange(0, 5)];
    NSString *resultString = @"<span id='ObjTNode0'>qwer</span>";
    NSDictionary *resultDictionary = @{@(IUCSSMaxViewPortWidth):@{@"ObjTNode0": @{@"font-name": @"Helvetica", @"font-size":@(20)}}};
    XCTAssertEqualObjects(tm.css, resultDictionary, @"tt");
    XCTAssertEqualObjects(tm.HTML, resultString, @"tt");
}



@end
