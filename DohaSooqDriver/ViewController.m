//
//  ViewController.m
//  DohaSooqDriver
//
//  Created by Test User on 12/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ViewController.h"
#import "Helper_activity.h"

@interface ViewController ()<UITextFieldDelegate>
{
    CGRect framerect;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self set_up_VIEW];
}
-(void)set_up_VIEW
{
    
    framerect = self.view.frame;
    _TXT_email.delegate = self;
    _TXT_password.delegate = self;
    [_BTN_check addTarget:self action:@selector(status_chnaged) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_forgot_pwd addTarget:self action:@selector(forgot_view) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Login addTarget:self action:@selector(myprofile) forControlEvents:UIControlEventTouchUpInside];


    _BTN_Login.titleLabel.numberOfLines = 1;
    _BTN_Login.titleLabel.adjustsFontSizeToFitWidth = YES;
    _BTN_Login.titleLabel.minimumScaleFactor = 1.0f;
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height >= 480)
    {
        [_BTN_Login.titleLabel setFont: [_BTN_Login.titleLabel.font fontWithSize: 17]];
    }
    else if(result.height >= 667)
    {
        [_BTN_Login.titleLabel setFont: [_BTN_Login.titleLabel.font fontWithSize: 19]];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_id"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    self.navigationController.navigationBar.hidden = YES;
    NSString *user_name = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
//    login_order
    
    NSString *STR_driver_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    if (STR_driver_id) {
        [self performSegueWithIdentifier:@"login_order" sender:self];
    }
    else
    {
        if (user_name)
        {
            _TXT_email.text = user_name;
        }
        
        if (password) {
            _TXT_password.text = password;
        }
    }
}

#pragma mark - Handle UITextField While Editing
#pragma mark - UITextField Deligate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _error_label.hidden =YES;
    if(textField == _TXT_email || textField == _TXT_password)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        
    }
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _TXT_email)
    {
        NSString *text_to_compare = _TXT_email.text;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:text_to_compare] == NO)
        {
            _TXT_email.text = @"";
            [UIView beginAnimations:nil context:NULL];
            
            self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
            }
        }
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = framerect;
    [UIView commitAnimations];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_TXT_email resignFirstResponder];
    [_TXT_password resignFirstResponder];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length != 0) {
        [textField becomeFirstResponder];
    }
    return YES;
}


#pragma Button_Actions
-(void)status_chnaged
{
    if([_LBL_stat.text isEqualToString:@""])
    {
        _LBL_stat.text = @"";
        
    }
    else
    {
        _LBL_stat.text = @"";
    }
    
}
-(void)forgot_view
{
    [self performSegueWithIdentifier:@"forgot_identifier" sender:self];
}
-(void)myprofile
{
    [_TXT_email resignFirstResponder];
    [_TXT_password resignFirstResponder];

    NSString *text_to_compare_email = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];

    if ([_TXT_email.text isEqualToString:@""]) {
        [_TXT_email resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Please enter email";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
    }
    else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_email resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Please provide correct email";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];

    }
    else if([self.TXT_password.text isEqualToString:@""])
    {
        [_TXT_password resignFirstResponder];
        _error_label.hidden = NO;

        self.error_label.text = @"Please enter password";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:5];

    }
    else
    {
        [Helper_activity Start_animation:self];
        if([_LBL_stat.text  isEqualToString:@""])
        {
            [[NSUserDefaults standardUserDefaults] setValue:_TXT_email.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setValue:_TXT_password.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:_TXT_password.text forKey:@"changepassword"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
        
        
        [[NSUserDefaults standardUserDefaults] setValue:_TXT_password.text forKey:@"changepassword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self performSelector:@selector(API_Login) withObject:nil afterDelay:0.01];
//        [self stop_activity];
    }

}
- (void)hiddenLabel{
    _error_label.hidden = YES;
}

-(void) send_TOK
{
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:@"DEV_TOK"];
    NSString *driver_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    NSLog(@"new token available : %@", token);
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
}

#pragma mark - Register Push Notification
- (void)tokenAvailableNotification:(NSNotification *)notification {
    
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:@"DEV_TOK"];
    NSString *driver_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    NSLog(@"new token available : %@", token);
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
}

-(void) API_Login
{
    NSString *userEmail = _TXT_email.text;
    NSString *userPWD = _TXT_password.text;
    
    [self.view endEditing:YES];
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
//    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
//    NSDictionary *parameters = @{ @"username":userEmail,@"password":userPWD};
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",userEmail,userPWD];
    
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@loginApi",SERVER_URL];
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",json_DATA);
        
        @try
        {
            [[NSUserDefaults standardUserDefaults] setValue:[json_DATA valueForKey:@"profile_pic"] forKey:@"profile_pic"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } @catch (NSException *exception) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profile_pic"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if ([[json_DATA valueForKey:@"status"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setValue:[json_DATA valueForKey:@"driver_id"] forKey:@"driver_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[json_DATA valueForKey:@"status"] message:[json_DATA valueForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            
            NSString *dev_TOK = [[NSUserDefaults standardUserDefaults]valueForKey:@"DEV_TOK"];
            if (dev_TOK)
            {
                [self send_TOK];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(tokenAvailableNotification:)
                                                             name:@"NEW_TOKEN_AVAILABLE"
                                                           object:nil];
            }
            [self order_details_page];
        }
        else
        {

            @try {
                _error_label.hidden = NO;
                self.error_label.text = [json_DATA valueForKey:@"msg"];
                [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
            } @catch (NSException *exception) {
                NSLog(@"Exception from error msg %@",exception);
            }
            
        }
    }
    else
    {

        NSLog(@"Error %@\nResponse %@",error,response);
    }
    
    [Helper_activity Stop_animation:self];
}

-(void) stop_activity
{
    [self order_details_page];
}

-(void)order_details_page
{
    [self performSegueWithIdentifier:@"login_order" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];  
    // Dispose of any resources that can be recreated.
}



@end
