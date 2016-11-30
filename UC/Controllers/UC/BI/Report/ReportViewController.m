//
//  ReportViewController.m
//  UC
//
//  Created by HardCastle on 18/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "ReportViewController.h"
#import "Helper.h"
#import "DataManager.h"
#import "APIManager.h"
#import "ReportTableViewCell.h"

@interface ReportViewController ()
{
    NSMutableArray *casesArray;
    NSString *complaintID;
    UIAlertController *alert;
    NIDropDown *dropDown;
    NSArray *dropDownElements;
    NSString *workType;
}
@property (weak, nonatomic) IBOutlet UITextField *occupierNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *complaintSRTextField;
@property (weak, nonatomic) IBOutlet UITextField *floorStructureTextField;
@property (weak, nonatomic) IBOutlet UITextField *lengthTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *widthTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *areaTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *rccImg;
@property (weak, nonatomic) IBOutlet UIButton *rccBtn;
@property (weak, nonatomic) IBOutlet UIButton *brickWorkImg;
@property (weak, nonatomic) IBOutlet UIButton *brickWorkBtn;
@property (weak, nonatomic) IBOutlet UIButton *shedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *floorDropDownImg;
@property (weak, nonatomic) IBOutlet UIButton *floorDropDownBtn;


@property (weak, nonatomic) IBOutlet UITextView *otherDetailsTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *tableScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *SubViewScrollView;
@property (weak, nonatomic) IBOutlet UITableView *casesTableView;


- (IBAction)rccClick:(id)sender;
- (IBAction)brickWorkClick:(id)sender;
- (IBAction)shedClick:(id)sender;
- (IBAction)floorStructureDropDownBtnClicked:(id)sender;


@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"INSOECTION REPORT - 1";
    _otherDetailsTextView.text = @"Enter other details";
    _otherDetailsTextView.textColor = [UIColor lightGrayColor];
    [[_otherDetailsTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[_otherDetailsTextView layer] setBorderWidth:1];
    
    [_brickWorkImg setBackgroundImage:[UIImage imageNamed:@"Circled Dot Filled"] forState:UIControlStateNormal];
     workType = @"BRICK WORK";
    
    casesArray = [[NSMutableArray alloc] init];
    dropDownElements = [[NSMutableArray alloc] init];
    
    dropDownElements = @[@"G",@"G+1",@"G+2",@"G+3",@"G+4",@"G+5"];
    
    NSLog(@"ss %@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]);
    
    NSString *paramStr = [NSString stringWithFormat:@"&BI_ID=%@",[[[DataManager shareInstance] userDefaults] objectForKey:@"USER_ID"]];
    
    alert = [Helper showLoader];
    [self presentViewController:alert animated:NO completion:nil];
    [[APIManager new] postRequest:paramStr url:@"_IPHONE/PMC_UC/fetch_Cases_For_BI.php" withBlock:^(NSString *message, id response) {
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableScrollView.scrollEnabled = YES;
    _SubViewScrollView.scrollEnabled = YES;
    
    if ([deviceType isEqualToString:@"iPhone"]) {
        [_tableScrollView setContentSize:CGSizeMake(1054,_scrollViewHeightConstraint.constant)];
        [_SubViewScrollView setContentSize:CGSizeMake(300,350)];
    }
    else {
        [_tableScrollView setContentSize:CGSizeMake(1700,_scrollViewHeightConstraint.constant)];
        [_SubViewScrollView setContentSize:CGSizeMake(768,500)];
    }
}


#pragma mark - TableView Delegate

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

    //cell.complaintAddressLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ADDRESS"];
    cell.mobileNoLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"MOBILE_NO"];
    cell.emailIdLabel.text = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"EMAIL_ID"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.30 green:0.56 blue:1.00 alpha:1.0]];
    complaintID = [[casesArray objectAtIndex:indexPath.row] objectForKey:@"COMPLAINT_ID"];
    
}


#pragma mark - TextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    if (textView == _otherDetailsTextView) {
        
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        self.view.frame = CGRectOffset(self.view.frame, 0, -200);
        [UIView commitAnimations];

        if ([_otherDetailsTextView.text isEqualToString:@"Enter other details"]) {
            _otherDetailsTextView.text = @"";
            _otherDetailsTextView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (textView == _otherDetailsTextView) {
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        self.view.frame = CGRectOffset(self.view.frame, 0, 200);
        [UIView commitAnimations];
    }
    
    return YES;
}


-(void) textViewDidChange:(UITextView *)textView
{
    if (textView == _otherDetailsTextView) {
        if(_otherDetailsTextView.text.length == 0){
            _otherDetailsTextView.textColor = [UIColor lightGrayColor];
            _otherDetailsTextView.text = @"Enter other details";
            [_otherDetailsTextView resignFirstResponder];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_lengthTextFiled resignFirstResponder];
    [_widthTextFiled resignFirstResponder];
    [_areaTextFiled resignFirstResponder];
    [_complaintSRTextField resignFirstResponder];
    [_occupierNameTextField resignFirstResponder];
    [_complaintSRTextField resignFirstResponder];
    [_floorStructureTextField resignFirstResponder];
}



#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //if ([deviceType isEqualToString:@"iPhone"])
    //{
    [self animateTextField:textField up:YES];
    // }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // if ([deviceType isEqualToString:@"iPhone"])
    // {
    [self animateTextField:textField up:NO];
    // }
}


