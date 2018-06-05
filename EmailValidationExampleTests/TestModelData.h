//
//  TestModelData.h
//  EmailValidationExampleTests
//
//  Created by Ruslan on 4/3/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModelData : NSObject
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic) NSInteger errorCode;
@property (nonatomic, strong) NSString *suggestion;

- (instancetype)initWithEmailAddress:(NSString *)emailAddress errorCode:(NSInteger)errorCode;
@end
