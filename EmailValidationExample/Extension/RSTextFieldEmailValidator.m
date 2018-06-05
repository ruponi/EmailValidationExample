//
//  RSTextFieldEmailValidator.m
//  EmailValidationExample
//
//  Created by Ruslan on 4/2/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import "RSTextFieldEmailValidator.h"

@implementation RSTextFieldEmailValidator


- (void)fieldDidInit{
    [super fieldDidInit];
    [self setupAutocompleteTextField];
    
    
}

- (void)setupAutocompleteTextField
{
    [super setDelegate:self];
    self.autocompleteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.autocompleteLabel.font = self.font;
    self.autocompleteLabel.backgroundColor = [UIColor clearColor];
    self.autocompleteLabel.textColor = [UIColor lightGrayColor];
    
    
    NSLineBreakMode lineBreakMode = NSLineBreakByClipping;
    
    self.autocompleteLabel.lineBreakMode = lineBreakMode;
    self.autocompleteLabel.hidden = YES;
    [self addSubview:self.autocompleteLabel];
    [self bringSubviewToFront:self.autocompleteLabel];
    
    self.autocompleteString = @"";
    self.autocompleted = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rsTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
 
    [self autocompleteDataSetup];
    
    [self setTextContentType:UITextContentTypeEmailAddress];
    [self setKeyboardType:UIKeyboardTypeEmailAddress];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setupAutocompleteView];
    emailValidator = [[EmailValidator alloc] init];
}

-(void)setupAutocompleteView{
    autocompleteBarView = [AutocompleteInputView new];
    self.inputAccessoryView = autocompleteBarView;
    self.delegate = autocompleteBarView;
    
    // pass the view to the caller to customize it
    autocompleteBarView.textColor=UIColor.whiteColor;
    autocompleteBarView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    // set the protocols
    autocompleteBarView.textField = self;
    autocompleteBarView.delegate = self;
    autocompleteBarView.dataSource = self;
    
    // init "state is not visible"
    [autocompleteBarView show:NO withAnimation:NO];
}

/*
 Get autocomplete Data
*/
 -(void) autocompleteDataSetup{
    NSString *plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"DomainsData" ofType:@"plist"];
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    autocompleteData = dataDictionary[@"CommonDomains"];
}




- (BOOL)becomeFirstResponder
{
    BOOL returnValue = [super becomeFirstResponder];
    if (!self.autocompleteDisabled)
    {
        self.autocompleteLabel.hidden = NO;
    }
    return returnValue;
}


- (BOOL)resignFirstResponder
{
    BOOL returnValue = [super resignFirstResponder];

    if (!self.autocompleteDisabled)
    {
        self.autocompleteLabel.hidden = YES;
        
        if ([self commitAutocompleteText]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
        }
    }
   
    return returnValue;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

}

- (CGRect)autocompleteRectForBounds:(CGRect)bounds
{
    CGRect caretRect = [self caretRectForPosition:self.selectedTextRange.start];
    
    CGRect returnRect = CGRectMake(caretRect.origin.x + 1.0f, caretRect.origin.y, self.frame.size.width, caretRect.size.height);
    
    return returnRect;
}

- (void)rsTextDidChange:(NSNotification*)notification
{
    _autocompleted = false;
    [self refreshAutocompleteText];
}

//Update inner label for some UI reason
- (void)updateAutocompleteLabel
{
    [self.autocompleteLabel setText:self.autocompleteString];
    [self.autocompleteLabel sizeToFit];
    [self.autocompleteLabel setFrame: [self autocompleteRectForBounds:self.bounds]];
    
    if ([self.autoCompleteTextFieldDelegate respondsToSelector:@selector(autoCompleteTextView:didChangeAutocompleteText:)]) {
        [self.autoCompleteTextFieldDelegate autoCompleteTextView:self didChangeAutocompleteText:self.autocompleteString];
    }
}

- (void)refreshAutocompleteText
{
    if (!self.autocompleteDisabled)
    {
        
        if (autocompleteData)
        {
            self.autocompleteString = [self textView:self
                                 completionForPrefix:self.text
                                          ignoreCase:true];
            
            if (self.autocompleteString.length > 0)
            {
                if ([self.text hasSuffix:@" "]) {
                    self.text = [self.text substringToIndex:[self.text length] - 1];
                    [self autocompleteText:self];
                }
            }
            
            [self updateAutocompleteLabel];
        }
    }
}

//Push suggested email to text field
- (BOOL)commitAutocompleteText
{
    NSString *currentText = self.text;
    if (self.autocompleteString && [self.autocompleteString isEqualToString:@""] == NO
        && self.autocompleteDisabled == NO)
    {
        self.text = [NSString stringWithFormat:@"%@%@", self.text, self.autocompleteString];
        
        self.autocompleteString = @"";
        [self updateAutocompleteLabel];
        
        if ([self.autoCompleteTextFieldDelegate respondsToSelector:@selector(autoCompleteTextViewDidAutoComplete:)]) {
            [self.autoCompleteTextFieldDelegate autoCompleteTextViewDidAutoComplete:self];
        }
    }
    [autocompleteBarView show:NO withAnimation:NO];
    return ![currentText isEqualToString:self.text];
}

