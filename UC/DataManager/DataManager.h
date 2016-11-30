//
//  DataManager.h
//  UC
//
//  Created by HardCastle on 14/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic,strong) NSUserDefaults *userDefaults;
+(DataManager *)shareInstance;

@end
