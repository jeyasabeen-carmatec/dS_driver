//
//  changepassword_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 13/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "changepassword_VC.h"
#import "Helper_activity.h"

@interface changepassword_VC ()<UITextFieldDelegate>
{
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
    CGRect framerect;
}
@end

@implementation changepassword_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    VW_overlay = [[UIView alloc]init];
//    CGRect vwframe;
//    vwframe = VW_overlay.frame;
//    vwframe.size.height = 80;
//    vwframe.size.width = 120;
//    VW_overlay.frame = vwframe;
//    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]; //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
//    VW_overlay.layer.cornerRadius = 10.0;
//    
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
//    
//    activityIndicatorView.center = VW_overlay.center;
//    [VW_overlay addSubview:activityIndicatorView];
//    VW_overlay.center = self.view.center;
//    [self.view addSubview:VW_overlay];
//    
//    VW_overlay.hidden = YES;
    
    [self setup_VIEW];
}
-(void)setup_VIEW
{
   
    _TXT_newpwd.delegate = self;
    _TXT_oldpwd.delegate = self;
    _TXT_confirmpwd.delegate = self;
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:35.0f]
       } forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(backAction)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    CGSize result = [[UIScreen mainScreen] bounds].size;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if(result.height <= 480)
        {
            // iPhone Classic
            negativeSpacer.width = 0;
        }
        else if(result.height <= 568)
        {
            // iPhone 5
            negativeSpacer.width = -12;
        }
        else
        {
            negativeSpacer.width = -16;
        }
    }
    else
    {
        negativeSpacer.width = -12;
    }
    if(result.height >= 480)
    {
        
        [_BTN_save.titleLabel setFont: [_BTN_save.titleLabel.font fontWithSize: 17]];
    }
    else if(result.height >= 667)
    {
        
        [_BTN_save.titleLabel setFont: [_BTN_save.titleLabel.font fontWithSize: 19]];
        
    }

    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:22.0f]}];
    self.navigationItem.title = [@"Change Password" uppercaseString];
    [_BTN_save addTarget:self action:@selector(BTN_saveAction) forControlEvents:UIControlEventTouchUpInside];
    framerect = self.view.frame;
    NSLog(@"%@", NSStringFromCGRect(framerect));
    NSLog(@"newpassowrd%@", NSStringFromCGRect(self.TXT_newpwd.frame));
    NSLog(@"confirm password%@", NSStringFromCGRect(self.TXT_confirmpwd.frame));
    NSLog(@"confirm password%@", NSStringFromCGRect(self.TXT_confirmpwd.frame));
    
}

#pragma mark - UITextField Deligate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _error_label.hidden = YES;
    
    
    if(textField == _TXT_newpwd || textField == _TXT_confirmpwd)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
        NSLog(@"%@", NSStringFromCGRect(self.view.frame));

        [UIView commitAnimations];
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _TXT_newpwd || textField == _TXT_confirmpwd)
    {
       
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = framerect;
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
        NSLog(@"newpassowrd%@", NSStringFromCGRect(self.TXT_newpwd.frame));
         NSLog(@"confirm password%@", NSStringFromCGRect(self.TXT_confirmpwd.frame));

    [UIView commitAnimations];
    }
       
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length != 0) {
        [textField becomeFirstResponder];
    }
    return YES;
}

#pragma button Actions
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)BTN_saveAction
{
    if(_TXT_oldpwd.text.length == 0 || [_TXT_oldpwd.text isEqualToString:@""])
    {
//        [_TXT_oldpwd resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Please enter old password";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
        
    }
   /* else if (![_TXT_oldpwd.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"changepassword"]])
    {
//        [_TXT_oldpwd resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Please enter the correct current password";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
    }*/
    else  if(_TXT_newpwd.text.length == 0 || [_TXT_newpwd.text isEqualToString:@""])
    {
        //        [_TXT_newpwd resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Please enter new password";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
    }
    else  if(_TXT_newpwd.text.length < 8)
    {
//        [_TXT_newpwd resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"New password should be minimum 8 characters";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
    }
  /*  else  if(_TXT_confirmpwd.text.length < 8)
    {
//        [_TXT_confirmpwd resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Current password should have minimum 8 charecters";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
    } */
    else  if(_TXT_confirmpwd.text.length == 0 || [_TXT_confirmpwd.text isEqualToString:@""])
    {
        //        [_TXT_newpwd resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Please enter confirm password";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
    }
    
    else  if(![_TXT_confirmpwd.text isEqualToString:_TXT_newpwd.text])
    {
//        [_TXT_oldpwd resignFirstResponder];
//        [_TXT_newpwd resignFirstResponder];
//        [_TXT_confirmpwd resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Confirm password and new password does not match";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
    }
    else
    {
//        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegEX];
        
        BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = false,specialCharacter = 0;
        // if([textField.text length] >= 8)
        //{
        for (int i = 0; i < [_TXT_confirmpwd.text length]; i++)
        {
            unichar c = [_TXT_confirmpwd.text characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            if(!specialCharacter)
            {
                specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            }
        }
        
        if( digit && lowerCaseLetter && upperCaseLetter && [_TXT_confirmpwd.text length] >= 8)
        {
            NSLog(@"Valid Password");
            [Helper_activity Start_animation:self];
            [self performSelector:@selector(API_changePWD) withObject:nil afterDelay:0.01];
        }
        else
        {
            _TXT_newpwd.text = nil;
            _TXT_confirmpwd.text =nil;
            
            self.error_label.hidden  = NO;
            self.error_label.text = @"Password must contain one capital character and one numerical";
            [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
        }
        
//        if ([emailTest evaluateWithObject:_TXT_confirmpwd.text] == YES)
//        {
////            VW_overlay.hidden = NO;
////            [activityIndicatorView startAnimating];
//            [Helper_activity Start_animation:self];
//            [self performSelector:@selector(API_changePWD) withObject:nil afterDelay:0.01];
//        }
//        else
//        {
//            self.error_label.text = @"Password should have min 8 charecter including 1 number";
//            [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
//        }
    }
    
}
- (void)hiddenLabel{
    _error_label.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma API - Update
-(void) API_changePWD
{
    NSString *original_PWD = _TXT_oldpwd.text;
    NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    NSString *Confirm_new_pwd = _TXT_confirmpwd.text;
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    //    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
//    NSDictionary *parameters = @{ @"driver_id":driver_ID,@"old_pwd":original_PWD,@"new_pwd":Confirm_new_pwd};
    
    NSString *post = [NSString stringWithFormat:@"driver_id=%@&old_pwd=%@&new_pwd=%@",driver_ID,original_PWD,Confirm_new_pwd];
    
    NSLog(@"Post contents %@",post);
    
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@changePwdApi",SERVER_URL];
    
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
//        [activityIndicatorView stopAnimating];
//        VW_overlay.hidden = YES;
        
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",json_DATA);
        if ([[json_DATA valueForKey:@"status"]isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setValue:_TXT_confirmpwd.text forKey:@"changepassword"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSegueWithIdentifier:@"load_home" sender:self];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[json_DATA valueForKey:@"status"] message:[json_DATA valueForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[json_DATA valueForKey:@"status"] message:[json_DATA valueForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    else
    {
//        [activityIndicatorView stopAnimating];
//        VW_overlay.hidden = YES;
        
        NSLog(@"Error %@\nResponse %@",error,response);
    }
    [Helper_activity Stop_animation:self];
}

@end
