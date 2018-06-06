//
//  update_profile_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 13/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "update_profile_VC.h"
#import "update_profile_cell.h"
#import "Helper_activity.h"

@interface update_profile_VC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIImage *chosenImage;
    CGRect framerect;
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
    NSString *localFilePath;
}
@property(nonatomic,strong) NSMutableDictionary *data_dict;

@end

@implementation update_profile_VC
-(void)viewWillAppear:(BOOL)animated
{
    _profiletab.estimatedRowHeight = 30.0;
    _profiletab.rowHeight = UITableViewAutomaticDimension;
    framerect = self.view.frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupview];
   
   /* VW_overlay = [[UIView alloc]init];
    CGRect vwframe;
    vwframe = VW_overlay.frame;
    vwframe.size.height = 80;
    vwframe.size.width = 120;
    VW_overlay.frame = vwframe;
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]; //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES; */
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap_DTECt:)];
    [tap setCancelsTouchesInView:NO];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

-(void)setupview
{
    _data_dict = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i< [_address count]; i++) {
        switch (i)
        {
            case 0:
                [_data_dict setValue:[_address objectAtIndex:i] forKey:@"email"];
                break;
            case 1:
                [_data_dict setValue:[_address objectAtIndex:i] forKey:@"phone"];
                break;
            case 2:
                [_data_dict setValue:[_address objectAtIndex:i] forKey:@"location"];
                break;
            case 3:
                [_data_dict setValue:[_address objectAtIndex:i] forKey:@"vehicle"];
                break;
            case 4:
                [_data_dict setValue:[_address objectAtIndex:i] forKey:@"vehicle_num"];
                break;
            case 5:
                [_data_dict setValue:_STR_userName forKey:@"username"];
                break;
            default:
                break;
        }
    }
   
    
//address = [NSArray arrayWithObjects:@"Addnan.Vr@gmail.com",@"+974-5869863",@"IBM Qatar SSC,Level 14,Commercial Bank Plaza,Westbay,P.O.Box2711,Doha,Qatar",@"Car",@"Qatar 4635", nil];
//images = [NSArray arrayWithObjects:@"Email.png",@"Phone",@"Location",@"Car",@"Name-plate",nil];
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
        
        newframe = _BTN_save.frame;
        newframe.size.height = 30;
        newframe.size.width = 30;
        _BTN_save.frame = newframe;
        
        newframe = _BTN_pwd.frame;
        newframe.size.height = 30;
        newframe.size.width = 30;
        _BTN_pwd.frame = newframe;
        
        newframe = _BTN_camera.frame;
        newframe.size.height = 30;
        newframe.size.width = 30;
        _BTN_camera.frame = newframe;
        
        
    }

    else if(result.height >= 480)
    {
        
        [_BTN_logout.titleLabel setFont: [_BTN_logout.titleLabel.font fontWithSize: 17]];
        
    }
    else if(result.height >= 667)
    {

        [_BTN_logout.titleLabel setFont: [_BTN_logout.titleLabel.font fontWithSize: 19]];
        
    }
   
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    [_BTN_save addTarget:self action:@selector(save_image) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_pwd addTarget:self action:@selector(password_chnage) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_camera addTarget:self action:@selector(take_Picture) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_logout addTarget:self action:@selector(Log_OUT) forControlEvents:UIControlEventTouchUpInside];
    self.IMG_profile.center = CGPointMake(CGRectGetMidX(self.main_view.bounds),
                                          CGRectGetMidY(self.main_view.bounds));
    _IMG_profile.layer.cornerRadius =  _IMG_profile.frame.size.width / 2;
    
    _IMG_profile.layer.masksToBounds = YES;
    _IMG_profile.layer.borderWidth = 5;
    _IMG_profile.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _IMG_profile.layer.borderColor = [UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0].CGColor;
