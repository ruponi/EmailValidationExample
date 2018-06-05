//
//  EmailValidator.m
//  EmailValidationExample
//
//  Created by Ruslan on 4/2/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import "EmailValidator.h"
NSString *const EmailValidatorErrorDomain = @"com.rsoft.EmailValidator";

//API KEY For KickBox.io
#define API_KEY_LIVE @"live_296a88fd862d942dcac310f362b326981bcea9e2d484d49d2181e58831d9ceae"
#define API_KEY_TEST @"test_6223d89239a701bdc37c3819ac5cdd91452985e367495b488f832aa031e4f36c"

@implementation EmailValidator

+ (instancetype)validator
{
    return [[EmailValidator alloc] init];
}

/*

 Validate email mail local part.
 Validate username, domain, TLD separately
 
*/
- (BOOL)validateSyntaxOfEmailAddress:(NSString *)emailAddress withParts:(NSArray *)emailParts withError:(NSError **)error
{
    if (emailAddress.length == 0) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The email address entered was blank."};
        
        if (error != NULL) {
            *error = [NSError errorWithDomain:EmailValidatorErrorDomain code:EmailBlankAddressError userInfo:errorDictionary];
        }
        
        return NO;
    }
    
    NSPredicate *fullEmailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\b.+@.+\\..+\\b$"];
    if (![fullEmailPredicate evaluateWithObject:emailAddress]) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The syntax of the entered email address is invalid."};
        
        if (error != NULL) {
            *error = [NSError errorWithDomain:EmailValidatorErrorDomain code:EmailInvalidSyntaxError userInfo:errorDictionary];
        }
        
        return NO;
    }
    
    NSString *username = emailParts[0];
    NSString *domain = emailParts[1];
    NSString *tld = emailParts[2];
    
    NSPredicate *usernamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z.!#$%&'*+-/=?^_`{|}~]+"];
    NSPredicate *domainPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z.-]+"];
    NSPredicate *tldPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Za-z][A-Z0-9a-z-]{0,22}[A-Z0-9a-z]"];
    
    if (username.length == 0 || ![usernamePredicate evaluateWithObject:username] || [username hasPrefix:@"."] || [username hasSuffix:@"."] || ([username rangeOfString:@".."].location != NSNotFound)) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The username section of the entered email address is invalid."};
        
        if (error != NULL) {
            *error = [NSError errorWithDomain:EmailValidatorErrorDomain code:EmailInvalidUsernameError userInfo:errorDictionary];
        }
        
        return NO;
    } else if (domain.length == 0 || ![domainPredicate evaluateWithObject:domain]) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The domain name section of the entered email address is invalid."};
        
        if (error != NULL) {
            *error = [NSError errorWithDomain:EmailValidatorErrorDomain code:EmailInvalidDomainError userInfo:errorDictionary];
        }
        
        return NO;
    } else if (![tldPredicate evaluateWithObject:tld]) {
        NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: @"The TLD section of the entered email address is invalid."};
        
        if (error != NULL) {
            *error = [NSError errorWithDomain:EmailValidatorErrorDomain code:EmailInvalidTLDError userInfo:errorDictionary];
        }
        
        return NO;
    } else {
        return YES;
    }
}

/*
 
 Validate email
 
 */

- (void)validateSyntaxOfEmailAddress:(NSString *)emailAddress success:(SucessBlock)success withError:(ErrorBlock)errorResponse{
    NSError *error;
    BOOL localValidation = [self validateSyntaxOfEmailAddress:emailAddress
                                                    withParts:[self splitEmailAddress:emailAddress]
                                                    withError:&error];
    
        if (localValidation){
            if (_validateDelivery){
                [self validateDeliveryWith:emailAddress
                                   success:^(BOOL response) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           success(response);
                                       });
                                   } withError:^(NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           errorResponse(error);
                                       });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(true);
                });
            }
        }
        else {
            //Only local validation
            dispatch_async(dispatch_get_main_queue(), ^{
                errorResponse(error);
                
            });
        }
        
    
}

/*
 
 SPlit Email Address on the parts
 
 */
- (NSArray *)splitEmailAddress:(NSString *)emailAddress
{
    NSString *username;
    NSString *domain;
    NSString *tld;
    
    NSUInteger atLocation = [emailAddress rangeOfString:@"@"].location;
    if (atLocation != NSNotFound) {
        username = [emailAddress substringToIndex:atLocation];
        
        NSUInteger periodLocation = [emailAddress rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(atLocation, emailAddress.length - atLocation)].location;
        
        if (periodLocation != NSNotFound) {
            domain = [[emailAddress substringWithRange:NSMakeRange(atLocation + 1, periodLocation - atLocation - 1)] lowercaseString];
            tld = [[emailAddress substringFromIndex:periodLocation + 1] lowercaseString];
        }
    }
    
    if (!username) {
        username = @"";
    }
    if (!domain) {
        domain = @"";
    }
    if (!tld) {
        tld = @"";
    }
    
    return @[username, domain, tld];
}

#pragma mark - KickBox.io Request
/*
  Validate with KickBox.io
 */
-(void)validateDeliveryWith:(NSString*)email success:(SucessBlock)success withError:(ErrorBlock)errorrs;
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *requestStr=[NSString stringWithFormat:@"https://api.kickbox.com/v2/verify?email=%@&apikey=%@",
                          email,
                          API_KEY_LIVE];
    [request setURL:[NSURL URLWithString:requestStr]];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                        completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  if (data == nil) {
                                      
                                      errorrs(error);
                                      
                                  } else {
                                      
                                      NSDictionary *dt=[NSJSONSerialization JSONObjectWithData:data
                                                                                       options:0
                                                                                         error:&error];
                                      NSLog(@"%@",dt);
                                      NSString *result = dt[@"result"];
                                      NSString *reason = dt[@"reason"];
                                      NSString *didyoumean = dt[@"did_you_mean"];
                                      if (![didyoumean isEqual:[NSNull null]]){
                                          didyoumean=[NSString stringWithFormat:@"Did You Mean: %@",didyoumean];
                                      } else {
                                          didyoumean=@"";
                                      }
                                      if ([result isEqualToString:@"deliverable"]){
                                         success(true);
                                      } else {
                                          NSString *userInfo=[NSString stringWithFormat:@"%@! %@",reason,didyoumean];
                                          NSDictionary *errorDictionary = @{NSLocalizedDescriptionKey: userInfo};
                                          error =  [NSError errorWithDomain:EmailValidatorErrorDomain
                                                                       code:EmailInvalidDeliveryError
                                                                   userInfo:errorDictionary];
                                          errorrs(error);
                                      }
                                      
                                  }
                              }];
[task resume];

}


@end
