//
//  CitizenLoginViewController.m
//  UC
//
//  Created by HardCastle on 10/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "CitizenLoginViewController.h"
#import "Helper.h"
#import "APIManager.h"
#import <QuartzCore/QuartzCore.h>

@interface CitizenLoginViewController ()
{
    UIAlertController *alert;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextView *complaintAddrTextView;
@property (weak, nonatomic) IBOutlet UITextField *zoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pethTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *complaintDetailsTextView;

- (IBAction)submitBtnClicked:(id)sender;

@end

@implementation CitizenLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"COMPLAINT REGISTRATION";
    
    _addressTextView.text = @"Enter address";
    _complaintAddrTextView.text = @"Enter complaint address";
    _complaintDetailsTextView.text = @"Enter complaint details";
    
    _addressTextView.textColor = [UIColor lightGrayColor];
    _complaintAddrTextView.textColor = [UIColor lightGrayColor];
    _complaintDetailsTextView.textColor = [UIColor lightGrayColor];
    
    [[_addressTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_addressTextView layer] setBorderWidth:1];
    //[[_addressTextView layer] setCornerRadius:15];
    
    [[_complaintAddrTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_complaintAddrTextView layer] setBorderWidth:1];
    //[[_complaintAddrTextView layer] setCornerRadius:15];
    
    [[_complaintDetailsTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_complaintDetailsTextView layer] setBorderWidth:1];
    //[[_complaintDetailsTextView layer] setCornerRadius:15];
    
