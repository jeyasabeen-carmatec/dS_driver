//
//  Helper_activity.m
//  DohaSooqDriver
//
//  Created by jeya sabeen on 15/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import "Helper_activity.h"


@implementation Helper_activity

+(void)Start_animation:(UIViewController *)my_controller
{
    UIView *VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    VW_overlay.clipsToBounds = YES;
    VW_overlay.tag = 1234;
    
    
    VW_overlay.hidden = NO;
    UIImageView *actiIndicatorView = [[UIImageView alloc] initWithImage:[UIImage new]];
    actiIndicatorView.frame = CGRectMake(0, 0, 60, 60);
    actiIndicatorView.center = my_controller.view.center;
    actiIndicatorView.tag = 1235;
    
    actiIndicatorView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"],[UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"],[UIImage imageNamed:@"loader14.png"],[UIImage imageNamed:@"loader15.png"],[UIImage imageNamed:@"loader16.png"],[UIImage imageNamed:@"loader17.png"],[UIImage imageNamed:@"loader18.png"],nil];
    
    actiIndicatorView.animationDuration = 2.0;
    [actiIndicatorView startAnimating];
    actiIndicatorView.center = VW_overlay.center;
    
    [VW_overlay addSubview:actiIndicatorView];
    [my_controller.view addSubview:VW_overlay];
}
+(void)Stop_animation:(UIViewController *)my_controller
{
    for (UIImageView *activity in my_controller.view.subviews) {
        if (activity.tag == 1235) {
            [activity stopAnimating];
        }
    }
    
    for (UIView *VW_main in my_controller.view.subviews) {
        if (VW_main.tag == 1234) {
            VW_main.hidden = YES;
        }
    }
}

+(void)api_with_post_params:(NSString *)urlStr andParams:(NSDictionary *)params completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:70];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    // set Cookie VAlue as Header when it is not Null.........1
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isKindOfClass:[NSNull class]] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"<nil>"] || ![[NSUserDefaults standardUserDefaults] valueForKey:@"(null)"]) {
        
        NSString *awlllb = [[NSUserDefaults standardUserDefaults] valueForKey:@"Aws"];
        
        if (![awlllb containsString:@"(null)"]) {
            awlllb = [NSString stringWithFormat:@"%@;%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"],awlllb];
            [request addValue:awlllb forHTTPHeaderField:@"Cookie"];
        }
        else{
            [request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
        }
        
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            [Helper_activity filteringCookieValue:response];
        }
        
        if (error) {
            completionHandler(nil,error);
            NSLog(@"eror :%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                completionHandler(nil,error);
                
                NSLog(@"eror :%@",[err localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);
                        
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }
        }
    }];
    [dataTask resume];
}

/*
 NSError *error;
 NSString *URL_STR = [NSString stringWithFormat:@"%@savePushNotificationInfoAPI",SERVER_URL];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 
 NSString *post = [NSString stringWithFormat:@"driver_id=%@&device_type=%@&device_token=%@",driver_id,@"iphone",token];
 NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
 NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
 
 [request setURL:[NSURL URLWithString:URL_STR]];
 [request setHTTPMethod:@"POST"];
 [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 [request setHTTPBody:postData];
 
 NSLog(@"Datas Posted == %@",post);
 
 NSURLResponse *response;
 NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 
 if (aData)
 {
 NSMutableDictionary *push = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
 NSLog(@"OUT Json Push register %@",push);
 
 }

 */




// Post Parameter as String...
+(void)apiWith_PostString:(NSString *)urlStr andParams:(NSString *)params completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    NSData *postData;
    NSString *postLength;
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:70];
    
    if (params != nil) {
        postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        [request setHTTPBody:postData];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    }

    
    
  
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // set Cookie VAlue as Header when it is not Null.........
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isKindOfClass:[NSNull class]] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"<nil>"] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"(null)"]) {
        
        NSString *awlllb = [[NSUserDefaults standardUserDefaults] valueForKey:@"Aws"];
        
        if (![awlllb containsString:@"(null)"]) {
            awlllb = [NSString stringWithFormat:@"%@;%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"],awlllb];
            [request addValue:awlllb forHTTPHeaderField:@"Cookie"];
        }
        else{
            [request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
            NSLog(@" Cookie::   %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"]);
        }
        
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            [Helper_activity filteringCookieValue:response];
        }
        
        if (error) {
            completionHandler(nil,error);
            NSLog(@"eror :%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                completionHandler(nil,error);
                
                NSLog(@"eror :%@",[err localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);
                        
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }
        }
    }];
    [dataTask resume];
}





+(void)filteringCookieValue:(NSURLResponse *)response{
    
    @try {
        
        //      NSLog(@"@@@@@@@@@@@ %@",[[response valueForKey:@"allHeaderFields"] valueForKey:@"Set-Cookie"]);
        //         NSLog(@"response........   %@",response);
        
        NSString *responseString = [[response valueForKey:@"allHeaderFields"] valueForKey:@"Set-Cookie"];
        //NSArray *responseArray = [responseString componentsSeparatedByString:@";"];
        NSArray *responseArray = [responseString componentsSeparatedByString:@";"];
        
        
        
        NSMutableArray *cookieArray = [NSMutableArray arrayWithArray:responseArray];
        
        
        NSString *awsStr;
        for (int i = 0; i<cookieArray.count; i++) {
            
            responseString = [cookieArray objectAtIndex:i];
            
            if ([responseString containsString:@"AWSALB"]){
                
                responseArray = [responseString componentsSeparatedByString:@"="];
                
                awsStr = [responseArray lastObject];
            }
            
        }
        //NSLog(@"AwsValue........   %@",awsStr);
        if (![awsStr isKindOfClass:[NSNull class]] || ![awsStr isEqualToString:@"<nil>"] || ![awsStr containsString:@"(null)"]||awsStr != nil) {
            awsStr = [NSString stringWithFormat:@"AWSALB=%@",awsStr];
            
            [[NSUserDefaults standardUserDefaults]setObject:awsStr forKey:@"Aws"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"...........Cookie Exception............");
    }
}

+(UIAlertView *)createaAlertWithMsg:(NSString *)msg andTitle:(NSString *)title{
    NSString *ok_btn;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        ok_btn = @"حسنا";
    }
    else{
        ok_btn = @"Ok";
        
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:ok_btn otherButtonTitles:nil, nil];
    [alert show];
    return  alert;
}
+(void)removeSharedPreferenceValues{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Cookie"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Aws"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"driver_id"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@""];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@""];

    
}
@end
