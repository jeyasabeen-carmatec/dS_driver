//
//  AppDelegate.m
//  DohaSooqDriver
//
//  Created by Test User on 20/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "AppDelegate.h"
#import "Intial_vc.h"

@import GoogleMaps;
@import GooglePlaces;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }


    [GMSServices provideAPIKey:@"AIzaSyB22HBO9PpPkjT62bC6zsSxmGXpfnORSmA"];//AIzaSyB22HBO9PpPkjT62bC6zsSxmGXpfnORSmA
    [GMSPlacesClient provideAPIKey:@"AIzaSyBdVl-cTICSwYKrZ95SuvNw7dbMuDt1KG0"]; //AIzaSyBdVl-cTICSwYKrZ95SuvNw7dbMuDt1KG0
    
    NSDictionary *DICTN_notification = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"notification_DICT"];
    if (DICTN_notification) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Intial_vc *vc = [sb instantiateViewControllerWithIdentifier:@"initial_VC_cc"];
        self.window.rootViewController = vc;
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSLog(@"deviceToken: %@", deviceToken);
   /* NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(@"the device token is: %@",token);*/
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUInteger lenthtotes = [token length];
    NSUInteger req = 64;
    if (lenthtotes == req) {
        NSLog(@"uploaded token: %@", token);
        
        [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"DEV_TOK"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSNotification *notif = [NSNotification notificationWithName:@"NEW_TOKEN_AVAILABLE" object:token];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

/*
 
 - (void)application:(UIApplication *)applicationdidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
 
 
 NSString *notifMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
 
 //Define notifView as UIView in the header file
 [_notifView removeFromSuperview]; //If already existing
 
 _notifView = [[UIView alloc] initWithFrame:CGRectMake(0, -70, self.window.frame.size.width, 80)];
 [_notifView setBackgroundColor:[UIColor blackColor]];
 
 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,15,30,30)];
 imageView.image = [UIImage imageNamed:@"AppLogo.png"];
 
 UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, self.window.frame.size.width - 100 , 30)];
 myLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
 myLabel.text = notifMessage;
 
 [myLabel setTextColor:[UIColor whiteColor]];
 [myLabel setNumberOfLines:0];
 
 [_notifView setAlpha:0.95];
 
 //The Icon
 [_notifView addSubview:imageView];
 
 //The Text
 [_notifView addSubview:myLabel];
 
 //The View
 [self.window addSubview:_notifView];
 
 UITapGestureRecognizer *tapToDismissNotif = [[UITapGestureRecognizer alloc] initWithTarget:self
 action:@selector(dismissNotifFromScreen)];
 tapToDismissNotif.numberOfTapsRequired = 1;
 tapToDismissNotif.numberOfTouchesRequired = 1;
 
 [_notifView addGestureRecognizer:tapToDismissNotif];
 
 
 [UIView animateWithDuration:1.0 delay:.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
 
 [_notifView setFrame:CGRectMake(0, 0, self.window.frame.size.width, 60)];
 
 } completion:^(BOOL finished) {
 
 
 }];
 
 
 //Remove from top view after 5 seconds
 [self performSelector:@selector(dismissNotifFromScreen) withObject:nil afterDelay:5.0];
 
 
 return;
 
 
 }
 
 //If the user touches the view or to remove from view after 5 seconds
 - (void)dismissNotifFromScreen{
 
 [UIView animateWithDuration:1.0 delay:.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
 
 [_notifView setFrame:CGRectMake(0, -70, self.window.frame.size.width, 60)];
 
 } completion:^(BOOL finished) {
 
 
 }];
 
 
 }
 
 */


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"notification_DICT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Notification Received .. Dictionary %@",[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"notification_DICT"]);
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    Intial_vc *vc = [sb instantiateViewControllerWithIdentifier:@"initial_VC_cc"];
//    self.window.rootViewController = vc;
    
    if ( application.applicationState == UIApplicationStateActive ){
        // app was already in the foreground
//        UIViewController* topViewController = [self.navigationController topViewController];
//        if ([topViewController isKindOfClass:[HomeVC class]]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"getUpdatedServiceData" object:nil];
//        }
        
        
        
        @try {
            NSDictionary *DICTN_notification = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"notification_DICT"];
            NSDictionary *aps = [DICTN_notification valueForKey:@"aps"];
            NSDictionary *alert = [aps valueForKey:@"alert"];
            NSString *notifMessage = [alert valueForKey:@"body"];
            
            //Define notifView as UIView in the header file
            [_notifView removeFromSuperview]; //If already existing
            
            _notifView = [[UIView alloc] initWithFrame:CGRectMake(0, -70, self.window.frame.size.width, 80)];
            [_notifView setBackgroundColor:[UIColor grayColor]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,15,30,30)];
            imageView.image = [UIImage imageNamed:@"AppLogo.png"];
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, self.window.frame.size.width - 100 , 30)];
            myLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
            myLabel.text = notifMessage;
            
            [myLabel setTextColor:[UIColor whiteColor]];
            [myLabel setNumberOfLines:0];
            
            [_notifView setAlpha:0.95];
            
            //The Icon
            [_notifView addSubview:imageView];
            
            //The Text
            [_notifView addSubview:myLabel];
            
            //The View
            [self.window addSubview:_notifView];
            
            UITapGestureRecognizer *tapToDismissNotif = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(dismissNotifFromScreen)];
            tapToDismissNotif.numberOfTapsRequired = 1;
            tapToDismissNotif.numberOfTouchesRequired = 1;
            
            [_notifView addGestureRecognizer:tapToDismissNotif];
            
            
            [UIView animateWithDuration:1.0 delay:.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                [_notifView setFrame:CGRectMake(0, 0, self.window.frame.size.width, 60)];
                
            } completion:^(BOOL finished) {
                
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"The notification exception %@",exception);
        }
    }
    else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Intial_vc *vc = [sb instantiateViewControllerWithIdentifier:@"initial_VC_cc"];
        self.window.rootViewController = vc;
    }
   
//    [self applicationDidFinishLaunching:[UIApplication sharedApplication]];
}
-(void) dismissNotifFromScreen
{
    _notifView.hidden = YES;
    NSDictionary *DICTN_notification = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"notification_DICT"];
    if (DICTN_notification) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Intial_vc *vc = [sb instantiateViewControllerWithIdentifier:@"initial_VC_cc"];
        self.window.rootViewController = vc;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
