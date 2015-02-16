//
//  LoginViewController.m
//  CoffeeShop
//
//  Created by GrepRuby on 10/02/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    btnSignIn.layer.cornerRadius = 4.0;
    
    txtFldEmail.text = @"grepruby@gmail.com";
    txtFldPassword.text = @"gr123456";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 200;
    self.view.frame = frame;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {//Text Field Delegate

    [textField resignFirstResponder];
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y + 200;
    self.view.frame = frame;
}


@end
