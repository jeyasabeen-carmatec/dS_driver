//
//  MY_profile_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 13/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "MY_profile_VC.h"
#import "profile_data_cell.h"
#import "update_profile_VC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Helper_activity.h"

@interface MY_profile_VC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *address,*images;
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation MY_profile_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _profiletab.estimatedRowHeight = 4.0;
    _profiletab.rowHeight = UITableViewAutomaticDimension;
    
}

-(void) update_frame
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
    if(result.height <= 480)
    {
        
        CGRect newframe;
        newframe = _IMG_profile.frame;
        newframe.size.width = 80 ;
        newframe.size.height = 80;
        _IMG_profile.frame = newframe;
        
        newframe = _BTN_profile.frame;
        newframe.size.height = 30;
        newframe.size.width = 30;
        _BTN_profile.frame = newframe;
        
        newframe = _BTN_pwd.frame;
        newframe.size.height = 30;
        newframe.size.width = 30;
        _BTN_pwd.frame = newframe;
        
        
    }
    
    else if(result.height >= 480)
    {
        
        [_BTN_logout.titleLabel setFont: [_BTN_logout.titleLabel.font fontWithSize: 17]];
        
        
    }
    else if(result.height >= 667)
    {
        
        [_BTN_logout.titleLabel setFont: [_BTN_logout.titleLabel.font fontWithSize: 19]];
        
    }
    
    self.IMG_profile.center = CGPointMake(CGRectGetMidX(self.main_view.bounds),
                                          CGRectGetMidY(self.main_view.bounds));
    _IMG_profile.layer.cornerRadius =  _IMG_profile.frame.size.width / 2;
    _IMG_profile.layer.masksToBounds = YES;
    _IMG_profile.layer.borderWidth = 5;
    _IMG_profile.layer.borderColor = [UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0].CGColor;
