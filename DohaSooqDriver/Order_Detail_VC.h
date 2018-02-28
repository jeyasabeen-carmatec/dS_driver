//
//  Order_Detail_VC.h
//  DohaSooqDriver
//
//  Created by Test User on 25/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Order_Detail_VC : UIViewController<GMSMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
//{
//    NSTimer *TIMER_location;
//}

@property (nonatomic,retain) IBOutlet GMSMapView *map_VW;
@property (nonatomic,retain) IBOutlet UIScrollView *Scroll_Content;
@property (nonatomic,retain) IBOutlet UIButton *BTN_Swipe;

#pragma Views
@property (nonatomic,retain) IBOutlet UIButton *BTN_VW;
@property (nonatomic,retain) IBOutlet UIView *order_VW;
@property (nonatomic,retain) IBOutlet UIView *customer_VW;
@property (nonatomic,retain) IBOutlet UIView *pay_VW;
@property (nonatomic,retain) IBOutlet UIView *sign_VW;
@property (nonatomic,retain) IBOutlet UIView *comments_VW;
@property (nonatomic,retain) IBOutlet UIView *status_VW;
@property (nonatomic,retain) IBOutlet UIView *order_detail_VW;

#pragma order view labels
@property (nonatomic,retain) IBOutlet UILabel *oreder_ID;
@property(nonatomic,retain) IBOutlet UILabel *stat_LBL;
@property (nonatomic,retain)IBOutlet UILabel *assigned_DATE;
@property (nonatomic,retain)IBOutlet UILabel *delivery_DATE;
@property (nonatomic,retain)IBOutlet UILabel *lbl_del_slot;
#pragma customer view labels
@property (nonatomic,retain) IBOutlet UILabel *customer_name;
@property(nonatomic,retain) IBOutlet UILabel *customer_phone;
@property (nonatomic,retain)IBOutlet UILabel *customer_address;
#pragma payment method 
@property (nonatomic,retain) IBOutlet UIImageView *LBL_stat;
@property (nonatomic,retain) IBOutlet UIButton *BTN_stat;

@property (nonatomic,retain) IBOutlet UILabel *LBL_subtotal;
@property (nonatomic,retain) IBOutlet UILabel *LBL_shippingcharge;
@property (nonatomic,retain) IBOutlet UILabel *LBL_total;

#pragma signature view
@property(nonatomic,retain) IBOutlet UIButton *sig_display;
@property(nonatomic,retain) IBOutlet UIButton *sig_btn;

#pragma comments view
@property(nonatomic,retain) IBOutlet UITextView *sig_VW;
#pragma update status
@property (nonatomic,retain) IBOutlet  UIImageView *IMG_pen_status;
@property (nonatomic,retain) IBOutlet UIButton *BTN_pending;
@property (nonatomic,retain) IBOutlet UIImageView *IMG_del_status;
@property (nonatomic,retain) IBOutlet UIButton *BTN_deliver;
#pragma Order view
@property (nonatomic,retain) IBOutlet  UILabel *lbl_titl_order;
@property (nonatomic,retain) IBOutlet  UILabel *total_orders;
//@property (nonatomic,retain) IBOutlet  UILabel *item_name;
//@property (nonatomic,retain) IBOutlet  UILabel *order_date;
//@property (nonatomic,retain) IBOutlet  UILabel *quantity;
//@property (nonatomic,retain) IBOutlet  UILabel *price;

@property (nonatomic,retain) IBOutlet UITableView *TBL_orders;

@property (nonatomic,retain) IBOutlet  UILabel *lbl_title_ADR;
@property (nonatomic,retain) IBOutlet  UILabel *lbl_title_PH;

@property (nonatomic,retain) IBOutlet  UILabel *lbl_payment_METH;

@property (nonatomic,retain) IBOutlet UIButton *BTN_Complete;

@end
