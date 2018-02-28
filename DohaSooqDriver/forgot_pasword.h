//
//  forgot_pasword.h
//  DohaSooqDriver
//
//  Created by Test User on 12/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgot_pasword : UIViewController
@property (nonatomic,weak) IBOutlet UITextField *TXT_email;
@property (nonatomic,weak) IBOutlet UIButton *BTN_submit;
@property(nonatomic,weak) IBOutlet UILabel *error_label;

@end
