//
//  AutocompleteInputView.h
//  EmailValidationExample
//
//  Created by Ruslan on 4/3/18.
//  Copyright © 2018 rsoft. All rights reserved.
//


/*
 AutocompleteInputView
 Show list of the data under inputAccessoryView OF THE TEXTField
 */

#import <UIKit/UIKit.h>

@protocol AutocompleteItem <NSObject>

// used to display text on the autocomplete bar
- (NSString *)autocompleteString;

@end

#pragma mark -

@protocol AutocompleteDelegate <UITextFieldDelegate>

// called when a user taps one of the suggestions
- (void)textField:(UITextField *)textField didSelectObject:(id)object inInputView:(id)inputView;

@end

#pragma mark -

@protocol AutocompleteDataSource <NSObject>

// number of characters required to trigger the search on possible suggestions
- (NSUInteger)minimumCharactersToTrigger:(id)inputView;

// use the block to return the array of items asynchronously based on the query string
- (void)inputView:(id)inputView itemsFor:(NSString *)query result:(void (^)(NSArray *items))resultBlock;

@optional

- (NSString*)inputView:(id)inputView stringForObject:(id)object atIndex:(NSUInteger)index;

// calculate the width of the view for the object (NSString or ACEAutocompleteItem)
- (CGFloat)inputView:(id)inputView widthForObject:(id)object;

// called after the cell is created, to add custom subviews
- (void)inputView:(id)inputView customizeView:(UIView *)view;

// called to set the object properties in the custom view
- (void)inputView:(id)inputView setObject:(id)object forView:(UIView *)view;

@end


@interface AutocompleteInputView : UIView<UITextFieldDelegate>

@property (nonatomic, assign) UITextField *textField;

// delegate
@property (nonatomic, assign) id<AutocompleteDelegate> delegate;
@property (nonatomic, assign) id<AutocompleteDataSource> dataSource;

// customization (ignored when the optional methods of the data source are implemeted)
@property (nonatomic, strong) UIFont * font;
@property (nonatomic, strong) UIColor * textColor;

- (id)initWithHeight:(CGFloat)height;

- (void)show:(BOOL)show withAnimation:(BOOL)animated;

@end
