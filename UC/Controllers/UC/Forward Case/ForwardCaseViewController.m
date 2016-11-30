//
//  ForwardCaseViewController.m
//  UC
//
//  Created by HardCastle on 11/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "ForwardCaseViewController.h"
#import "ReportTableViewCell.h"
#import "APIManager.h"
#import "Helper.h"
#import "NIDropDown.h"
#import "DataManager.h"


@interface ForwardCaseViewController ()
{
    UIAlertController *alert;
    NSMutableArray *complaintsArray;
    NSMutableArray *officersArray;
    
    NSMutableArray *officersIdArray;
    NSMutableArray *dropDownElements;
    
    NSString *complaintID;
    NSString *deID;
    NIDropDown *dropDown;
}

@property (weak, nonatomic) IBOutlet UITableView *forwadCasesTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;


@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImg;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;


@property (weak, nonatomic) IBOutlet UITextField *villageTxtField;
@property (weak, nonatomic) IBOutlet UITextField *zoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *complaintDetailsTextView;
@property (weak, nonatomic) IBOutlet UITextView *uniqueIdTextView;



@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
- (IBAction)fromBtnClicked:(id)sender;
- (IBAction)toBtnClicked:(id)sender;
- (IBAction)searchBtnClicked:(id)sender;
- (IBAction)allBtnClicked:(id)sender;
- (IBAction)villageTextField:(id)sender;
- (IBAction)dropBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)logoutBtnClicked:(id)sender;

@end

@implementation ForwardCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FORWARD CASE";
    complaintsArray = [[NSMutableArray alloc] init];
    officersArray = [[NSMutableArray alloc] init];
    dropDownElements = [[NSMutableArray alloc] init];
    officersIdArray = [[NSMutableArray alloc] init];
    
    _complaintDetailsTextView.text = @"Enter complaint details here";
    _complaintDetailsTextView.textColor = [UIColor lightGrayColor];
    [[_complaintDetailsTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_complaintDetailsTextView layer] setBorderWidth:1];
    
    [[_uniqueIdTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_uniqueIdTextView layer] setBorderWidth:1];
    
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    
    [[APIManager new] getRequest:@"_IPHONE/PMC_UC/fetch_Complaints.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            [complaintsArray addObjectsFromArray:[response objectForKey:@"DATA"]];
            NSLog(@"%@",complaintsArray);
           // _tableViewHeightConstraint.constant = [complaintsArray count] * 60;
            //_scrollViewHeightConstraint.constant = _tableViewHeightConstraint.constant + 60;
            [_forwadCasesTableView reloadData];
        }
        else {
             [Helper showAlertMessage:@"UC" andMessage:@"Connection Error"];
        }
    }];
    
    
    [[APIManager new] getRequest:@"_IPHONE/PMC_UC/fetch_Officers_Name.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            [officersArray addObjectsFromArray:[response objectForKey:@"data"]];
            NSLog(@"%@",officersArray);
            
            for (NSDictionary *dict in officersArray) {
                
                //NSArray *tempArray = [dict objectForKey:[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_TYPE"]];
                NSArray *tempArray = [dict objectForKey:@"DE"];
                for (NSDictionary *userDict in tempArray) {
                    
                    [dropDownElements addObject:[userDict objectForKey:@"NAME"]];
                    [officersIdArray addObject:[userDict objectForKey:@"USER_ID"]];
                }
            }
            [_dropDownBtn setTitle:[dropDownElements objectAtIndex:0] forState:UIControlStateNormal];
            deID = [officersIdArray objectAtIndex:0];
        }
        else {
            [Helper showAlertMessage:@"UC" andMessage:@"Connection Error"];
        }
    }];
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableScrollView.scrollEnabled = YES;
    if ([deviceType isEqualToString:@"iPhone"]) {
        [_tableScrollView setContentSize:CGSizeMake(1054,_tableScrollView.frame.size.height)];
    }
    else {
        [_tableScrollView setContentSize:CGSizeMake(1662,_scrollViewHeightConstraint.constant)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [complaintsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.srNoLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.caseId.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
    cell.inwardNoLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"INWARD_NO"];
    cell.zoneLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"ZONE"];
    cell.areaLabel.text = @"";
    cell.applicantNameLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"NAME"];
    cell.applicantAddress.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"ADDRESS"];
    cell.complaintAddressLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ADDRESS"];
    cell.mobileNoLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"MOBILE_NO"];
    cell.emailIdLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"EMAIL_ID"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.30 green:0.56 blue:1.00 alpha:1.0]];
    complaintID = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
    
}

#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    NSLog(@"%ld",(long)_dropDownBtn.tag);
    NSLog(@"%@",[officersIdArray objectAtIndex:_dropDownBtn.tag]);
    deID = [officersIdArray objectAtIndex:_dropDownBtn.tag];
}


#pragma mark - Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_villageTxtField resignFirstResponder];
    [_zoneTextField resignFirstResponder];
    [_complaintDetailsTextView resignFirstResponder];
}

