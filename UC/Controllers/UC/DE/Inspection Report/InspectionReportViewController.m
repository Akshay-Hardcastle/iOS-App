//
//  InspectionReportViewController.m
//  UC
//
//  Created by HardCastle on 16/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "InspectionReportViewController.h"
#import "APIManager.h"
#import "Helper.h"
#import "StatusTableViewCell.h"
#import "DataManager.h"

@interface InspectionReportViewController ()
{
    NSMutableArray *casesArray;
    NSString *selectedComplaintID;
    UIAlertController *alert;
    NSMutableArray *officiersArray;
    NSMutableArray *officierIdArray;
    NIDropDown *dropDown;
    NSString *biID;
}
@property (weak, nonatomic) IBOutlet UIImageView *dropDownImg;
@property (weak, nonatomic) IBOutlet UIButton *dropDownBtn;
@property (weak, nonatomic) IBOutlet UITableView *casesTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
- (IBAction)dropDownBtnClicked:(id)sender;
@end

@implementation InspectionReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"INSPECTION REPORT AND NOTICE";
    casesArray = [[NSMutableArray alloc] init];
    officiersArray = [[NSMutableArray alloc] init];
    officierIdArray = [[NSMutableArray alloc] init];
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    
    NSString *tempUrl = [NSString stringWithFormat:@"_IPHONE/PMC_UC/fetch_site_visited_cases_for_DE.php?DE_ID=%@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]];
    [[APIManager new] postRequest:@"" url:tempUrl withBlock:^(NSString *message, id response) {
        
        [alert dismissViewControllerAnimated:NO completion:nil];
        if ([message isEqualToString:kSuccess]) {
            
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
            
            NSMutableArray *responseArray = [[NSMutableArray alloc] init];
            [responseArray addObjectsFromArray:[response objectForKey:@"data"]];
            
            NSLog(@"%@",responseArray);
            
            for (NSDictionary *dict in responseArray) {
                
                NSArray *tempArray = [dict objectForKey:@"BI"];
                for (NSDictionary *userDict in tempArray) {
                    
                    [officiersArray addObject:[userDict objectForKey:@"NAME"]];
                    [officierIdArray addObject:[userDict objectForKey:@"USER_ID"]];
                }
            }
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
        [_tableScrollView setContentSize:CGSizeMake(1300,_tableScrollView.frame.size.height)];
    }
    else {
        [_tableScrollView setContentSize:CGSizeMake(2000,_tableScrollView.frame.size.height)];
    }
}


#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    NSLog(@"%ld",(long)_dropDownBtn.tag);
    NSLog(@"%@",[officierIdArray objectAtIndex:_dropDownBtn.tag]);
    biID = [officierIdArray objectAtIndex:_dropDownBtn.tag];
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
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :officiersArray :@[] :@"down" :_dropDownImg];
        }
        else
        {
            
            if ([officiersArray count] > 4) {
                f = 160;
            }
            else {
                f = 40 * [officiersArray count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :officiersArray :@[] :@"down" :_dropDownImg];
        }
        
        dropDown.delegate = self;
    }
    else
    {
        //_dropDownImg.image = [UIImage imageNamed:@"upArrow"];
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }

}

- (IBAction)nextBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"nextSegue" sender:nil];
}


@end
