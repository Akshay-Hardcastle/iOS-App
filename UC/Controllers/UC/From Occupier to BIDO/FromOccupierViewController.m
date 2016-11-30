//
//  FromOccupierViewController.m
//  UC
//
//  Created by HardCastle on 15/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "FromOccupierViewController.h"
#import "DataManager.h"
#import "Helper.h"
#import "APIManager.h"
#import "StatusTableViewCell.h"
#import "SMSViewController.h"

@interface FromOccupierViewController ()
{
    UIAlertController *alert;
    NSMutableArray *casesArray;
    NSString *selectedComplaintID;
    NSData *chosenImgData;
    NSString *mobileNumber;
}
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UITableView *caseListTableView;

- (IBAction)fromBtnClicked:(id)sender;
- (IBAction)toBtnClicked:(id)sender;
- (IBAction)searchBtnClicked:(id)sender;
- (IBAction)allBtnClicked:(id)sender;
- (IBAction)previewBtnClicked:(id)sender;
- (IBAction)sendEmailBtnClicked:(id)sender;
- (IBAction)sendSMSBtnClicked:(id)sender;
- (IBAction)printBtnClicked:(id)sender;
- (IBAction)uploadWitnessBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;

@end

@implementation FromOccupierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"NOTICE DELIVERY DISPATCH";
    
    casesArray = [[NSMutableArray alloc] init];
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    [[APIManager new] getRequest:@"_IPHONE/PMC_UC/fetchCasesForClerkAfterSiteVisit.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            [casesArray addObjectsFromArray:[response objectForKey:@"DATA"]];
            NSLog(@"%@",casesArray);
            // _tableViewHeightConstraint.constant = [complaintsArray count] * 60;
            //_scrollViewHeightConstraint.constant = _tableViewHeightConstraint.constant + 60;
            [_caseListTableView reloadData];
        }
        else {
            [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Connection Error"] animated:NO completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableScrollView.scrollEnabled = YES;
    if ([deviceType isEqualToString:@"iPhone"]) {
        [_tableScrollView setContentSize:CGSizeMake(1300,300)];
    }
    else {
        [_tableScrollView setContentSize:CGSizeMake(2000,_scrollViewHeightConstraint.constant)];
    }
}

#pragma mark - TableView Datasourse/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [casesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[StatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.srNoLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.uniqueIdLabel.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"]];
    cell.zoneLabel.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"ZONE"]];
    cell.areaLabel.text = [NSString stringWithFormat:@"%@",@"-"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"NAME"]];
    cell.complaintAddress.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"ADDRESS"]];
    cell.mobileNumber.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"MOBILE_NO"]];
    cell.emailLabel.text = [NSString stringWithFormat:@"%@",@"-"];
    cell.complaintNumberLabel.text = [NSString stringWithFormat:@"%@",@"-"];
    cell.floorLabel.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"FLOOR_STRUCTURE"]];
    cell.structureLabel.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"TYPE_OF_STRUCTURE"]];
    cell.otherDetailsLabel.text = [NSString stringWithFormat:@"%@",[[casesArray objectAtIndex:indexPath.row] objectForKey:@"OTHER_DETAIL"]];
    cell.statusLabel.text = [NSString stringWithFormat:@"%@",@"-"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.30 green:0.56 blue:1.00 alpha:1.0]];
    selectedComplaintID = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
    mobileNumber = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"MOBILE_NO"];
}


#pragma mark - Button Clicked events

- (IBAction)logoutBtnClicked:(id)sender {
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"SESSION"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"USER_ID"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"TYPE"];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    chosenImgData = UIImagePNGRepresentation(chosenImage);
    [_uploadBtn setBackgroundColor:[UIColor colorWithRed:0.42 green:0.75 blue:0.27 alpha:1.0]];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Button Click events

- (IBAction)fromBtnClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
            NSLog(@"%@",picker.date);
        }];
        action;
    })];
    UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    popoverController.sourceView = sender;
    popoverController.sourceRect = [sender bounds];
    [self presentViewController:alertController  animated:YES completion:nil];
}

