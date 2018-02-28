//
//  order_list_cell.h
//  DohaSooqDriver
//
//  Created by Test User on 17/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface order_list_cell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *order_ID_text;
@property (nonatomic,weak) IBOutlet UILabel *order_ID;

@property (nonatomic,weak) IBOutlet UILabel *order_status;
@property (nonatomic,weak) IBOutlet UILabel *Assigned_Date_text;
@property (nonatomic,weak) IBOutlet UILabel *Deliver_date_text;
@property (nonatomic,weak) IBOutlet UILabel *customer_name;
@property (nonatomic,weak) IBOutlet UILabel *customer_address;
@property (nonatomic,weak) IBOutlet UIButton *location;
@property (nonatomic,weak) IBOutlet UIButton *phone;
@property (nonatomic,weak) IBOutlet UILabel *delivery_slot;

@property (nonatomic,weak) IBOutlet UILabel *LBL_pickUP;
//@property (nonatomic,weak) IBOutlet UIButton *BTN_pickup;

@end