-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    int movementDistance = 0;
    
    if ([deviceType isEqualToString:@"iPhone"])
    {
        if (textField.tag == 101)
        {
            movementDistance = -125;
        }
        else if(textField.tag == 102)
        {
            movementDistance = -125;
        }
        else if(textField.tag == 103)
        {
            movementDistance = -125;
        }

    }
    else {
        if (textField.tag == 101)
        {
            movementDistance = -125;
        }
        else if(textField.tag == 102)
        {
            movementDistance = -125;
        }
        else if(textField.tag == 103)
        {
            movementDistance = -125;
        }
    }
    const float movementDuration = 0.3f;
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Button Events


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)rccClick:(id)sender {
    if ([_rccImg.currentBackgroundImage isEqual:[UIImage imageNamed:@"Circled Dot Filled"]]) {
        
        //[_rccImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_brickWorkImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_shedBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        workType = @"RCC";
    }
    else {
        [_rccImg setBackgroundImage:[UIImage imageNamed:@"Circled Dot Filled"] forState:UIControlStateNormal];
        [_brickWorkImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_shedBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        workType = @"RCC";
    }
}

- (IBAction)brickWorkClick:(id)sender {
    
    if ([_brickWorkBtn.imageView.image isEqual:[UIImage imageNamed:@"Circled Dot Filled"]]) {
        [_rccImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        //[_brickWorkBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_shedBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        workType = @"BRICK WORK";
    }
    else {
        [_rccImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_brickWorkImg setBackgroundImage:[UIImage imageNamed:@"Circled Dot Filled"] forState:UIControlStateNormal];
        [_shedBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        workType = @"BRICK WORK";
    }
}

- (IBAction)shedClick:(id)sender {
    
    if ([_shedBtn.imageView.image isEqual:[UIImage imageNamed:@"Circled Dot Filled"]]) {
        [_rccImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_brickWorkImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        //[_shedBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        workType = @"SHED";
    }
    else {
        [_rccImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_brickWorkImg setBackgroundImage:[UIImage imageNamed:@"Unchecked Circle"] forState:UIControlStateNormal];
        [_shedBtn setBackgroundImage:[UIImage imageNamed:@"Circled Dot Filled"] forState:UIControlStateNormal];
        workType = @"SHED";
    }
}

- (IBAction)floorStructureDropDownBtnClicked:(id)sender {
    
    if ([_floorDropDownImg.image isEqual:[UIImage imageNamed:@"upArrow.png"]]) {
        _floorDropDownImg.image = [UIImage imageNamed:@"dropDownArrow"];
    }
    else {
        _floorDropDownImg.image = [UIImage imageNamed:@"upArrow.png"];
    }
    
    if(dropDown == nil)
    {
        CGFloat f;
        if ([deviceType isEqualToString:@"iPhone"])
        {
            f = 120;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dropDownElements :@[] :@"up" :_floorDropDownImg];
        }
        else
        {
            
            if ([dropDownElements count] > 4) {
                f = 160;
            }
            else {
                f = 40 * [dropDownElements count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dropDownElements :@[] :@"up" :_floorDropDownImg];
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


- (IBAction)nextBtnClicked:(id)sender {
    if ([_occupierNameTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter Occupier Name"] animated:NO completion:nil];
    }
    else if ([_complaintSRTextField.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter Survey No./CST No."] animated:NO completion:nil];
    }
    else if([_floorDropDownBtn.titleLabel.text isEqualToString:@"Select Floor Structure"]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please choose floor structure"] animated:NO completion:nil];
    }
    else if ([_lengthTextFiled.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter length"] animated:NO completion:nil];
    }
    else if ([_widthTextFiled.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter width"] animated:NO completion:nil];
    }
    else if ([_areaTextFiled.text isEqualToString:@""]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter area"] animated:NO completion:nil];
    }
    else if ([_otherDetailsTextView.text isEqualToString:@"Enter other details"]) {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please enter other details"] animated:NO completion:nil];
    }
    else if ([complaintID isEqualToString:@""] || complaintID == NULL)  {
        [self presentViewController:[Helper showAlertMessage:@"UC" andMessage:@"Please select case"] animated:NO completion:nil];
    }
    else {
        [self performSegueWithIdentifier:@"secondReportSegue" sender:nil];
    }
}


- (IBAction)tapOnView:(id)sender {
    [_otherDetailsTextView resignFirstResponder];
    [_lengthTextFiled resignFirstResponder];
    [_widthTextFiled resignFirstResponder];
    [_areaTextFiled resignFirstResponder];
    [_occupierNameTextField resignFirstResponder];
    [_complaintSRTextField resignFirstResponder];
}


#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    //NSLog(@"%ld",(long)_dropDownBtn.tag);
    //NSLog(@"%@",[casesArray objectAtIndex:_dropDownBtn.tag]);
   // biID = [officersIdArray objectAtIndex:_dropDownBtn.tag];
}


@end
