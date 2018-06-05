//
//  ViewController.h
//  EmailValidationExample
//
//  Created by Ruslan on 3/30/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSTextFieldEmailValidator.h"

@interface ViewController : UIViewController<RSTextFieldDelegate>

// field for email validation
@property (weak, nonatomic) IBOutlet RSTextFieldEmailValidator *tf_email;

- (IBAction)onPressLogin:(id)sender;

@end

