//
//  UCLoginViewController.m
//  UC
//
//  Created by HardCastle on 08/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "UCLoginViewController.h"
#import "Helper.h"
#import "APIManager.h"
#import "DashboardViewController.h"
#import "DataManager.h"

@interface UCLoginViewController ()
{
    UIAlertController *alert;
}

@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signInBtnClicked:(id)sender;
- (IBAction)citizenLoginClicked:(id)sender;

@end

@implementation UCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //DE 9689931331
    //CL 9860014019
    //BI 9689931411

    _userIdTextField.text = @"9689931411";
    _passwordTextField.text = @"PASS@1234";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - Button Clicked Events

- (IBAction)signInBtnClicked:(id)sender {
    if ([_userIdTextField.text isEqualToString:@""]) {
        
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please User Id"] animated:YES completion:nil];
    }
    else if ([_passwordTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter Password"] animated:YES completion:nil];
    }
    else {
        
        NSString *paramStr = [NSString stringWithFormat:@"MOBILE_NO=%@&PASSWORD=%@",_userIdTextField.text,_passwordTextField.text];
        
        alert = [Helper showLoader];
       // [self presentViewController:alert animated:NO completion:nil];
        
        [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/citizen_Login.php" withBlock:^(NSString *message, id response) {
            
           // [alert dismissViewControllerAnimated:NO completion:nil];
            
            if ([message isEqualToString:kSuccess]) {
        
                [self performSegueWithIdentifier:@"dashboardSegue" sender:[[response objectForKey:@"DATA"] objectAtIndex:0]];
            }
            else {
                [Helper showAlertMessage:@"UC" andMessage:@"Connection Error"];
            }
        }];
    }
}


- (IBAction)citizenLoginClicked:(id)sender {
    [self performSegueWithIdentifier:@"citizenSegue" sender:nil];
}


#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self animateTextField:textField up:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userIdTextField) {
        [textField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}


-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    int movementDistance = 0;
    
    if ([deviceType isEqualToString:@"iPhone"])
    {
        if (textField.tag == 101)
        {
            movementDistance = -100;
        }
        else
            movementDistance = -80;
    }
    else
    {
        if (textField.tag == 101)
        {
            movementDistance = -200;
        }
        else
            movementDistance = -150;
    }
    
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userIdTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [[[DataManager shareInstance] userDefaults] setObject:[sender objectForKey:@"TYPE"] forKey:@"USER_TYPE"];
    [[[DataManager shareInstance] userDefaults] setObject:[sender objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [[[DataManager shareInstance] userDefaults] setObject:@"YES" forKey:@"SESSION"];
    [[[DataManager shareInstance] userDefaults] synchronize];
    
    if ([segue.identifier isEqualToString:@"dashboardSegue"]) {
        
       // DashboardViewController *obj = (DashboardViewController *)[segue destinationViewController];
        //NSLog(@"%@",[sender objectForKey:@"TYPE"]);
        //obj.userType = [sender objectForKey:@"TYPE"];
    }
}


@end
