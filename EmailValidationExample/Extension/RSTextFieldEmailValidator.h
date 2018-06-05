//
//  RSTextFieldEmailValidator.h
//  EmailValidationExample
//
//  Created by Ruslan on 4/2/18.
//  Copyright © 2018 rsoft. All rights reserved.
//
// used as data source for Domain names
// DomainsData.plist
//

#import "RSTextField.h"
#import "EmailValidator.h"
#import "AutocompleteInputView.h"




@protocol RSTextFieldDelegate <NSObject>
@optional
- (void)autoCompleteTextViewDidAutoComplete:(RSTextField *_Nullable)autoCompleteField;
- (void)autoCompleteTextView:(RSTextField *_Nullable)autocompleteTextView didChangeAutocompleteText:(NSString *_Nullable)autocompleteText;
- (void)emailValidated:(RSTextField *_Nullable)autoCompleteField withError:(NSError *_Nullable)error;

@end



@interface RSTextFieldEmailValidator : RSTextField<UITextFieldDelegate,AutocompleteDelegate,AutocompleteDataSource>{
    NSArray *autocompleteData;
    EmailValidator *emailValidator;
    AutocompleteInputView * autocompleteBarView;
}
//Autocomplete suggestion

@property (nonatomic, weak,nullable) id<RSTextFieldDelegate> autoCompleteTextFieldDelegate;

/*
 * Configure text field appearance
 */
@property (nonatomic, strong) UILabel * _Nullable autocompleteLabel;
@property (nonatomic, assign) CGPoint autocompleteTextOffset;


- (CGRect)autocompleteRectForBounds:(CGRect)bounds; // Override to alter the position of the autocomplete text


/*
 * Refresh the autocomplete text manually
 */
- (void)forceRefreshAutocompleteText;

/*
 * Force validation
 */
- (void)validateInput;

@property (nonatomic, strong) NSString * _Nullable autocompleteString;
@property (nonatomic, assign) BOOL autocompleted;
@property (nonatomic, assign) IBInspectable BOOL autocompleteDisabled;



@end
