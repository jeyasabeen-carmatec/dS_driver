//
//  Order_filter_VC.h
//  DohaSooqDriver
//
//  Created by Test User on 19/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORderfilterDeligate.h"

@interface Order_filter_VC : UIViewController

@property (nonatomic, strong) NSString *STR_date;
@property (nonatomic, strong) NSString *STR_status;

@property (nonatomic,weak) IBOutlet UITextField *TXT_order_ID;
@property (nonatomic,weak) IBOutlet UITextField *TXT_status;
@property (nonatomic,weak) IBOutlet UIButton *BTN_submit;

@property (nonatomic,strong) UIPickerView *status_picker;

@property (nonatomic,strong) UIDatePicker *PICK_date;

@property (nonatomic, assign) id<ORderfilterDeligate> delegate;

@end
