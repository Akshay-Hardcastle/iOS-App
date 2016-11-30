//
//  NewCaseViewController.m
//  UC
//
//  Created by HardCastle on 16/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "NewCaseViewController.h"
#import "DataManager.h"
#import "APIManager.h"
#import "Helper.h"
#import "ReportTableViewCell.h"
#import "NIDropDown.h"

@interface NewCaseViewController ()
{
    NSMutableArray *complaintsArray;
    UIAlertController *alert;
    NSMutableArray *officersArray;
    NSMutableArray *officersIdArray;
    NSMutableArray *dropDownElements;
    NSString *biID;
    NSString *complaintID;
    NIDropDown *dropDown;
    NSString *urlStr;
    NSString *paramStr;
}
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet UIButton *complaintDetailsBtn;
@property (weak, nonatomic) IBOutlet UITableView *caseTableView;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImg;
@property (weak, nonatomic) IBOutlet UITextView *complaintdetailsTextView;

- (IBAction)dropDownBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)previewBtnClicked:(id)sender;

@end

@implementation NewCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CASE FROM CLERK";
    
    complaintsArray = [[NSMutableArray alloc] init];
    officersArray = [[NSMutableArray alloc] init];
    officersIdArray = [[NSMutableArray alloc] init];
    dropDownElements = [[NSMutableArray alloc] init];
    
    _complaintdetailsTextView.text = @"Enter complaint details here";
    _complaintdetailsTextView.textColor = [UIColor lightGrayColor];
    [[_complaintdetailsTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_complaintdetailsTextView layer] setBorderWidth:1];
    
    if([[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_TYPE"] isEqualToString:@"BI"]) {
        [_complaintDetailsBtn setTitle:@"REMARK:" forState:UIControlStateNormal];
        urlStr = @"_IPHONE/PMC_UC/fetch_unanswered_cases_bi.php";
        paramStr = [NSString stringWithFormat:@"BI_ID=%@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]];
        [_dropDownBtn setHidden:YES];
        [_downArrowImg setHidden:YES];
    }
    else {
        urlStr = @"_IPHONE/PMC_UC/fetch_Cases_For_DE.php";
        paramStr = [NSString stringWithFormat:@"DE_ID=%@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]];
    }
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];

    
    [[APIManager new] postRequest:paramStr url:urlStr withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            [complaintsArray addObjectsFromArray:[response objectForKey:@"DATA"]];
            NSLog(@"%@",complaintsArray);
            // _tableViewHeightConstraint.constant = [complaintsArray count] * 60;
            //_scrollViewHeightConstraint.constant = _tableViewHeightConstraint.constant + 60;
            [_caseTableView reloadData];
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
                NSArray *tempArray = [dict objectForKey:@"BI"];
                for (NSDictionary *userDict in tempArray) {
                    
                    [dropDownElements addObject:[userDict objectForKey:@"NAME"]];
                    [officersIdArray addObject:[userDict objectForKey:@"USER_ID"]];
                }
            }
            
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
    _caseTableView.scrollEnabled = YES;
    if ([deviceType isEqualToString:@"iPhone"]) {
        [_tableScrollView setContentSize:CGSizeMake(1054,_tableScrollView.frame.size.height)];
    }
    else {
        [_tableScrollView setContentSize:CGSizeMake(1662,_tableScrollView.frame.size.height)];
    }
}


#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    NSLog(@"%ld",(long)_dropDownBtn.tag);
    NSLog(@"%@",[officersIdArray objectAtIndex:_dropDownBtn.tag]);
    biID = [officersIdArray objectAtIndex:_dropDownBtn.tag];
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
    
    if ([[[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ADDRESS"] isKindOfClass:[NSNull class]]) {
        cell.complaintAddressLabel.text = @"-";
    }
    else {
        cell.complaintAddressLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ADDRESS"];
    }
    
    cell.mobileNoLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"MOBILE_NO"];
    cell.emailIdLabel.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"EMAIL_ID"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.30 green:0.56 blue:1.00 alpha:1.0]];
    complaintID = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
    _complaintdetailsTextView.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_DETAILS"];
}

#pragma mark - TextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (textView == _complaintdetailsTextView) {

        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        self.view.frame = CGRectOffset(self.view.frame, 0, -180);
        [UIView commitAnimations];
        
        if ([_complaintdetailsTextView.text isEqualToString:@"Enter complaint details here"]) {
            _complaintdetailsTextView.text = @"";
            _complaintdetailsTextView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (textView == _complaintdetailsTextView) {
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
    if (textView == _complaintdetailsTextView) {
        if(_complaintdetailsTextView.text.length == 0){
            _complaintdetailsTextView.textColor = [UIColor lightGrayColor];
            _complaintdetailsTextView.text = @"Enter complaint details here";
            [_complaintdetailsTextView resignFirstResponder];
        }
    }
}


#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_complaintdetailsTextView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Click events
- (IBAction)dropDownBtnClicked:(id)sender {
    
    [_complaintdetailsTextView resignFirstResponder];
    
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
    
    if (complaintID == NULL || [complaintID isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select case"] animated:NO completion:nil];
    }
    else if ((biID == NULL || [biID isEqualToString:@""]) && ![[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_TYPE"] isEqualToString:@"BI"]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select BI"] animated:NO completion:nil];
    }
    else if ([_complaintdetailsTextView.text isEqualToString:@"Enter complaint details here"] || [_complaintdetailsTextView.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter complaints details"] animated:NO completion:nil];
    }
    else {
        //COMPLAINT_ID,DE_ID,DETAILS_BY_DE
        NSString *param = [NSString stringWithFormat:@"&COMPLAINT_ID=%@&BI_ID=%@&DETAILS_BY_DE=%@",complaintID,biID,_complaintdetailsTextView.text];
        
        [self presentViewController:alert animated:NO completion:nil];
        [[APIManager new] postRequest:param url:@"_IPHONE/PMC_UC/de_Entry.php" withBlock:^(NSString *message, id response) {
            
            [alert dismissViewControllerAnimated:NO completion:nil];
            if ([message isEqualToString:kSuccess]) {
               [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Successfully sent"] animated:NO completion:nil];
            }
            else {
                [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please try again"] animated:NO completion:nil];
            }
        }];
    }
}   

- (IBAction)previewBtnClicked:(id)sender {
    
}

@end