#pragma mark - TExtField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (textView == _complaintDetailsTextView) {
        
        if ([deviceType isEqualToString:@"iPhone"]) {
            [UIView beginAnimations: @"animateTextField" context: nil];
            [UIView setAnimationBeginsFromCurrentState: YES];
            [UIView setAnimationDuration: 0.3f];
            self.view.frame = CGRectOffset(self.view.frame, 0, -180);
            [UIView commitAnimations];
        }
        if ([_complaintDetailsTextView.text isEqualToString:@"Enter complaint details here"]) {
            _complaintDetailsTextView.text = @"";
            _complaintDetailsTextView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (textView == _complaintDetailsTextView && [deviceType isEqualToString:@"iPhone"]) {
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
    if (textView == _complaintDetailsTextView) {
        if(_complaintDetailsTextView.text.length == 0){
            _complaintDetailsTextView.textColor = [UIColor lightGrayColor];
            _complaintDetailsTextView.text = @"Enter complaint details here";
            [_complaintDetailsTextView resignFirstResponder];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button events

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

    if ([deviceType isEqualToString:@"iPhone"]) {
        [self presentViewController:alertController  animated:YES completion:nil];
    }
    else {
        UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
        popoverController.sourceView = sender;
        popoverController.sourceRect = [sender bounds];
        [self presentViewController:alertController  animated:YES completion:nil];
    }
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
    if ([deviceType isEqualToString:@"iPhone"]) {
        [self presentViewController:alertController  animated:YES completion:nil];
    }
    else {
        UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
        popoverController.sourceView = sender;
        popoverController.sourceRect = [sender bounds];
        [self presentViewController:alertController  animated:YES completion:nil];
    }
}

- (IBAction)searchBtnClicked:(id)sender {
}

- (IBAction)allBtnClicked:(id)sender {
}

- (IBAction)villageTextField:(id)sender {
}

- (IBAction)dropBtnClicked:(id)sender {

    //_downArrowImg.image = [UIImage imageNamed:@"upArrow.png"];
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
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dropDownElements :@[] :@"up" :_downArrowImg];
        }
        else
        {
           
            if ([dropDownElements count] > 4) {
                 f = 160;
            }
            else {
                f = 40 * [dropDownElements count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dropDownElements :@[] :@"down" :_downArrowImg];
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

- (IBAction)submitBtnClicked:(id)sender {
    
    if ([_complaintDetailsTextView.text isEqualToString:@"Enter complaint details here"] || [_complaintDetailsTextView.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter complaint details"] animated:YES completion:nil];
    }
    else if ([_uniqueIdTextView.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please press on Unique Id button to generate inward number"] animated:YES completion:nil];
    }
    else if ([_dateBtn.titleLabel.text isEqualToString:@"DATE"]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please press on Date button to select date"] animated:YES completion:nil];
    }
    else if (complaintID == NULL) {
         [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please "] animated:YES completion:nil];
    }
    else {
        //COMPLAINT_ID,INWARD_NO,INWARD_DATE,DE_ID,CLERK_ID,DETAILS_BY_CLERK
        // $COMPLAINT_ID= $_POST['COMPLAINT_ID'];
        //$INWARD_NO= $_POST['INWARD_NO'];
        //$INWARD_DATE= $_POST['INWARD_DATE'];
        //$DE_ID= $_POST['DE_ID'];
        //$CLERK_ID= $_POST['CLERK_ID'];
        //$DETAILS_BY_CLERK= $_POST['DETAILS_BY_CLERK'];
        
        NSString *param = [NSString stringWithFormat:@"&COMPLAINT_ID=%@&INWARD_NO=%@&INWARD_DATE=%@&DE_ID=%@&CLERK_ID=%@&DETAILS_BY_CLERK=%@",complaintID,_uniqueIdTextView.text,_dateBtn.titleLabel.text,deID,[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"],_complaintDetailsTextView.text];
        
        NSLog(@"%@",param);
        [self presentViewController:alert animated:NO completion:nil];
        [[APIManager new] postRequest:param url:@"_IPHONE/PMC_UC/clerk_Entry.php" withBlock:^(NSString *message, id reponse) {
            
            [alert dismissViewControllerAnimated:NO completion:nil];
            if ([message isEqualToString:kSuccess]) {
              
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"UC" message:@"Data sent successfully" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [successAlert addAction:ok];
                [self presentViewController:successAlert animated:YES completion:nil];
            }
            else {
                [Helper showAlertMessage:@"UC" andMessage:@"Connection Error"];
            }
            
        }];
    }
}

- (IBAction)logoutBtnClicked:(id)sender {
    
    NSLog(@"logout");
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"SESSION"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"USER_ID"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"TYPE"];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
//       UIStoryboard *storyboard;
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

- (IBAction)dateBtnClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"OK");
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yy hh:mm a"];
            NSString *dateString = [formatter stringFromDate:picker.date];
            NSLog(@"%@",dateString);
            
            [_dateBtn setTitle:dateString forState:UIControlStateNormal];
        }];
        action;
    })];
    if ([deviceType isEqualToString:@"iPhone"]) {
        [self presentViewController:alertController  animated:YES completion:nil];
    }
    else {
        UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
        popoverController.sourceView = sender;
        popoverController.sourceRect = [sender bounds];
        [self presentViewController:alertController  animated:YES completion:nil];
    }
}

- (IBAction)uniqueIdBtnClicked:(id)sender {
    int r = arc4random() % 20000 + 10000;
    
    _uniqueIdTextView.text = [NSString stringWithFormat:@"%d",r];
}


@end