- (void)forceRefreshAutocompleteText
{
    [self refreshAutocompleteText];
}

#pragma mark - Accessors

- (void)setAutocompleteString:(NSString *)autocompleteString
{
    _autocompleteString = autocompleteString;
}



#pragma mark - Private Methods

- (void)autocompleteText:(id)sender
{
    if (!self.autocompleteDisabled)
    {
        self.autocompleteLabel.hidden = NO;
        self.autocompleted = YES;
        [self commitAutocompleteText];
        
       

        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
    }
}

#pragma mark - Autocomplete Suggestion inner text

- (NSString *)textView:(RSTextField *)textView completionForPrefix:(NSString *)prefix ignoreCase:(BOOL)ignoreCase
{
    // Check that text field contains an @
    NSRange atSignRange = [prefix rangeOfString:@"@"];
    if (atSignRange.location == NSNotFound)
    {
        return @"";
    }
    
    NSArray *textComponents = [prefix componentsSeparatedByString:@"@"];
    
    if ([textComponents count] > 1)
    {
        NSString *lastText = [[textComponents lastObject] stringByReplacingOccurrencesOfString:@" " withString:@""];
        // If no domain is entered, use the first domain in the list
        if ([lastText length] == 0)
        {
            return [autocompleteData objectAtIndex:0];
        }
        
        NSString *stringToLookFor = lastText;
        if (ignoreCase)
        {
            stringToLookFor = [stringToLookFor lowercaseString];
        }
        
        for (NSString *stringFromReference in autocompleteData)
        {
            NSString *stringToCompare = stringFromReference;
            if (ignoreCase)
            {
                stringToCompare = [stringToCompare lowercaseString];
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }
    
    return @"";
}

#pragma mark - Validate Email
/*
 
 Validate Email
 
*/
- (void)validateInput
{
    //if (self.text.length > 0) {

        [self setShowActivity:true];
        emailValidator.validateDelivery=true;
        [emailValidator validateSyntaxOfEmailAddress:self.text success:^(BOOL success) {
            
            NSLog(@"%d",success);
            self.isValidData=true;
            
            [self setShowActivity:false];
        
            if ([self.autoCompleteTextFieldDelegate respondsToSelector:@selector(emailValidated:withError:)]) {
                [self.autoCompleteTextFieldDelegate emailValidated:self withError:nil];
            }
        } withError:^(NSError *error) {
            [self setShowActivity:false];
            self.isValidData=false;
            
            NSString *message = error .localizedDescription;
            
            [self showMsgError:message];
           
            if ([self.autoCompleteTextFieldDelegate respondsToSelector:@selector(emailValidated:withError:)]) {
                [self.autoCompleteTextFieldDelegate emailValidated:self withError:error];
            }
        }];
        
   
   
    
    
}

#pragma mark Autocomplete Bar Delegate

#pragma mark - Autocomplete Delegate

- (void)textField:(UITextField *)textField didSelectObject:(id)object inInputView:(AutocompleteInputView *)inputView
{

    _autocompleteString=object;
    [self commitAutocompleteText];
    _autocompleted=true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - Autocomplete Data Source

- (NSUInteger)minimumCharactersToTrigger:(AutocompleteInputView *)inputView
{
    return 1;
}

- (void)inputView:(AutocompleteInputView *)inputView itemsFor:(NSString *)query result:(void (^)(NSArray *items))resultBlock;
{
    if (resultBlock != nil) {
        // execute the filter on the background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            // execute the filter
            
            NSMutableArray *array;
            
            if (self.isFirstResponder&&!_autocompleted) {
                array = [autocompleteData mutableCopy];
            } else {
                return ;
            }
            
            NSMutableArray *data = [NSMutableArray array];
            NSRange atSignRange = [query rangeOfString:@"@"];
            
            if (atSignRange.location == NSNotFound)
            {
             //provide first 10 domains
                for (int i=0;i<10;i++) {
                   
                    NSString *rs=[NSString stringWithFormat:@"@%@",array[i]];
                   
                    [data addObject:rs];
                    
                }
            } else {
    
                NSArray *textComponents = [query componentsSeparatedByString:@"@"];
                
                if ([textComponents count] > 0)
                {
                    NSString *lastText = [[[textComponents lastObject] stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                
                    for (NSString *stringFromReference in autocompleteData)
                    {
                        NSString *stringToCompare = stringFromReference;
                    
                        stringToCompare = [stringToCompare lowercaseString];

                        if ([stringToCompare hasPrefix:lastText])
                        {
                            NSString *sData=[NSString stringWithFormat:@"%@",[stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:lastText] withString:@""]];
                            [data addObject:sData];
                        }
                
                
                
            }
                }
            }
            // return the filtered array to the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(data);
            });
        });
    }
}



@end
