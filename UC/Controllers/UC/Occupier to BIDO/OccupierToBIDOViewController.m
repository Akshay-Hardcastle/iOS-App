//
//  OccupierToBIDOViewController.m
//  UC
//
//  Created by HardCastle on 15/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "OccupierToBIDOViewController.h"
#import "APIManager.h"
#import "Helper.h"
#import "StatusTableViewCell.h"
#import "DataManager.h"

@interface OccupierToBIDOViewController ()
{
    UIAlertController *alert;
    NSMutableArray *casesArray;
    NSMutableArray *officiersArray;
    NSMutableArray *officierIdArray;
    NIDropDown *dropDown;
    NSString *biID;
    NSData *chosenImgData;
    NSString *selectedComplaintID;
}
@property (weak, nonatomic) IBOutlet UITableView *occupierTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImg;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;


- (IBAction)toBtnClick:(id)sender;
- (IBAction)fromBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)uploadCitizenReplyBtnClicked:(id)sender;
- (IBAction)searchBtnClicked:(id)sender;
- (IBAction)allBtnClicked:(id)sender;
- (IBAction)dropDownBtnClicked:(id)sender;
- (IBAction)previewBtnClicked:(id)sender;
- (IBAction)logoutBtnClicked:(id)sender;

@end

@implementation OccupierToBIDOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    casesArray = [[NSMutableArray alloc] init];
    officiersArray = [[NSMutableArray alloc] init];
    officierIdArray = [[NSMutableArray alloc] init];
    
    self.title = @"FORWARD CITIZEN ANSWER";
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    [[APIManager new] getRequest:@"_IPHONE/PMC_UC/fetchCasesForClerkAfterSiteVisit.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            [casesArray addObjectsFromArray:[response objectForKey:@"DATA"]];
            NSLog(@"%@",casesArray);
            // _tableViewHeightConstraint.constant = [complaintsArray count] * 60;
            //_scrollViewHeightConstraint.constant = _tableViewHeightConstraint.constant + 60;
            [_occupierTableView reloadData];
        }
        else {
            [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Connection Error"] animated:NO completion:nil];
        }
    }];
    
    
    [[APIManager new] getRequest:@"_IPHONE/PMC_UC/fetch_Officers_Name.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            
            NSMutableArray *responseArray = [[NSMutableArray alloc] init];
            [responseArray addObjectsFromArray:[response objectForKey:@"data"]];
            
            NSLog(@"%@",responseArray);
            
            for (NSDictionary *dict in responseArray) {
                
                //NSArray *tempArray = [dict objectForKey:[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_TYPE"]];
                NSArray *tempArray = [dict objectForKey:@"BI"];
                for (NSDictionary *userDict in tempArray) {
                    
                    [officiersArray addObject:[userDict objectForKey:@"NAME"]];
                    [officierIdArray addObject:[userDict objectForKey:@"USER_ID"]];
                }
            }
            //[_dropDownBtn setTitle:[officiersArray objectAtIndex:0] forState:UIControlStateNormal];
            //deID = [officiersArray objectAtIndex:0];
        }
        else {
            [Helper showAlertMessage:@"UC" andMessage:@"Connection Error"];
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
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    NSLog(@"%ld",(long)_dropDownBtn.tag);
    NSLog(@"%@",[officierIdArray objectAtIndex:_dropDownBtn.tag]);
    biID = [officierIdArray objectAtIndex:_dropDownBtn.tag];
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


#pragma mark - Button events
- (IBAction)toBtnClick:(id)sender {
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

- (IBAction)submitBtnClicked:(id)sender {
    
    if ([selectedComplaintID isEqualToString:@""] || selectedComplaintID == NULL) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select complaint"] animated:YES completion:nil];
    }
    else if (chosenImgData == NULL) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select Image"] animated:YES completion:nil];
    }
    else if (biID == NULL) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select BI"] animated:YES completion:nil];
    }
    else {
//        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//        // NSTimeInterval is defined as double
//        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
        
        NSString *param = [NSString stringWithFormat:@"&FILE_NAME=%@.jpg&UPLOAD_FILE=%@",timeStr,chosenImgData];
       
        [self presentViewController:alert animated:NO completion:nil];
        [[APIManager new] postRequest:param url:@"_IPHONE/PMC_UC/upload_Image.php" withBlock:^(NSString *message, id response) {
            
            if ([message isEqualToString:kSuccess]) {
                NSLog(@"%@",response);
                
                [self dismissViewControllerAnimated:NO completion:nil];
                NSString *paramStr = [NSString stringWithFormat:@"&COMPLAINT_ID=%@&ANSWER_PDF_JPG_NAME=%@.jpg&BI_ID=%@",selectedComplaintID,timeStr,biID];
                [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/forwardNoticeAnsofCitizenToBI.php" withBlock:^(NSString *message, id response) {
                    
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
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [uploadAlert addAction:camera];
    [uploadAlert addAction:gallery];
    [uploadAlert addAction:cancle];
    
    [uploadAlert setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [uploadAlert
                                                     popoverPresentationController];
    popPresenter.sourceView = _uploadBtn;
    popPresenter.sourceRect = _uploadBtn.bounds;
    [self presentViewController:uploadAlert animated:YES completion:nil];
    
    //[self presentViewController:uploadAlert animated:YES completion:nil];
}


- (IBAction)searchBtnClicked:(id)sender {
}

- (IBAction)allBtnClicked:(id)sender {
}

- (IBAction)dropDownBtnClicked:(id)sender {
   
    if ([_downArrowImg.image isEqual:[UIImage imageNamed:@"upArrow.png"]]) {
        _downArrowImg.image = [UIImage imageNamed:@"dropDownArrow"];
    }
    else {
        _downArrowImg.image = [UIImage imageNamed:@"upArrow.png"];
    }
    if(dropDown == nil)
    {
        CGFloat f;
        if ([deviceType isEqualToString:@"iPhone"])
        {
            f = 120;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :officiersArray :@[] :@"up" :_downArrowImg];
        }
        else
        {
            
            if ([officiersArray count] > 4) {
                f = 160;
            }
            else {
                f = 40 * [officiersArray count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :officiersArray :@[] :@"down" :_downArrowImg];
        }
        
        dropDown.delegate = self;
    }
    else
    {
        //_downArrowImg.image = [UIImage imageNamed:@"upArrow"];
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)previewBtnClicked:(id)sender {
}

- (IBAction)logoutBtnClicked:(id)sender {
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"SESSION"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"USER_ID"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"TYPE"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//    UIStoryboard *storyboard;
//    if ([deviceType isEqualToString:@"iPhone"]) {
//        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    }
//    else {
//        storyboard = [UIStoryboard storyboardWithName:@"UC_iPad" bundle:nil];
//    }
//    
//    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UCLoginViewController"];
//    
//    [self.navigationController pushViewController:viewController animated:NO];
}
@end