- (IBAction)toBtnClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
            NSLog(@"%@",picker.date);
        }];
        action;
    })];
    UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    popoverController.sourceView = sender;
    popoverController.sourceRect = [sender bounds];
    [self presentViewController:alertController  animated:YES completion:nil];
}

- (IBAction)searchBtnClicked:(id)sender {
}

- (IBAction)allBtnClicked:(id)sender {
}

- (IBAction)previewBtnClicked:(id)sender {
}

- (IBAction)sendEmailBtnClicked:(id)sender {
    
    UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:@"SEND EMAIL" message:@"Send E-mail to the following address?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *send = [UIAlertAction actionWithTitle:@"SEND" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *paramStr = [NSString stringWithFormat:@"&EMAIL_ID=%@",emailAlert.textFields[0].text];
        [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/fetchCasesForClerkAfterSiteVisit.php" withBlock:^(NSString *message, id response) {
            
            if ([message isEqualToString:kSuccess]) {
                
                 [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Email send Successfully"] animated:NO completion:nil];
            }
            else {
                 [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please try again"] animated:NO completion:nil];
            }
            
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDestructive handler:nil];
    
    [emailAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter email-id...";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = @"abc12@gmail.com";
    }];
    
    [emailAlert addAction:send];
    [emailAlert addAction:cancel];
    [self presentViewController:emailAlert animated:YES completion:nil];
}


- (IBAction)sendSMSBtnClicked:(id)sender {
    SMSViewController *obj = [[SMSViewController alloc] init];
    obj.mobileNumber = mobileNumber;
}


- (IBAction)printBtnClicked:(id)sender {
    
}


- (IBAction)uploadWitnessBtnClicked:(id)sender {
    UIAlertController *uploadAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            NSLog(@"No camera");
            
        }
        else {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
    }];
    
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [uploadAlert addAction:camera];
    [uploadAlert addAction:gallery];
    [uploadAlert addAction:cancel];
    
    [uploadAlert setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [uploadAlert
                                                     popoverPresentationController];
    popPresenter.sourceView = _uploadBtn;
    popPresenter.sourceRect = _uploadBtn.bounds;
    [self presentViewController:uploadAlert animated:YES completion:nil];
    
}


- (IBAction)submitBtnClicked:(id)sender {
    
    if ([selectedComplaintID isEqualToString:@""] || selectedComplaintID == NULL) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select complaint"] animated:YES completion:nil];
    }
    else if (chosenImgData == NULL) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select Image"] animated:YES completion:nil];
    }
    else {
      
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
        
        NSString *param = [NSString stringWithFormat:@"&FILE_NAME=%@.jpg&UPLOAD_FILE=%@",timeStr,chosenImgData];
        
        [self presentViewController:alert animated:NO completion:nil];
        
        [[APIManager new] postRequest:param url:@"_IPHONE/PMC_UC/upload_Image.php" withBlock:^(NSString *message, id response) {
            
            if ([message isEqualToString:kSuccess]) {
                NSLog(@"%@",response);
                
                [self dismissViewControllerAnimated:NO completion:nil];
                NSString *paramStr = [NSString stringWithFormat:@"&COMPLAINT_ID=%@&IMG_NAME=%@.jpg",selectedComplaintID,timeStr];
                [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/upload_image_complaint_id.php" withBlock:^(NSString *message, id response) {
                    
                    if ([message isEqualToString:kSuccess]) {
                        NSLog(@"%@",response);
                        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Successfully sent"] animated:NO completion:nil];
                    }
                    else {
                        NSLog(@"FAILED");
                        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Failed..Please try again"] animated:NO completion:nil];
                    }
                }];
            }
            else {
                [self dismissViewControllerAnimated:NO completion:nil];
                
                NSLog(@"FAILED");
            }
        }];
    }
}


@end
