//
//  TestModelData.m
//  EmailValidationExampleTests
//
//  Created by Ruslan on 4/3/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import "TestModelData.h"

@implementation TestModelData
- (instancetype)initWithEmailAddress:(NSString *)emailAddress errorCode:(NSInteger)errorCode
{
    if (self = [super init]) {
        self.emailAddress = emailAddress;
        self.errorCode = errorCode;
    }
    return self;
}
@end