//    [_IMG_profile setContentMode:UIViewContentModeRedraw];
    _IMG_profile.contentMode = UIViewContentModeRedraw;
    
    CGRect newframe;
    //    newframe = _IMG_profile.frame;
    //    newframe.origin.x  = _main_view.frame.size.width / 2 - _IMG_profile.frame.size.width / 2;
    //    newframe.origin.y =  self.navigationController.navigationBar.frame.size.height - 20;
    //    newframe.size.width = _main_view.frame.size.width / 4;
    //    newframe.size.height = _main_view.frame.size.height/2;
    //    _IMG_profile.frame = newframe;
    
    newframe = _LBL_Name.frame;
    newframe.origin.y = _IMG_profile.frame.origin.y + _IMG_profile.frame.size.height + 10;
    _LBL_Name.frame = newframe;
    
    _BTN_pwd.layer.cornerRadius = self.BTN_pwd.frame.size.width / 2;
    _BTN_pwd.layer.masksToBounds = YES;
    _BTN_profile.layer.cornerRadius = self.BTN_pwd.frame.size.width / 2;
    _BTN_profile.layer.masksToBounds = YES;
    _BTN_profile.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _BTN_pwd.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    [_BTN_pwd addTarget:self action:@selector(password_chnage) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_profile addTarget:self action:@selector(edit_profile) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_logout addTarget:self action:@selector(Log_OUT) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillAppear:(BOOL)animated
{
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
    
    [self update_frame];
    
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(API_myprofile) withObject:nil afterDelay:0.01];
    
}
-(void)setupview :(NSDictionary *)json_DATA
{
   
    NSLog(@"The response %@",json_DATA);
   
    NSDictionary *main_data = [json_DATA valueForKey:@"profile_data"];
    NSDictionary *user = [main_data valueForKey:@"user"];
    
    NSString *STR_address;
    @try {
        STR_address = [main_data valueForKey:@"address"];
    } @catch (NSException *exception) {
        STR_address = @"No data";
    }
    
    if (STR_address) {
        if ((STR_address.length == 0) || [STR_address isEqualToString:@" "]) {
            STR_address = @"No data";
        }
    }
    
    
    NSString *STR_email;
    @try {
        STR_email = [user valueForKey:@"email"];
    } @catch (NSException *exception) {
        STR_email = @"No data";
    }
    if (STR_email) {
        if ((STR_email.length == 0) || [STR_email isEqualToString:@" "]) {
            STR_email = @"No data";
        }
    }
    
    NSString *STR_phone;
    @try {
        STR_phone = [main_data valueForKey:@"phone"];
    } @catch (NSException *exception) {
        STR_phone = @"No data";
    }
    if (STR_phone) {
        if ((STR_phone.length == 0) || [STR_phone isEqualToString:@" "]) {
            STR_phone = @"No data";
        }
    }
    
    NSString *STR_vehTYP;
    @try {
        STR_vehTYP = [main_data valueForKey:@"vehicle_type"];
    } @catch (NSException *exception) {
        STR_vehTYP = @"No data";
    }
    if (STR_vehTYP) {
        if ((STR_vehTYP.length == 0) || [STR_vehTYP isEqualToString:@" "]) {
            STR_vehTYP = @"No data";
        }
    }
    
    NSString *STR_vehNUM;
    @try {
        STR_vehNUM = [main_data valueForKey:@"vehicle_licence_number"];
    } @catch (NSException *exception) {
        STR_vehNUM = @"No data";
    }
    if (STR_vehNUM) {
        if ((STR_vehNUM.length == 0) || [STR_vehNUM isEqualToString:@" "]) {
            STR_vehNUM = @"No data";
        }
    }
    
    address = [NSArray arrayWithObjects:STR_email,STR_phone,STR_address,STR_vehTYP,STR_vehNUM,@"", nil];
    images = [NSArray arrayWithObjects:@"Email.png",@"Phone",@"Location",@"Car",@"Name-plate",@"",nil];
    
    
    NSString *STR_userName;
    @try {
        STR_userName = [user valueForKey:@"firstname"];
    } @catch (NSException *exception) {
        STR_userName = @"No data";
    }
    if (STR_userName) {
        if ((STR_userName.length == 0) || [STR_userName isEqualToString:@" "]) {
            STR_userName = @"No data";
        }
    }
    
    _LBL_Name.text = STR_userName;
    
    NSString *STR_imageURL;
    @try {
        STR_imageURL = [NSString stringWithFormat:@"%@%@",[json_DATA valueForKey:@"img_path"],[main_data valueForKey:@"profile_pic"]];
    } @catch (NSException *exception) {
        NSLog(@"Exception profile image%@",exception);
    }
    
//    profile_pic
    [[NSUserDefaults standardUserDefaults] setValue:STR_imageURL forKey:@"profile_pic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_IMG_profile sd_setImageWithURL:[NSURL URLWithString:STR_imageURL]
                 placeholderImage:[UIImage imageNamed:@"profile_pic"]
                          options:SDWebImageRefreshCached];
    
    [_profiletab reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  address.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    profile_data_cell *cell = (profile_data_cell *)[tableView dequeueReusableCellWithIdentifier:@"profile_cell"];
    if(cell == nil)
    {
         NSArray *nib;
         nib = [[NSBundle mainBundle] loadNibNamed:@"profile_cell" owner:self options:nil];
         cell = [nib objectAtIndex:0];
    }
    cell.img_view.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    cell.address_lbl.text = [address objectAtIndex:indexPath.row];
//    [cell.address_lbl sizeToFit];
    return cell;
}


#pragma button actions
-(void)backAction
{
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(back_gllg) withObject:nil afterDelay:0.01];
}
-(void) back_gllg
{
    [Helper_activity Stop_animation:self];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)password_chnage
{
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(password_change_nav) withObject:nil afterDelay:0.01];
}
-(void)password_change_nav
{
    
    [Helper_activity Stop_animation:self];
    [self performSegueWithIdentifier:@"change_password_identifier" sender:self];

    
}
-(void)edit_profile
{
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(edit_profile_nav) withObject:nil afterDelay:0.01];


}
-(void)edit_profile_nav
{
    [Helper_activity Stop_animation:self];
    [self performSegueWithIdentifier:@"profie_edit" sender:self];
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

#pragma mark - API Calling
-(void) API_myprofile
{
    NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    //    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    //    NSDictionary *parameters = @{ @"driver_id":driver_ID,@"old_pwd":original_PWD,@"new_pwd":Confirm_new_pwd};
    
    NSString *post = [NSString stringWithFormat:@"driver_id=%@",driver_ID];
    
    NSLog(@"Post contents %@",post);
    
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@viewProfileApi",SERVER_URL];
    
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
        [self setupview :json_DATA];
    }
    else
    {
        NSLog(@"Error %@\nResponse %@",error,response);
    }
    [Helper_activity Stop_animation:self];
}

#pragma mark - Update Segue identifer
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Segue identifier %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"profie_edit"]) {
        update_profile_VC *vc = segue.destinationViewController;
        vc.address = address;
        vc.images = images;
        vc.STR_userName = _LBL_Name.text;
        vc.IMG_profilePIC = _IMG_profile.image;
    }
}

#pragma mark - LogOUT
-(void) Log_OUT
{
    NSLog(@"Log out tapped from MY_profiel_VC");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please confirm" message:@"Are you sure to log out" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Log out", nil];
    alert.tag = 12345;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12345) {
        NSLog(@"Selected button is %ld",(long)buttonIndex);
        if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"tohome" sender:self];
        }
    }
}

@end
