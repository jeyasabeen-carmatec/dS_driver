//
//  ViewController.h
//  DohaSooqDriver
//
//  Created by Test User on 12/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic,weak) IBOutlet UITextField *TXT_email;
@property(nonatomic,weak) IBOutlet UITextField *TXT_password;
@property(nonatomic,weak) IBOutlet UIButton *BTN_check;
@property(nonatomic,weak) IBOutlet UIButton *BTN_Login;
@property(nonatomic,weak) IBOutlet UIButton *BTN_forgot_pwd;
@property(nonatomic,weak) IBOutlet UILabel *LBL_stat;
@property(nonatomic,weak) IBOutlet UILabel *error_label;



@end