    NSLog(@"%@",[self getCurrentDate]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _nameTextField) {
        [textField resignFirstResponder];
        [_addressTextView becomeFirstResponder];
    }
    else if (textField == _zoneTextField) {
        [textField resignFirstResponder];
        [_pethTextField becomeFirstResponder];
    }
    else if (textField == _pethTextField) {
        [textField resignFirstResponder];
        [_mobileTextField becomeFirstResponder];
    }
    else if (textField == _mobileTextField) {
        [textField resignFirstResponder];
        [_emailTextField becomeFirstResponder];
    }
    else if (textField == _emailTextField) {
        [textField resignFirstResponder];
        [_complaintDetailsTextView becomeFirstResponder];
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //if ([deviceType isEqualToString:@"iPhone"])
    //{
        [self animateTextField:textField up:YES];
   // }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   // if ([deviceType isEqualToString:@"iPhone"])
   // {
        [self animateTextField:textField up:NO];
   // }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // verify the text field you wanna validate
    if (textField == _mobileTextField) {
        
        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 10) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        
        if ([string rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }
        
        return YES;
    }
    
    return YES;
}

#pragma mark - TextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    if (textView == _addressTextView) {
        if ([_addressTextView.text isEqualToString:@"Enter address"]) {
            _addressTextView.text = @"";
            _addressTextView.textColor = [UIColor blackColor];
        }
    }
    else if (textView == _complaintAddrTextView) {
        if ([_complaintAddrTextView.text isEqualToString:@"Enter complaint address"]) {
            _complaintAddrTextView.text = @"";
            _complaintAddrTextView.textColor = [UIColor blackColor];
        }
    }
    else if (textView == _complaintDetailsTextView) {
        
        //if ([deviceType isEqualToString:@"iPhone"])
        //{
            [UIView beginAnimations: @"animateTextField" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.3f];
            self.view.frame = CGRectOffset(self.view.frame, 0, -180);
            [UIView commitAnimations];
       // }
        if ([_complaintDetailsTextView.text isEqualToString:@"Enter complaint details"]) {
            _complaintDetailsTextView.text = @"";
            _complaintDetailsTextView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    if (textView == _complaintDetailsTextView) {
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        self.view.frame = CGRectOffset(self.view.frame, 0, 180);
        [UIView commitAnimations];
    }

    return YES;
}


-(void) textViewDidChange:(UITextView *)textView
{
    if (textView == _addressTextView) {
        if(_addressTextView.text.length == 0){
            _addressTextView.textColor = [UIColor lightGrayColor];
            _addressTextView.text = @"Enter address";
            [_addressTextView resignFirstResponder];
        }
    }
    else if (textView == _complaintAddrTextView) {
        if(_complaintAddrTextView.text.length == 0){
            _complaintAddrTextView.textColor = [UIColor lightGrayColor];
            _complaintAddrTextView.text = @"Enter complaint address";
            [_complaintAddrTextView resignFirstResponder];
        }
    }
    else if (textView == _complaintDetailsTextView) {
        if(_complaintDetailsTextView.text.length == 0){
            _complaintDetailsTextView.textColor = [UIColor lightGrayColor];
            _complaintDetailsTextView.text = @"Enter complaint details";
            [_complaintDetailsTextView resignFirstResponder];
        }
    }
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
    [_addressTextView resignFirstResponder];
    [_complaintAddrTextView resignFirstResponder];
    [_zoneTextField resignFirstResponder];
    [_pethTextField resignFirstResponder];
    [_complaintDetailsTextView resignFirstResponder];
    [_mobileTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
}

#pragma mark - Utility
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    int movementDistance = 0;
    
    if ([deviceType isEqualToString:@"iPhone"])
    {
        if (textField.tag == 101)
        {
            movementDistance = -80;
        }
        else if(textField.tag == 102)
        {
            movementDistance = -90;
        }
        else if(textField.tag == 103)
        {
            movementDistance = -120;
        }
        else if(textField.tag == 104)
        {
            movementDistance = -125;
        }
    }
    else {
        if (textField.tag == 101)
        {
            movementDistance = -80;
        }
        else if(textField.tag == 102)
        {
            movementDistance = -90;
        }
        else if(textField.tag == 103)
        {
            movementDistance = -120;
        }
        else if(textField.tag == 104)
        {
            movementDistance = -125;
        }
    }
    const float movementDuration = 0.3f;
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Events
- (IBAction)submitBtnClicked:(id)sender {
    if ([_nameTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter name"] animated:YES completion:nil];
       
    }
    else if ([_addressTextView.text isEqualToString:@"Enter address"]) {
        [self presentViewController: [Helper showAlertMessage:@"UC" andMessage:@"Please enter adddres"] animated:YES completion:nil];
    }
    else if ([_complaintAddrTextView.text isEqualToString:@"Enter complaint address"]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter complaint address"] animated:YES completion:nil];
    }
    else if ([_zoneTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter zone"] animated:YES completion:nil];
    }
    else if ([_pethTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter Peth/Village"] animated:YES completion:nil];
    }
    else if ([_mobileTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter Mobile number"] animated:YES completion:nil];
    }
    else if ([_emailTextField.text isEqualToString:@""]) {
        NSLog(@"%d",[self validateEmail:_emailTextField.text]);
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter email id"] animated:YES completion:nil];
    }
    else if(![self validateEmail:_emailTextField.text]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter valid email id"] animated:YES completion:nil];
    }
    else if ([_complaintDetailsTextView.text isEqualToString:@"Enter complaint details"]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter complaint details"] animated:YES completion:nil];
    }
    else {
        
        NSString *dataStr = [NSString stringWithFormat:@"&COMPLAINT_BY=%@&COMPLAINT_BY_ID=%@&NAME=%@&ADDRESS=%@&COMPLAINT_ADDRESS=%@&WARD_NO=%@&ZONE=%@&VILLAGE=%@&MOBILE_NO=%@&EMAIL_ID=%@&COMPLAINT_DETAILS=%@&COMPLAINT_DATE=%@",@"OFFICER",@"100",_nameTextField.text,_addressTextView.text,_complaintAddrTextView.text,@"0",_zoneTextField.text,_pethTextField.text,_mobileTextField.text,_emailTextField.text,_complaintDetailsTextView.text,[self getCurrentDate]];
        
        alert = [Helper showLoader];
        [self presentViewController:alert animated:YES completion:nil];
        
        [[APIManager new] postRequest:dataStr url:@"_IPHONE/PMC_UC/register_Complaint.php" withBlock:^(NSString *message, id response) {
            
            [alert dismissViewControllerAnimated:NO completion:nil];
            if ([message isEqualToString:kSuccess]) {
                
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"UC" message:@"Complaint register successfully" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [successAlert addAction:ok];
                [self presentViewController:successAlert animated:YES completion:nil];
            
            }
            else {
                [Helper showAlertMessage:@"UC" andMessage:@"Please try again later"];
            }
        }];
    }
}


#pragma mark - Utilities

-(BOOL) validateEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(NSString *)getCurrentDate {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
