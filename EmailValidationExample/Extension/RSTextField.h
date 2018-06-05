//
//  RSTextField.h
//  EmailValidationExample
//
//  Created by Ruslan on 3/30/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

/*
 RSTextField.h
 Base TextField
 */

#import <UIKit/UIKit.h>



@interface RSTextField : UITextField<UITextFieldDelegate>

@property (nonatomic, strong, nullable) NSDictionary *pAttributes;

@property (nonatomic, strong, nullable) IBInspectable UIColor *errorColor;

@property (nonatomic, strong, nullable) IBInspectable UIColor *lineColor;

@property (nonatomic) IBInspectable BOOL enableMaterialPlaceHolder;

@property (nonatomic) IBInspectable BOOL showActivity;

@property (nonatomic) IBInspectable BOOL isValidData;

- (void)showError;

- (void)hideError;

- (void)showMsgError:(NSString*_Nullable)error;


- (void)fieldDidInit;



@end