//    [_IMG_profile setContentMode:UIViewContentModeRedraw];
    _IMG_profile.imageView.contentMode = UIViewContentModeRedraw;
    
    [_IMG_profile setImage:_IMG_profilePIC forState:UIControlStateNormal];
    
    CGRect newframe;
    newframe = _LBL_Name.frame;
    newframe.origin.y = _IMG_profile.frame.origin.y + _IMG_profile.frame.size.height + 10;
    _LBL_Name.frame = newframe;
    
    _LBL_Name.text = _STR_userName;

    newframe = _BTN_camera.frame;
    newframe.origin.x = _IMG_profile.frame.origin.x + _IMG_profile.frame.size.width - _BTN_camera.frame.size.width /2 - _IMG_profile.frame.size.width/10;
    newframe.origin.y = _IMG_profile.frame.origin.y + _IMG_profile.frame.size.height/2 - _BTN_camera.frame.size.height /2 + _IMG_profile.frame.size.height/5;
    _BTN_camera.frame = newframe;
    
    _LBL_Name.layer.borderWidth = 0.5f;
    _LBL_Name.layer.borderColor = [UIColor colorWithRed:0.78 green:0.87 blue:0.95 alpha:1.0].CGColor;
    _BTN_camera.layer.cornerRadius = self.BTN_save.frame.size.width / 2;
    _BTN_camera.layer.masksToBounds = YES;
    _BTN_camera.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _BTN_save.layer.cornerRadius = self.BTN_save.frame.size.width / 2;
    _BTN_save.layer.masksToBounds = YES;
    _BTN_save.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _BTN_pwd.layer.cornerRadius = self.BTN_pwd.frame.size.width / 2;
    _BTN_pwd.layer.masksToBounds = YES;
    _BTN_pwd.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _address.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    update_profile_cell *cell = (update_profile_cell *)[tableView dequeueReusableCellWithIdentifier:@"update_profile_cell"];
    if(cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"update_profile_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.img_view.image = [UIImage imageNamed:[_images objectAtIndex:indexPath.row]];
    cell.address_TEXT.layer.borderWidth = 1.0f;
    cell.address_TEXT.layer.cornerRadius = 1.0f;
    cell.address_TEXT.layer.borderColor = [UIColor colorWithRed:0.78 green:0.87 blue:0.95 alpha:1.0].CGColor;
    cell.address_TEXT.text = [_address objectAtIndex:indexPath.row];
    cell.address_TEXT.tag = indexPath.row;
    NSLog(@"%ld",(long)cell.address_TEXT.tag);
    cell.address_TEXT.delegate = self;
    if(cell.address_TEXT.tag == 0)
    {
        cell.address_TEXT.enabled = NO;
        cell.address_TEXT.backgroundColor = [UIColor lightGrayColor];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
#pragma textfield delgates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"No data"]) {
        textField.text = @"";
    }
    //_error_label.hidden =YES;
    if (textField.tag == 1) {
        [textField setKeyboardType:UIKeyboardTypePhonePad];
    }
    
    if(textField.tag == 2 || textField.tag == 3 || textField.tag == 4)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
   }

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = framerect;
    [UIView commitAnimations];
    
    if (textField == _LBL_Name) {
        [_data_dict setValue:textField.text forKey:@"username"];
    }
   
    NSString *email,*phone,*location,*vehicle,*vehicle_num;
    
    switch (textField.tag)
    {
        case 0:
            email = textField.text;
            NSLog(@"the text is%@",email);
            [_data_dict setValue:email forKey:@"email"];
            break;
        case 1:
            phone = textField.text;
            NSLog(@"the text is%@",phone);
           [_data_dict setValue:phone forKey:@"phone"];
            break;
        case 2:
            location = textField.text;
            NSLog(@"the text is%@",location);
           [_data_dict setValue:location forKey:@"location"];
            break;
        case 3:
            vehicle = textField.text;
            NSLog(@"the text is%@",vehicle);
            [_data_dict setValue:vehicle forKey:@"vehicle"];
            break;
        case 4:
            vehicle_num = textField.text;
            NSLog(@"the text is%@",vehicle_num);
            [_data_dict setValue:vehicle_num forKey:@"vehicle_num"];
            break;
        default:
            break;
    }

    
}

