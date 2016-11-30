//
//  DashboardViewController.m
//  UC
//
//  Created by HardCastle on 08/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardCollectionViewCell.h"
#import "DataManager.h"
#import "Helper.h"

@interface DashboardViewController ()
{
    NSMutableArray *imgArray;
    NSString *userType;
}

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = true;
    self.title = @"DASHBOARD - DESK";
    
    userType = [[[DataManager shareInstance] userDefaults] objectForKey:@"USER_TYPE"];
    imgArray = [[NSMutableArray alloc] init];
    
    if ([userType isEqualToString:@"CL"]) {
        [imgArray addObject:@"Forward new  Cases to DE with auto generate Unique ID and Date"];
        [imgArray addObject:@"Forward Notice answers of  Occupier"];
        [imgArray addObject:@"Forward Notice answers from Occupier"];
    }
    else if([userType isEqualToString:@"DE"]) {
        [imgArray addObject:@"New Cases from DESK"];
        [imgArray addObject:@"Inspection report and  Occupier Notice"];
        [imgArray addObject:@"Citizen answers Cases from BI"];
    }
    else if ([userType isEqualToString:@"DO"]) {

        [imgArray addObject:@"Forward new  Cases to DE with auto generate Unique ID and Date"];
        [imgArray addObject:@"Forward Notice answers from Occupier"];
        [imgArray addObject:@"Forward Notice answers of  Occupier"];
    }
    else if ([userType isEqualToString:@"BI"]) {
        [imgArray addObject:@"General Registration of Complaint"];
        [imgArray addObject:@"Report"];
        [imgArray addObject:@"Not Ans Cases"];
        [imgArray addObject:@"Notice"];
        [imgArray addObject:@"2nd Notice"];
        [imgArray addObject:@"Report Demolition Structure"];
        [imgArray addObject:@"Ans Cases"];
      
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imgArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DashboardCollectionViewCell *cell = (DashboardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"dashboardCell" forIndexPath:indexPath];

    [cell.dashboardCollectionViewBtn setBackgroundImage:[UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [cell.dashboardCollectionViewBtn setTag:indexPath.row];
    [cell.dashboardCollectionViewBtn addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - Button click events

- (IBAction)cellBtnClicked:(UIButton *)sender {
    
    NSLog(@"%ld",(long)sender.tag);
    [self performSegueWithIdentifier:[imgArray objectAtIndex:sender.tag] sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)firstBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"forwardCaseSegue" sender:nil];
}

- (IBAction)secondBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"ofOccupier" sender:nil];
}

- (IBAction)thirdBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"fromOccupier" sender:nil];
}

- (IBAction)logoutBtnClicked:(id)sender {
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"SESSION"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"USER_ID"];
    [[[DataManager shareInstance] userDefaults] removeObjectForKey:@"TYPE"];
    
//    UIStoryboard *storyboard;
//    if ([deviceType isEqualToString:@"iPhone"]) {
//        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    }
//    else {
//        storyboard = [UIStoryboard storyboardWithName:@"UC_iPad" bundle:nil];
//    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UCLoginViewController"];
    
    //[self.navigationController pushViewController:viewController animated:NO];
}


@end
