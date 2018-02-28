//
//  update_profile_VC.h
//  DohaSooqDriver
//
//  Created by Test User on 13/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface update_profile_VC : UIViewController
@property (nonatomic,weak) IBOutlet UIButton *IMG_profile;
@property (nonatomic,weak) IBOutlet UIView *IMG_profile_VW;

@property (nonatomic,weak) IBOutlet UITextField *LBL_Name;
@property (nonatomic,weak)IBOutlet UIButton *BTN_logout;
@property (nonatomic,weak) IBOutlet UITableView *profiletab;
@property (nonatomic,weak) IBOutlet UIButton *BTN_save,*BTN_pwd,*BTN_camera;
@property (nonatomic,weak) IBOutlet UIView *main_view;

@property (nonatomic, weak) NSArray *address,*images;
@property (nonatomic, weak) NSString *STR_userName;
@property (nonatomic, weak) UIImage *IMG_profilePIC;

@end
