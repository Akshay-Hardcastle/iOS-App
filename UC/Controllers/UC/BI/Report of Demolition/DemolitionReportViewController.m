//
//  DemolitionReportViewController.m
//  UC
//
//  Created by HardCastle on 25/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "DemolitionReportViewController.h"
#import "DataManager.h"
#import "Helper.h"
#import "APIManager.h"
#import "StatusTableViewCell.h"

@interface DemolitionReportViewController ()
{
    NSMutableArray *casesArray;
    UIAlertController *alert;
    NSString *complaintID;
    NSData *chosenImgData;
}

@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet UITableView *casesTableView;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@end

@implementation DemolitionReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"DEMOLITION REPORT";
    casesArray = [[NSMutableArray alloc] init];
    
    NSString *paramStr = [NSString stringWithFormat:@"&BI_ID=%@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]];
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/fetchCases_demolitionState.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        
        if ([message isEqualToString:kSuccess]) {
            NSLog(@"%@",[response objectForKey:@"DATA"]);
            [casesArray addObjectsFromArray:[response objectForKey:@"DATA"]];
            [_casesTableView reloadData];
        }
        else {
            [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Connection Error"] animated:NO completion:nil];
        }
    }];
    if ([deviceType isEqualToString:@"iPhone"]) {
        [_casesTableView setFrame:CGRectMake(6,138,364,429)];
        [_casesTableView setContentSize:CGSizeMake(1300,_tableScrollView.frame.size.height)];
    }
    else {
        [_casesTableView setContentSize:CGSizeMake(2000,_tableScrollView.frame.size.height)];
    }
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
        [_casesTableView setContentSize:CGSizeMake(1299,382)];
    }
    else {
        [_casesTableView setContentSize:CGSizeMake(2000,_tableScrollView.frame.size.height)];
    }
}


#pragma mark - TableView Delegate

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
    complaintID = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
    
}

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
- (IBAction)uploadCitizenReplyBtnClicked:(id)sender {
   
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
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    [uploadAlert addAction:camera];
    [uploadAlert addAction:gallery];
    [uploadAlert addAction:cancle];
    
    if ([deviceType isEqualToString:@"iPhone"]) {
        
    }
    else {
        
    }
    [uploadAlert setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [uploadAlert
                                                     popoverPresentationController];
    popPresenter.sourceView = _uploadBtn;
    popPresenter.sourceRect = _uploadBtn.bounds;
    [self presentViewController:uploadAlert animated:YES completion:nil];
}

- (IBAction)addRemark:(id)sender {
    UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:@"ADD REMARK" message:@"Enter Remark : " preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *send = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        NSString *paramStr = [NSString stringWithFormat:@"&EMAIL_ID=%@",emailAlert.textFields[0].text];
//        [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/fetchCasesForClerkAfterSiteVisit.php" withBlock:^(NSString *message, id response) {
//            
//            if ([message isEqualToString:kSuccess]) {
//                
//                [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Email send Successfully"] animated:NO completion:nil];
//            }
//            else {
//                [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please try again"] animated:NO completion:nil];
//            }
        
//        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDestructive handler:nil];
    
    [emailAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter remark...";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        //textField.text = @"abc12@gmail.co";
    }];
    
    [emailAlert addAction:send];
    [emailAlert addAction:cancel];
    [self presentViewController:emailAlert animated:YES completion:nil];

}

- (IBAction)submitBtnClicked:(id)sender {
//    if (complaintID isEqualToString:@") {
//
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
