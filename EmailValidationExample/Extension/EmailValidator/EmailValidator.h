//
//  EmailValidator.h
//  EmailValidationExample
//
//  Created by Ruslan on 4/2/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const EmailValidatorErrorDomain;

typedef enum {
    EmailBlankAddressError = 1000,
    EmailInvalidSyntaxError,
    EmailInvalidUsernameError,
    EmailInvalidDomainError,
    EmailInvalidTLDError,
    EmailInvalidDeliveryError
} EmailValidatorErrorCode;

typedef void(^SucessBlock)(BOOL response);
typedef void(^ErrorBlock)(NSError* response);

@interface EmailValidator : NSObject

+ (instancetype)validator;

//if need validate Via Kickbox,io
@property (nonatomic,assign) BOOL validateDelivery;

- (void)validateSyntaxOfEmailAddress:(NSString *)emailAddress success:(SucessBlock)success withError:(ErrorBlock)error;

@end
