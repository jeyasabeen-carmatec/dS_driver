//
//  forgot_pasword.m
//  DohaSooqDriver
//
//  Created by Test User on 12/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "forgot_pasword.h"
#import "Helper_activity.h"

@interface forgot_pasword ()<UITextFieldDelegate>
{
    CGRect framerect;
}
@end

@implementation forgot_pasword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _TXT_email.delegate = self;
    framerect = self.view.frame;
    }
-(void)viewWillAppear:(BOOL)animated
{
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
        
        [_BTN_submit.titleLabel setFont: [_BTN_submit.titleLabel.font fontWithSize: 17]];
    }
    else if(result.height >= 667)
    {
        
        [_BTN_submit.titleLabel setFont: [_BTN_submit.titleLabel.font fontWithSize: 19]];
        
    }

    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:22.0f]}];
    self.navigationItem.title = [@"Forgot Password" uppercaseString];
    [_BTN_submit addTarget:self action:@selector(BTN_submit_action) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Handle UITextField While Editing
#pragma mark - UITextField Deligate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    _error_label.hidden = YES;
    if(textField == _TXT_email)
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
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegEx];
        
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
-(void)BTN_submit_action
{
    [_TXT_email resignFirstResponder];
    NSString *text_to_compare_email = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_email resignFirstResponder];
        _error_label.hidden = NO;
        self.error_label.text = @"Please enter valid email id";
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:3];
        
    }
    else
    {
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(API_Chanhe_PWD) withObject:nil afterDelay:0.01];
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

#pragma mark - Forget PWD API
-(void) API_Chanhe_PWD
{
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    //    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    //    NSDictionary *parameters = @{ @"driver_id":driver_ID,@"old_pwd":original_PWD,@"new_pwd":Confirm_new_pwd};
    
    NSString *post = [NSString stringWithFormat:@"email=%@",_TXT_email.text];
    
    NSLog(@"Post contents %@",post);
    
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@forgotPwdApi",SERVER_URL];
    
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
        NSLog(@"Api response from forgotPwdApi %@",json_DATA);
        
        @try {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[json_DATA valueForKey:@"status"] message:[json_DATA valueForKey:@"msg"]  delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]; //If there is an account associated with %@, you will receive an email with new reset password link
            [alert show];
        } @catch (NSException *exception) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    else
    {
        NSLog(@"Error %@\nResponse %@",error,response);
    }
    [Helper_activity Stop_animation:self];
}

@end
