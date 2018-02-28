//
//  changepassword_VC.h
//  DohaSooqDriver
//
//  Created by Test User on 13/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changepassword_VC : UIViewController
@property (nonatomic,weak) IBOutlet UITextField *TXT_oldpwd;
@property (nonatomic,weak) IBOutlet UITextField *TXT_newpwd;
@property (nonatomic,weak) IBOutlet UITextField *TXT_confirmpwd;
@property (nonatomic,weak) IBOutlet UIButton *BTN_save;
@property (nonatomic,weak) IBOutlet UILabel *error_label;



@end
