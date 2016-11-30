//
//  AnsweredCasesViewController.m
//  UC
//
//  Created by HardCastle on 28/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "AnsweredCasesViewController.h"
#import "ReportTableViewCell.h"
#import "Helper.h"
#import "DataManager.h"
#import "APIManager.h"

@interface AnsweredCasesViewController ()
{
    NSMutableArray *casesArray;
    NSString *selectedComplaintID;
    UIAlertController *alert;
    NSMutableArray *dropDownElements;
    NSMutableArray *officersIdArray;
    NIDropDown *dropDown;
    NSString *deID;
}
@property (weak, nonatomic) IBOutlet UITableView *casesTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImg;

@end

@implementation AnsweredCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    casesArray = [[NSMutableArray alloc] init];
    dropDownElements = [[NSMutableArray alloc] init];
    officersIdArray = [[NSMutableArray alloc] init];
    
    NSString *paramStr = [NSString stringWithFormat:@"&BI_ID=%@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]];
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/fetchCitizenAnswerFor_BI.php" withBlock:^(NSString *message, id response) {
        
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
    
    [[APIManager new] getRequest:@"_IPHONE/PMC_UC/fetch_Officers_Name.php" withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            
            NSMutableArray *officersArray = [[NSMutableArray alloc] init];
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
        [_tableScrollView setContentSize:CGSizeMake(1054,_tableScrollView.frame.size.height)];
    }
    else {
        [_tableScrollView setContentSize:CGSizeMake(1654,_tableScrollView.frame.size.height)];
    }
}

#pragma mark - TableView Datasourse/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [casesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.srNoLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.caseId.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
    cell.inwardNoLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"INWARD_NO"];
    cell.zoneLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"ZONE"];
    cell.areaLabel.text = @"";
    cell.applicantNameLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"NAME"];
    cell.applicantAddress.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"ADDRESS"];
    
    if ([[[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ADDRESS"] isKindOfClass:[NSNull class]]) {
        cell.complaintAddressLabel.text = @"-";
    }
    else {
        cell.complaintAddressLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ADDRESS"];
    }
    
    cell.mobileNoLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"MOBILE_NO"];
    cell.emailIdLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"EMAIL_ID"];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.30 green:0.56 blue:1.00 alpha:1.0]];
    selectedComplaintID = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
}


#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    deID = [officersIdArray objectAtIndex:_dropDownBtn.tag];
}


#pragma mark - Button Click events
- (IBAction)dropDownBtnClicked:(id)sender {
    
    
    if ([_dropDownImg.image isEqual:[UIImage imageNamed:@"upArrow.png"]]) {
        _dropDownImg.image = [UIImage imageNamed:@"dropDownArrow"];
    }
    else {
        _dropDownImg.image = [UIImage imageNamed:@"upArrow.png"];
    }
    
    if(dropDown == nil)
    {
        CGFloat f;
        if ([deviceType isEqualToString:@"iPhone"])
        {
            f = 120;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dropDownElements :@[] :@"up" :_dropDownImg];
        }
        else
        {
            
            if ([dropDownElements count] > 4) {
                f = 160;
            }
            else {
                f = 40 * [dropDownElements count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dropDownElements :@[] :@"down" :_dropDownImg];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
