//
//  Helper_activity.h
//  DohaSooqDriver
//
//  Created by jeya sabeen on 15/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper_activity : NSObject

+(void)Start_animation:(UIViewController *)my_controller;
+(void)Stop_animation:(UIViewController *)my_controller;
+(void)filteringCookieValue:(NSURLResponse *)response;
//+(void)api_with_post_params:(NSString *)urlStr andParams:(NSDictionary *)params completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler;
+(UIAlertView *)createaAlertWithMsg:(NSString *)msg andTitle:(NSString *)title;

+(void)apiWith_PostString:(NSString *)urlStr andParams:(NSString *)params completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler;
+(void)removeSharedPreferenceValues;

@end
