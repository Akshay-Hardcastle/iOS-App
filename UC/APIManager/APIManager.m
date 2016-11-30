//
//  APIManager.m
//  UC
//
//  Created by HardCastle on 02/11/16.
//  Copyright © 2016 HardCastle. All rights reserved.
//

#import "APIManager.h"
#import "Helper.h"


static NSString *baseUrl = @"http://hardcastlegis.co.in/";


@implementation APIManager
{
    NSMutableData *receivedData;
}

-(void)getDetails:(NSDictionary *)paramDict withBlock:(void(^)(NSString *,id))notifyResponse {
    
//    [self postRequest:paramDict url:[baseUrl stringByAppendingString:@"_IPHONE/PMC_UC/fetch_Complaints.php"] withBlock:^(NSString *msg, id response) {
//        
//        notifyResponse(msg,response);
//        
//    }];
}


-(void)postRequest:(NSString *)param url:(NSString *)urlStr withBlock:(void(^)(NSString *,id))postResponse {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
    
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[baseUrl stringByAppendingString:urlStr]]];
            
            [request setHTTPMethod:@"POST"];

            NSData *data1 = [param dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:data1];
            
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                      NSURLResponse *response,
                                                                      NSError *error) {
                if (data == NULL)
                {
                    postResponse(@"Fail",nil);
                }
                else
                {
                    NSString *resStr = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                    NSLog(@"%@",resStr);
                    
                    if ([resStr containsString:@"FAILED"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^
                                       {
                                           postResponse(@"Fail",nil);
                                       });
                    }
                    else {
                        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        dispatch_async(dispatch_get_main_queue(), ^
                                       {
                                           postResponse(kSuccess,responseDict);
                                       });
                    }
                    
                }
            }] resume];
    });
}


-(void)getRequest:(NSString *)urlStr withBlock:(void(^)(NSString *,id))postResponse {
    // 1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAppendingString:urlStr]];
    
    // 2
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              // 4: Handle response here
                                              
                                              if (data != nil) {
                                                  
                                                  NSDictionary *responseDict =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                  NSLog(@"%@",responseDict);
                                                  dispatch_async(dispatch_get_main_queue(), ^
                                                                 {
                                                  
                                                                     postResponse(kSuccess,responseDict);
                                                                 });
                                                  
                                              }
                                              else {
                                                  dispatch_async(dispatch_get_main_queue(), ^
                                                                 {
                                                                        postResponse(@"Fail",nil);
                                                                 });
                                              }
                                          }];
    
    // 3
    [downloadTask resume];
                   });
}


//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
// completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
//    
//    receivedData=nil;
//    receivedData=[[NSMutableData alloc] init];
//    [receivedData setLength:0];
//    
//    completionHandler(NSURLSessionResponseAllow);
//}
//
//-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
//   didReceiveData:(NSData *)data {
//    
//    [receivedData appendData:data];
//}
//
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//didCompleteWithError:(NSError *)error {
//    if (error) {
//        // Handle error
//    }
//    else {
//        NSDictionary* response=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
//        NSLog(@"%@",response);
//        // perform operations for the  NSDictionary response
//    }
//}
@end
