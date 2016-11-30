//
//  StatusTableViewCell.h
//  UC
//
//  Created by HardCastle on 15/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *srNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *uniqueIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *complaintAddress;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumber;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *complaintNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *structureLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
