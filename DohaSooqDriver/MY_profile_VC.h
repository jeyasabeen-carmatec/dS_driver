//
//  MY_profile_VC.h
//  DohaSooqDriver
//
//  Created by Test User on 13/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MY_profile_VC : UIViewController

@property (nonatomic,weak) IBOutlet UIImageView *IMG_profile;
@property (nonatomic,weak) IBOutlet UILabel *LBL_Name;
@property (nonatomic,weak)IBOutlet UIButton *BTN_logout;
@property (nonatomic,weak) IBOutlet UITableView *profiletab;
@property (nonatomic,weak) IBOutlet UIButton *BTN_pwd,*BTN_profile;
@property (nonatomic,weak) IBOutlet UIView *main_view;

@end
