//
//  CasesFromBIViewController.m
//  UC
//
//  Created by HardCastle on 16/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "CasesFromBIViewController.h"
#import "Helper.h"
#import "ReportTableViewCell.h"
#import "APIManager.h"
#import "DataManager.h"

@interface CasesFromBIViewController ()
{
    NSMutableArray *complaintsArray;
    NSMutableArray *officersArray;
    NSMutableArray *officersIdArray;
    NSMutableArray *dropDownElements;
    UIAlertController *alert;
    NIDropDown *dropDown;
    NSString *complaintID;
    NSString *biID;
}
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UITableView *casesTableView;
@property (weak, nonatomic) IBOutlet UIButton *secondNoticeBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectCaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeCaseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImg;

- (IBAction)dropDownBtnClicked:(id)sender;
- (IBAction)showPhotographBtnClicked:(id)sender;
- (IBAction)showNoticebtnClicked:(id)sender;
- (IBAction)showRemarkBtnClicked:(id)sender;
- (IBAction)secondBtnClicked:(id)sender;
- (IBAction)rejectCaseBtnClicked:(id)sender;
- (IBAction)closeBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;
@end

@implementation CasesFromBIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CITIZEN ANSWER";
    
    complaintsArray = [[NSMutableArray alloc] init];
    officersArray = [[NSMutableArray alloc] init];
    officersIdArray = [[NSMutableArray alloc] init];
    dropDownElements = [[NSMutableArray alloc] init];
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    
    NSString *paramStr = [NSString stringWithFormat:@"DE_ID=%@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]];
    
    [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/fetch_casesfrom_DE_ID.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            [complaintsArray addObjectsFromArray:[response objectForKey:@"DATA"]];
            NSLog(@"%@",complaintsArray);
            [_casesTableView reloadData];
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
    _tableScrollView.scrollEnabled = YES;
    if ([deviceType isEqualToString:@"iPhone"]) {
        [_tableScrollView setContentSize:CGSizeMake(1054,_scrollViewHeightConstraint.constant)];
    }
    else {
        [_tableScrollView setContentSize:CGSizeMake(1700,_scrollViewHeightConstraint.constant)];
    }
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
    cell.caseId.text = [[complaintsArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
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
}


#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    NSLog(@"%ld",(long)_dropDownBtn.tag);
    NSLog(@"%@",[officersIdArray objectAtIndex:_dropDownBtn.tag]);
    biID = [officersIdArray objectAtIndex:_dropDownBtn.tag];
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
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dropDownElements :@[] :@"down" :_downArrowImg];
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

- (IBAction)showPhotographBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"fullScreenImgSegue" sender:nil];
}

- (IBAction)showNoticebtnClicked:(id)sender {
}

- (IBAction)showRemarkBtnClicked:(id)sender {
}

- (IBAction)secondBtnClicked:(id)sender {
    [_secondNoticeBtn setBackgroundColor:[UIColor colorWithRed:0.42 green:0.75 blue:0.27 alpha:1.0]];
    [_rejectCaseBtn setBackgroundColor:[UIColor colorWithRed:0.00 green:0.27 blue:0.49 alpha:1.0]];
    [_closeCaseBtn setBackgroundColor:[UIColor colorWithRed:0.00 green:0.27 blue:0.49 alpha:1.0]];
}

- (IBAction)rejectCaseBtnClicked:(id)sender {
    [_secondNoticeBtn setBackgroundColor:[UIColor colorWithRed:0.00 green:0.27 blue:0.49 alpha:1.0]];
    [_rejectCaseBtn setBackgroundColor:[UIColor colorWithRed:0.42 green:0.75 blue:0.27 alpha:1.0]];
    [_closeCaseBtn setBackgroundColor:[UIColor colorWithRed:0.00 green:0.27 blue:0.49 alpha:1.0]];
}

- (IBAction)closeBtnClicked:(id)sender {
    [_secondNoticeBtn setBackgroundColor:[UIColor colorWithRed:0.00 green:0.27 blue:0.49 alpha:1.0]];
    [_rejectCaseBtn setBackgroundColor:[UIColor colorWithRed:0.00 green:0.27 blue:0.49 alpha:1.0]];
    [_closeCaseBtn setBackgroundColor:[UIColor colorWithRed:0.42 green:0.75 blue:0.27 alpha:1.0]];
}

- (IBAction)submitBtnClicked:(id)sender {
}
@end
