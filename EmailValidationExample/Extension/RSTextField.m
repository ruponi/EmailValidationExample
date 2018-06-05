//
//  RSTextField.m
//  EmailValidationExample
//
//  Created by Ruslan on 3/30/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import "RSTextField.h"

@interface RSTextField ()
{
    UIView *line;
    UILabel *placeHolderLabel;
    UILabel *errorLabel;
    UIImageView *okIndicatorImage;
    UIActivityIndicatorView *activityIndicator;
    NSAttributedString *errorText;
    BOOL showError;
    

}

@end


@implementation RSTextField



@synthesize errorColor;

#define UNDERLINE_ALPHA 0.5

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self defaultInit];
    
}

- (void)defaultInit
{
    //Line          ====
    _lineColor = [UIColor lightGrayColor];
    errorColor = [UIColor redColor];
    line = [[UIView alloc] init];
    line.backgroundColor = [_lineColor colorWithAlphaComponent:UNDERLINE_ALPHA];
    [self addSubview:line];
    
    //Activity      ====
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    activityIndicator.hidesWhenStopped = true;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicator];
    
    // Error Label  ====
    errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 0, self.frame.size.height)];
    [self addSubview:errorLabel];
    errorLabel.attributedText=errorText;
    
    // OK Indicator ====
    self.rightViewMode = UITextFieldViewModeAlways;
    okIndicatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_ok"]];
    [okIndicatorImage setFrame:CGRectMake(self.frame.size.width-15, 0,15 , 15)];
    [okIndicatorImage setContentMode:UIViewContentModeScaleAspectFit];
    [okIndicatorImage setHidden:true];
    self.rightView = okIndicatorImage;
    
    self.clipsToBounds = NO;
    [self setEnableMaterialPlaceHolder:YES];
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self fieldDidInit];
    
}

- (void)fieldDidInit{
    
}

-(void) setIsValidData:(BOOL)isValidData{
    _isValidData=isValidData;
    if (isValidData){
        okIndicatorImage.hidden = false;
    } else {
         okIndicatorImage.hidden = true;
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textFieldDidChange:self];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    line.backgroundColor = _lineColor;
}

- (IBAction)textFieldDidChange:(id)sender
{
    if (self.enableMaterialPlaceHolder) {
        [self hideError];
        if (!self.text || self.text.length > 0) {
            placeHolderLabel.alpha = 1;
            self.attributedPlaceholder = nil;
        }
        
        CGFloat duration = 0.5;
        CGFloat delay = 0;
        CGFloat damping = 0.6;
        CGFloat velocity = 1;
        
        [UIView animateWithDuration:duration
                              delay:delay
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                if (!self.text || self.text.length <= 0) {
                                    placeHolderLabel.transform = CGAffineTransformIdentity;
                                }
                                else {
                                    placeHolderLabel.transform = CGAffineTransformMakeTranslation(0, -placeHolderLabel.frame.size.height - 5);
                                }
                                
                            }
                         completion:^(BOOL finished) {
                             
                         }];
        
    }
}

-(IBAction)clearAction:(id)sender
{
    self.text = @"";
    [self textFieldDidChange:self];
}

-(void)highlight
{
    
    [UIView animateWithDuration: 0.3
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         if (showError) {
                             line.backgroundColor=errorColor;
                         }
                         else {
                             line.backgroundColor=self.lineColor;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                            
                         }
                     }];
    
}

-(void)unhighlight
{
    [UIView animateWithDuration: 0.3
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         
                         if (showError) {
                             line.backgroundColor = errorColor;
                         }
                         else {
                             line.backgroundColor = [self.lineColor colorWithAlphaComponent:UNDERLINE_ALPHA];
                         }
                         
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }];
    
}

- (void)setPlaceholderAttributes:(NSDictionary *)pAttributes
{
    _pAttributes = pAttributes;
    [self setPlaceholder:self.placeholder];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    
    NSDictionary *atts = @{NSForegroundColorAttributeName: [self.textColor colorWithAlphaComponent:0.8],
                           NSFontAttributeName : [self.font fontWithSize: self.font.pointSize]};
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder ?: @"" attributes: self.pAttributes ?: atts];
    
    [self setEnableMaterialPlaceHolder:self.enableMaterialPlaceHolder];
}

//Show Activity during validation
- (void)setShowActivity:(BOOL)showActivity{
    if (showActivity){
        [activityIndicator setHidden:false];
        [activityIndicator startAnimating];
    } else {
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:true];
    }
}


- (void)setEnableMaterialPlaceHolder:(BOOL)enableMaterialPlaceHolder
{
    _enableMaterialPlaceHolder = enableMaterialPlaceHolder;
    
    if (!placeHolderLabel) {
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 0, self.frame.size.height)];
        
        [self addSubview:placeHolderLabel];
        placeHolderLabel.alpha = 0;
    }
    placeHolderLabel.alpha = _enableMaterialPlaceHolder ? placeHolderLabel.alpha : 0;
    placeHolderLabel.attributedText = self.attributedPlaceholder;
    [placeHolderLabel sizeToFit];
    
}


- (void)showError
{
    showError = YES;
    line.backgroundColor = errorColor;
}

- (void)hideError
{
    showError = NO;
    line.backgroundColor = self.lineColor;
    errorLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
    [self setIsValidData:NO];
    
}

- (void)showMsgError:(NSString*)error{
    [self showError];
   
    NSDictionary *atts = @{NSForegroundColorAttributeName:errorColor ,
                           NSFontAttributeName : [self.font fontWithSize: self.font.pointSize-2]};
    
    errorText = [[NSAttributedString alloc] initWithString:error ?: @"" attributes: self.pAttributes ?: atts];
    errorLabel.attributedText=errorText;
    [errorLabel sizeToFit];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    line.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    activityIndicator.center = CGPointMake(self.frame.size.width-15, self.frame.size.height/2);
    errorLabel.frame = CGRectMake(0, 35, self.frame.size.width, 20);
    [errorLabel setNumberOfLines:0];
    [errorLabel sizeToFit];
}



@end
