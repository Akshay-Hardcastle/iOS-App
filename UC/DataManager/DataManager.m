//
//  DataManager.m
//  UC
//
//  Created by HardCastle on 14/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

-(id)init {
    
    if (self) {
        
        self = [super init];
        _userDefaults = [[NSUserDefaults alloc] init];
    }
    return self;
}


+(DataManager *)shareInstance {
    
    static DataManager *sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[DataManager alloc] init];
        
    });
    return sharedInstance;
}

@end
