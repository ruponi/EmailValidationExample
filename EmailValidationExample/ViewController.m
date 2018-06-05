//
//  ViewController.m
//  EmailValidationExample
//
//  Created by Ruslan on 3/30/18.
//  Copyright © 2018 rsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tf_email.autoCompleteTextFieldDelegate=self;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) emailValidated:(RSTextField *)autoCompleteField withError:(NSError *)error{
    if (!error){
        NSLog(@"%@",@"VALIDATED");
    } else {
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
}

- (void)autoCompleteTextView:(RSTextField * _Nullable)autocompleteTextView didChangeAutocompleteText:(NSString * _Nullable)autocompleteText {
    
}


- (void)autoCompleteTextViewDidAutoComplete:(RSTextField * _Nullable)autoCompleteField {
    
}


- (IBAction)onPressLogin:(id)sender {
    
    [_tf_email resignFirstResponder];
    [_tf_email validateInput];
}


@end
