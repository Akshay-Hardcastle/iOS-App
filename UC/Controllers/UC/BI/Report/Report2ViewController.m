//
//  Report2ViewController.m
//  UC
//
//  Created by HardCastle on 25/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "Report2ViewController.h"
#import "Helper.h"
#import "APIManager.h"

@interface Report2ViewController ()
{
    NIDropDown *dropDown;
    NSMutableArray *deNames;
    NSMutableArray *deIdArray;
    NSArray *noticeArray;
    UIAlertController *alert;
    NSData *chosenImgData;
    
    NSString *noticeType;
    NSString *deAtSite;
    NSString *deTo;
    
    int dropdownSwitch;
}
@property (weak, nonatomic) IBOutlet UIImageView *browseImg;
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;

@property (weak, nonatomic) IBOutlet UIButton *noticeTypeDropDownBtn;
@property (weak, nonatomic) IBOutlet UIImageView *noticeTypeDownImg;


@property (weak, nonatomic) IBOutlet UIButton *nameOfDEDropDownBtn;
@property (weak, nonatomic) IBOutlet UIImageView *nameOfDEDownImg;

@property (weak, nonatomic) IBOutlet UIButton *selectDEDropDownBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectDownImg;


- (IBAction)signOfBIBtnClicked:(id)sender;
- (IBAction)previewBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;

- (IBAction)selectNoticeTypeBtnClicked:(id)sender;
- (IBAction)nameOfDEBtnClicked:(id)sender;
- (IBAction)selectDEBtnClicked:(id)sender;

- (IBAction)browseImgTap:(id)sender;
@end

@implementation Report2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"INSPECTION REPORT - 2";
    deNames = [[NSMutableArray alloc] init];
    deIdArray = [[NSMutableArray alloc] init];
    
    noticeArray = @[@"Section 478(1)24",@"Section 478(1)30",@"Section 260(1)",@"Section 260(2)",@"Section 264(1)",@"Section 268(B)(C)",@"Section 53(1)",@"Section 52",@"Letter to Local Police"];
    
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
                    
                    [deNames addObject:[userDict objectForKey:@"NAME"]];
                    [deIdArray addObject:[userDict objectForKey:@"USER_ID"]];
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

#pragma mark - NIDropDown Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
    
    switch (dropdownSwitch) {
        case 0:
            noticeType = [noticeArray objectAtIndex:_noticeTypeDropDownBtn.tag];
            NSLog(@"%@",noticeType);
            break;
        
        case 1:
            deAtSite = [deIdArray objectAtIndex:_nameOfDEDropDownBtn.tag];
            NSLog(@"%@",deAtSite);
            break;
            
        case 2:
            deTo = [deIdArray objectAtIndex:_selectDEDropDownBtn.tag];
            NSLog(@"%@",deTo);
            break;
            
        default:
            break;
    }
//    NSLog(@"%ld",(long)_dropDownBtn.tag);
//    NSLog(@"%@",[officersIdArray objectAtIndex:_dropDownBtn.tag]);
//    deID = [officersIdArray objectAtIndex:_dropDownBtn.tag];
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
    _browseImg.image = chosenImage;
    chosenImgData = UIImagePNGRepresentation(chosenImage);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TextField

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, -180);
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, 180);
    [UIView commitAnimations];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, 180);
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Touch events
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [_remarkTextField resignFirstResponder];
//}

#pragma mark - Button Clicked events

- (IBAction)signOfBIBtnClicked:(id)sender {
}

- (IBAction)previewBtnClicked:(id)sender {
}

- (IBAction)submitBtnClicked:(id)sender {
}

- (IBAction)selectNoticeTypeBtnClicked:(id)sender {
    
    dropdownSwitch = 0;
    if ([_noticeTypeDownImg.image isEqual:[UIImage imageNamed:@"upArrow.png"]]) {
        _noticeTypeDownImg.image = [UIImage imageNamed:@"dropDownArrow"];
    }
    else {
        _noticeTypeDownImg.image = [UIImage imageNamed:@"upArrow.png"];
    }
    
    if(dropDown == nil)
    {
        CGFloat f;
        if ([deviceType isEqualToString:@"iPhone"])
        {
            f = 120;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :noticeArray :@[] :@"up" :_noticeTypeDownImg];
        }
        else
        {
            
            if ([noticeArray count] > 4) {
                f = 160;
            }
            else {
                f = 40 * [noticeArray count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :noticeArray :@[] :@"down" :_noticeTypeDownImg];
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


- (IBAction)nameOfDEBtnClicked:(id)sender {
    dropdownSwitch = 1;
    if ([_nameOfDEDownImg.image isEqual:[UIImage imageNamed:@"upArrow.png"]]) {
        _nameOfDEDownImg.image = [UIImage imageNamed:@"dropDownArrow"];
    }
    else {
        _nameOfDEDownImg.image = [UIImage imageNamed:@"upArrow.png"];
    }
    
    if(dropDown == nil)
    {
        CGFloat f;
        if ([deviceType isEqualToString:@"iPhone"])
        {
            f = 120;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :deNames :@[] :@"up" :_nameOfDEDownImg];
        }
        else
        {
            
            if ([deNames count] > 4) {
                f = 160;
            }
            else {
                f = 40 * [deNames count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :deNames :@[] :@"down" :_nameOfDEDownImg];
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

- (IBAction)selectDEBtnClicked:(id)sender {
    dropdownSwitch = 2;
    if ([_selectDownImg.image isEqual:[UIImage imageNamed:@"upArrow.png"]]) {
        _selectDownImg.image = [UIImage imageNamed:@"dropDownArrow"];
    }
    else {
        _selectDownImg.image = [UIImage imageNamed:@"upArrow.png"];
    }
    
    if(dropDown == nil)
    {
        CGFloat f;
        if ([deviceType isEqualToString:@"iPhone"])
        {
            f = 120;
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :deNames :@[] :@"up" :_selectDownImg];
        }
        else
        {
            
            if ([deNames count] > 4) {
                f = 160;
            }
            else {
                f = 40 * [deNames count];
            }
            dropDown = [[NIDropDown alloc]showDropDown:sender :&f :deNames :@[] :@"up" :_selectDownImg];
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


- (IBAction)browseImgTap:(id)sender {
    UIAlertController *uploadAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
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
    
//    [uploadAlert setModalPresentationStyle:UIModalPresentationPopover];
//    
//    UIPopoverPresentationController *popPresenter = [uploadAlert
//                                                     popoverPresentationController];
//    popPresenter.sourceView = _uploadBtn;
//    popPresenter.sourceRect = _uploadBtn.bounds;
    [self presentViewController:uploadAlert animated:YES completion:nil];

}

@end
