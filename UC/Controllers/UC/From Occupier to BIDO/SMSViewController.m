//
//  SMSViewController.m
//  UC
//
//  Created by HardCastle on 23/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "SMSViewController.h"
#import "Helper.h"


@interface SMSViewController ()

@property (weak, nonatomic) IBOutlet UITextView *msgTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
- (IBAction)sendBtnClicked:(id)sender;
@end

@implementation SMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _msgTextView.text = @"Enter message...";
    _msgTextView.textColor = [UIColor lightGrayColor];
    [[_msgTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_msgTextView layer] setBorderWidth:1];
    
    _phoneNumberTextField.text = _mobileNumber;
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

#pragma mark - Button Events
- (IBAction)sendBtnClicked:(id)sender {
    NSLog(@"%@ ---- %@",_phoneNumberTextField.text,_msgTextView.text);
    
    if ([_phoneNumberTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter phone number"] animated:NO completion:nil];
    }
    else if ([_msgTextView.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter message"] animated:NO completion:nil];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                       {
                           NSString *urlStr = [NSString stringWithFormat:@"http://bulkpush.mytoday.com/BulkSms/SingleMsgApi?feedid=354227&username=9689931042&password=gdptp&TO=%@&Text=%@",_phoneNumberTextField.text,_msgTextView.text];
                           NSString* webStringURL = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
                           
                           NSURL *url = [NSURL URLWithString:webStringURL];

    // 2
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                 dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     // 4: Handle response here
                                     
                                     if (data != nil) {
                                         
                                         NSDictionary *responseDict =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                         NSLog(@"%@",responseDict);
                                         
                                         NSString *resStr = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                                         NSLog(@"%@",resStr);

                             
                             dispatch_async(dispatch_get_main_queue(), ^
                                            {
                                                NSString *message = @"SMS Send Successfully";
                                                
                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                                               message:message
                                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                [self presentViewController:alert animated:YES completion:nil];
                                                
                                                int duration = 1; // duration in seconds
                                                

                                                
                                                NSLog(@"%@",responseDict);
                                                if ([deviceType isEqualToString:@"iPhone"]) {
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    });
                                                }
                                                else {
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    });
                                                }
                                               
                                            });
                                     }
                                     else {
                                         dispatch_async(dispatch_get_main_queue(), ^
                                                        {
                                                           NSLog(@"FAILED");
                                                        });
                                     }
                                 }];

                           // 3
                           [downloadTask resume];
                       });

    }
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (textView == _msgTextView) {
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        self.view.frame = CGRectOffset(self.view.frame, 0, -120);
        [UIView commitAnimations];
        
        if ([_msgTextView.text isEqualToString:@"Enter message..."]) {
            _msgTextView.text = @"";
            _msgTextView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (textView == _msgTextView) {
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        self.view.frame = CGRectOffset(self.view.frame, 0, 120);
        [UIView commitAnimations];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if (textView == _msgTextView) {
        if(_msgTextView.text.length == 0){
            _msgTextView.textColor = [UIColor lightGrayColor];
            _msgTextView.text = @"Enter message...";
            [_msgTextView resignFirstResponder];
        }
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_msgTextView resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
}


@end