#pragma button actions
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)password_chnage
{
    
    [self performSegueWithIdentifier:@"edit_profile_to_chnage_pwd" sender:self];
}

-(void)save_image
{
    NSLog(@"Update details %@",_data_dict);
    
    if(_LBL_Name.text.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Name should not be empty at least two characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([[_data_dict valueForKey:@"phone"] isEqualToString:@""] || [[_data_dict valueForKey:@"phone"] isEqualToString:@"No data"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Phone number should not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([[_data_dict valueForKey:@"location"] isEqualToString:@""] || [[_data_dict valueForKey:@"location"] isEqualToString:@"No data"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Address should not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([[_data_dict valueForKey:@"Vehicle"] isEqualToString:@""] || [[_data_dict valueForKey:@"Vehicle"] isEqualToString:@"No data"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Vehicle name should not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([[_data_dict valueForKey:@"Vehicle_num"] isEqualToString:@""] || [[_data_dict valueForKey:@"Vehicle_num"] isEqualToString:@"No data"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"vehicle number should not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(API_savePRofile) withObject:nil afterDelay:0.01];
    }
}
-(void)take_Picture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick From"
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"From Gallery", nil];
    
    [actionSheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (buttonIndex == 1)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = info[UIImagePickerControllerEditedImage];
   
    [self.IMG_profile setImage:chosenImage forState:UIControlStateNormal];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
        
        NSLog(@"pre writing to file");
        if (![imageData writeToFile:imagePath atomically:NO])
        {
            NSLog(@"Failed to cache image data to disk");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else
        {
            NSLog(@"the cachedImagedPath is %@",imagePath);
            localFilePath = imagePath;
            
//            VW_overlay.hidden = NO;
//            [activityIndicatorView startAnimating];
            [Helper_activity Start_animation:self];
            [self performSelector:@selector(API_upload_IMG1) withObject:nil afterDelay:0.01];
        }
    }
    else
    {
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSString *imageName = [imagePath lastPathComponent];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        localFilePath = [documentsDirectory stringByAppendingPathComponent:imageName];
        
//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(API_upload_IMG1) withObject:nil afterDelay:0.01];
    }
//    NSLog(@"localFilePath  == %@",localFilePath);
    
    
}

#pragma mark - API Calling

/*-(void) API_savePRofile
 {
 NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
 
 NSError *error;
 NSHTTPURLResponse *response = nil;
 //    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
 //    NSDictionary *parameters = @{ @"driver_id":driver_ID,@"old_pwd":original_PWD,@"new_pwd":Confirm_new_pwd};
 
 NSString *post = [NSString stringWithFormat:@"driver_id=%@&vehicle_type=%@&vehicle_licence_number=%@&address=%@&phone=%@&firstname=%@&email=%@",driver_ID,[_data_dict valueForKey:@"vehicle"],[_data_dict valueForKey:@"vehicle_num"],[_data_dict valueForKey:@"location"],[_data_dict valueForKey:@"phone"],[_data_dict valueForKey:@"username"],[_data_dict valueForKey:@"email"]];
 
 NSLog(@"Post contents %@",post);
 
 //    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
 NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
 NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
 
 NSString *urlGetuser =[NSString stringWithFormat:@"%@editProfileApi",SERVER_URL];
 
 NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setURL:urlProducts];
 [request setHTTPMethod:@"POST"];
 [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 [request setHTTPBody:postData];
 
 //[request setHTTPShouldHandleCookies:NO];
 NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 if (aData)
 {
 //        [activityIndicatorView stopAnimating];
 //        VW_overlay.hidden = YES;
 
 NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
 
 NSLog(@"The json response update profile %@",json_DATA);
 [self.navigationController popViewControllerAnimated:NO];
 
 @try {
 if ([[json_DATA valueForKey:@"status"]isEqualToString:@"success"]) {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
 [alert show];
 }
 } @catch (NSException *exception) {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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

 */


-(void) API_savePRofile
{
    
    
    NSString *post = [NSString stringWithFormat:@"&vehicle_type=%@&vehicle_licence_number=%@&address=%@&phone=%@&firstname=%@&email=%@",[_data_dict valueForKey:@"vehicle"],[_data_dict valueForKey:@"vehicle_num"],[_data_dict valueForKey:@"location"],[_data_dict valueForKey:@"phone"],[_data_dict valueForKey:@"username"],[_data_dict valueForKey:@"email"]];
    
    NSLog(@"Post contents %@",post);
    
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@editProfileApi",SERVER_URL];
    
    [Helper_activity apiWith_PostString:urlGetuser andParams:post completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [Helper_activity Stop_animation:self];
                NSLog(@"%@",[error localizedDescription]);
            }
            if (data) {
                
                [Helper_activity Stop_animation:self];
                NSMutableDictionary *json_DATA = [NSMutableDictionary dictionaryWithDictionary:data];
                
            if ([[NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"session_status"]] isEqualToString:@"1"]) {
                    
                    NSLog(@"The json response update profile %@",json_DATA);
                    [self.navigationController popViewControllerAnimated:NO];
                    
                    @try {
                        if ([[json_DATA valueForKey:@"status"]isEqualToString:@"success"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                            [alert show];
                        }
                    } @catch (NSException *exception) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                    }
            }
                else{
                    
                    
                    NSLog(@"Go to login Page");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Session Timeed Out" message:@"In some other device same user logged in. Please login again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag = 12345;
                    [alert show];
//                     [Helper_activity removeSharedPreferenceValues];
//                     [self performSegueWithIdentifier:@"updateProfile_to_login" sender:self];
                    // go to Login page..
                }
                
               
                
                
            }
            
        });
        
    }];
    

    
    
    
}


-(void) API_upload_IMG1
{
    NSString *urlString = [NSString stringWithFormat:@"%@editProfileImgApi",SERVER_URL];
    //NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    // set Cookie VAlue as Header when it is not Null.........
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isKindOfClass:[NSNull class]] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"<nil>"] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"(null)"] || [[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] != nil) {
        
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
    
    
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_img\"; filename=\"%@\"\r\n",localFilePath] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"driver_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"%@",driver_ID] dataUsingEncoding:NSASCIIStringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];       ......
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // set request body
    [request setHTTPBody:body];
    
    NSURLResponse *response;
    //return and test
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if (response) {
        [Helper_activity filteringCookieValue:response];
    }
    
    NSLog(@"Uploaded status %@", returnString);
//    [activityIndicatorView stopAnimating];
//    VW_overlay.hidden = YES;
    [Helper_activity Stop_animation:self];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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

#pragma mark - Tap Gesture
-(void) Tap_DTECt :(UITapGestureRecognizer *)sender
{
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [self.view endEditing:YES];
    if ([touch.view isDescendantOfView:_BTN_pwd]) {
        return NO;
    }
    else if ([touch.view isDescendantOfView:_BTN_save])
    {
        return NO;
    }
    else if ([touch.view isDescendantOfView:_BTN_camera])
    {
        return NO;
    }
    else if ([touch.view isDescendantOfView:_BTN_logout])
    {
        return NO;
    }
    return YES;
}

#pragma mark - LogOUT
-(void) Log_OUT
{
//    NSLog(@"Log out tapped from MY_profiel_VC");
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driver_id"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self performSegueWithIdentifier:@"tologin" sender:self];
    
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(API_savePRofile) withObject:nil afterDelay:0.01];
}


#pragma mark AlrtView - Delegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 12345)
    {
        [Helper_activity removeSharedPreferenceValues];
        [self performSegueWithIdentifier:@"updateProfile_to_login" sender:self];
        
        
    }
    
    
}


@end
