//
//  ReportTableViewCell.h
//  UC
//
//  Created by HardCastle on 11/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *caseId;
@property (weak, nonatomic) IBOutlet UILabel *srNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *inwardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicantAddress;
@property (weak, nonatomic) IBOutlet UILabel *complaintAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailIdLabel;

@end
