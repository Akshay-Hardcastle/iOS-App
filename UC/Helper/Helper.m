//
//  Helper.m
//  UC
//
//  Created by HardCastle on 08/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "Helper.h"

NSString *deviceType;
float deviceHeight;
NSString *kSuccess = @"Success";

@implementation Helper

+(UIAlertController *)showAlertMessage:(NSString *)title andMessage:(NSString *)msg {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    return alert;
}


+(UIAlertController *)showLoader {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Please wait\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(130.5, 65.5);
    spinner.color = [UIColor blackColor];
    [spinner startAnimating];
    [alert.view addSubview:spinner];
    return alert;
}

@end
