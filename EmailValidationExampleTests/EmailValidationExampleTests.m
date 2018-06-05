//
//  EmailValidationExampleTests.m
//  EmailValidationExampleTests
//
//  Created by Ruslan on 3/30/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestModelData.h"
#import "EmailValidator.h"

@interface EmailValidationExampleTests : XCTestCase

@end

@implementation EmailValidationExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testSyntaxValidator
{
    NSArray *tests = @[[[TestModelData alloc] initWithEmailAddress:@"ruponi@gmail.com" errorCode:0],
                       [[TestModelData alloc] initWithEmailAddress:@"test+-.test@gmail.cin" errorCode:EmailInvalidDeliveryError],
                       [[TestModelData alloc] initWithEmailAddress:@"test@.com" errorCode:EmailInvalidSyntaxError],
                       [[TestModelData alloc] initWithEmailAddress:@"test.com" errorCode:EmailInvalidSyntaxError],
                       [[TestModelData alloc] initWithEmailAddress:@"test@com" errorCode:EmailInvalidSyntaxError],
                       [[TestModelData alloc] initWithEmailAddress:@"test@gmail.c" errorCode:EmailInvalidTLDError],
                       [[TestModelData alloc] initWithEmailAddress:@"test@gmail+.com" errorCode:EmailInvalidDomainError],
                       [[TestModelData alloc] initWithEmailAddress:@"test&*\"@gmail.com" errorCode:EmailInvalidUsernameError],
                       ];
    
    EmailValidator *validator = [EmailValidator validator];
    validator.validateDelivery=true;
    
    for (TestModelData *test in tests) {
        
     
        [validator validateSyntaxOfEmailAddress:test.emailAddress
                                        success:^(BOOL response) {
                                            NSLog(@"OK");
                                            XCTAssertEqual(response, true, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
            
            } withError:^(NSError *error) {
                NSLog(@"%@",error);
        if (test.errorCode > 0) {
            XCTAssertEqual(error.code, test.errorCode, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        } else {
            XCTAssertNil(error, @"Unit test failed for \"%s\"", __PRETTY_FUNCTION__);
        }
        }];
        
    }
}


@end
