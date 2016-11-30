//
//  APIManager.h
//  UC
//
//  Created by HardCastle on 02/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject <NSURLSessionDelegate>

-(void)getDetails:(NSDictionary *)paramDict withBlock:(void(^)(NSString *,id))notifyResponse;

-(void)postRequest:(NSString *)paramDict url:(NSString *)urlStr withBlock:(void(^)(NSString *,id))postResponse;
-(void)getRequest:(NSString *)url withBlock:(void(^)(NSString *,id))postResponse;

@end
