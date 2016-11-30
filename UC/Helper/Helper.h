//
//  Helper.h
//  UC
//
//  Created by HardCastle on 08/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

extern NSString *deviceType;
extern NSString *kSuccess;
extern float deviceHeight;

+(UIAlertController *)showAlertMessage:(NSString *)title andMessage:(NSString *)msg;
+(UIAlertController *)showLoader;

@end
