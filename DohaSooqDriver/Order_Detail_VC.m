//
//  Order_Detail_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 25/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Order_Detail_VC.h"
#import "Oreder_detail_VC.h"
#import <CoreLocation/CoreLocation.h>
#import "signature_VC.h"
#import "Helper_activity.h"
#import "Cell_order_items.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface Order_Detail_VC ()<CLLocationManagerDelegate,image_delgate>
{
    CLLocationManager *locationManager;
    GMSMutablePath *path;
//    GMSPolyline *polyline;
//    GMSMarker *marker2,*marker1;
    GMSCameraPosition *camera;
//    NSString *encodedPath ;
//    NSMutableArray *detailedSteps;
    float initial_ht,initial_scroll_ht;
    CGRect button_frame,initial_frame,original_frame,initial_btn_ht; //initial_vw_frame
    float layout_height;
//    GMSMapView *mapview;
    BOOL firstLocationUpdate_;
    NSString *end_address,*strt_address;
    NSMutableDictionary *json_reponse;
    
    NSArray *ARR_orderDetail;
    
    UIImage *chosenImage;
    NSString *product_path1;
    NSString *sig_img_path;
    NSString *product_path2;
   // int subtotal;//showing the Sub total
}
//@property (nonatomic)CLLocationCoordinate2D coordinate;

@end

@implementation Order_Detail_VC

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self navigation_VIEW];

}
-(void)navigation_VIEW
{
//    _LBL_stat.tag = 0;
    _sig_VW.delegate = self;
    
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
    if(result.height >= 480)
    {
     //   [_filter_button.titleLabel setFont: [_filter_button.titleLabel.font fontWithSize: 17]];
    }
    else if(result.height >= 667)
    {
      //  [_filter_button.titleLabel setFont: [_filter_button.titleLabel.font fontWithSize: 19]];
    }
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]}];
    self.navigationItem.title = [@"Order Detail" uppercaseString];
    
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(API_get_order_Detail) withObject:nil afterDelay:0.01];
//    [self set_UP_VW];
    
}
-(void)set_UP_VW
{
    _BTN_VW.layer.cornerRadius = _BTN_VW.frame.size.width / 2;
    _BTN_VW.layer.masksToBounds = YES;
    [_BTN_VW addTarget:self action:@selector(Swipe_Acion) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Complete addTarget:self action:@selector(ACTN_complete) forControlEvents:UIControlEventTouchUpInside];
    
    
    _map_VW.delegate = self;
    
//    _map_VW.accessibilityElementsHidden = NO;
//    _map_VW.settings.compassButton = true;
//    _map_VW.settings.myLocationButton = YES;
//    _map_VW.trafficEnabled = YES;
//    _map_VW.camera = camera;
    
    
//    [_map_VW addObserver:self
//              forKeyPath:@"myLocation"
//                 options:NSKeyValueObservingOptionNew
//                 context:NULL];
    
//    _map_VW.myLocationEnabled = YES;
//    marker2 = [[GMSMarker alloc]init];
//    camera = [GMSCameraPosition cameraWithLatitude:_coordinate.latitude
//                                         longitude:_coordinate.longitude                                                               zoom:13];
   // _map_VW.selectedMarker = marker;
    
    CGRect order_frame = _order_VW.frame;
    // order_frame.origin.x = 10;
    order_frame.origin.y = 0;
    order_frame.size.width = self.view.frame.size.width ;
    _order_VW.frame = order_frame;
    
    [_Scroll_Content addSubview:_order_VW];
    
    CGRect frame_name = _lbl_title_ADR.frame;
    frame_name.origin.y = _customer_name.frame.origin.y + _customer_name.frame.size.height;
    _lbl_title_ADR.frame = frame_name;
    
    [_customer_address sizeToFit];
    frame_name = _customer_address.frame;
    frame_name.origin.y = _lbl_title_ADR.frame.origin.y;
    frame_name.size.height = _customer_address.frame.size.height;
    _customer_address.frame = frame_name;
    
    frame_name = _lbl_title_PH.frame;
    frame_name.origin.y = _customer_address.frame.origin.y + _customer_address.frame.size.height + 10;
    _lbl_title_PH.frame = frame_name;
    
//    frame_name = _lbl_title_PH.frame;
//    frame_name.origin.y = _customer_address.frame.origin.y + _customer_address.frame.size.height + 10;
//    _lbl_title_PH.frame = frame_name;
    
    frame_name = _customer_phone.frame;
    frame_name.origin.y = _lbl_title_PH.frame.origin.y;
    _customer_phone.frame = frame_name;
    
    order_frame = _customer_VW.frame;
    order_frame.origin.x = 10;
    order_frame.origin.y = _order_VW.frame.size.height + _order_VW.frame.origin.y;
    order_frame.size.width = self.view.frame.size.width - 20;
    order_frame.size.height = _customer_phone.frame.origin.y + _customer_phone.frame.size.height + 10;
    _customer_VW.frame = order_frame;
    [_Scroll_Content addSubview:_customer_VW];
    
    
    order_frame = _pay_VW.frame;
    order_frame.origin.x = 10;
    order_frame.origin.y = _customer_VW.frame.size.height + _customer_VW.frame.origin.y + 10;
    order_frame.size.width = self.view.frame.size.width - 20;
    _pay_VW.frame = order_frame;
    [_Scroll_Content addSubview:_pay_VW];
    
    
    order_frame = _sign_VW.frame;
    order_frame.origin.x = 10;
    order_frame.origin.y = _pay_VW.frame.size.height + _pay_VW.frame.origin.y + 10;
    order_frame.size.width = self.view.frame.size.width - 20;
    _sign_VW.frame = order_frame;
    [_Scroll_Content addSubview:_sign_VW];
    
    order_frame = _comments_VW.frame;
    order_frame.origin.x = 10;
    order_frame.origin.y = _sign_VW.frame.size.height + _sign_VW.frame.origin.y + 10;
    order_frame.size.width = self.view.frame.size.width - 20;
    _comments_VW.frame = order_frame;
    
     [_Scroll_Content addSubview:_comments_VW];
    
    order_frame = _status_VW.frame;
    order_frame.origin.x = 10;
    order_frame.origin.y = _comments_VW.frame.size.height + _comments_VW.frame.origin.y + 10;
    order_frame.size.width = _Scroll_Content.frame.size.width - 20;
    _status_VW.frame = order_frame;
    
    [_Scroll_Content addSubview:_status_VW];
    
    order_frame = _order_detail_VW.frame;
    order_frame.origin.y = _status_VW.frame.size.height + _status_VW.frame.origin.y + 10;
    order_frame.size.width = _Scroll_Content.frame.size.width;
    order_frame.size.height = _TBL_orders.frame.origin.y + [self get_height_TBL];
    _order_detail_VW.frame = order_frame;
    
    [_Scroll_Content addSubview:_order_detail_VW];
    
    
    NSLog(@"the height is:%f",initial_ht);
    NSLog(@"initital :%@", NSStringFromCGRect(_map_VW.frame));
    NSLog(@"the frame is :%@", NSStringFromCGRect(initial_frame));
    initial_btn_ht = _BTN_VW.frame;
//    initial_vw_frame = self.view.frame;
    
    CGRect frame_tbl = _TBL_orders.frame;
    frame_tbl.size.height = _TBL_orders.frame.origin.y + [self get_height_TBL];
    _TBL_orders.frame = frame_tbl;
    
    CGRect order_frame1 = _order_detail_VW.frame;
    order_frame1.origin.y = _status_VW.frame.size.height + _status_VW.frame.origin.y + 10;
    order_frame1.size.width = _Scroll_Content.frame.size.width;
    order_frame1.size.height = _TBL_orders.frame.origin.y + [self get_height_TBL];
    _order_detail_VW.frame = order_frame1;
    
    
    layout_height = _order_detail_VW.frame.origin.y + _order_detail_VW.frame.size.height;
    
    
//      layout_height = _order_detail_VW.frame.origin.y + _order_detail_VW.frame.size.height;
    
    
    
    [self viewDidLayoutSubviews];
    
    initial_frame = _Scroll_Content.frame;
    initial_ht = _map_VW.frame.size.height;
    
    [self Swipe_Acion];
}

-(float)get_height_TBL
{
    [_TBL_orders layoutIfNeeded];
    return _TBL_orders.contentSize.height;
}
-(void)put_Data
{
    NSDictionary *dict = [json_reponse valueForKey:@"order"];
    NSDictionary *Orders = [dict valueForKey:@"Orders"];
    NSString *order_text = @"ORDER ID:";
    NSString *order_id = [NSString stringWithFormat:@" #%@",[Orders valueForKey:@"order_number"]];
    NSString *order = [NSString stringWithFormat:@"%@%@",order_text,order_id];
    self.stat_LBL.text = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"shipping_status"] uppercaseString]];
    
    if ([self.oreder_ID respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:self.oreder_ID.textColor,
                                  NSFontAttributeName: self.oreder_ID.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:order attributes:attribs];
        
        
        
        NSRange greenTextRange = [order rangeOfString:order_id];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],  NSFontAttributeName:self.oreder_ID.font}
                                range:greenTextRange];
        
        
        
        self.oreder_ID.attributedText = attributedText;
    }
    else
    {
        self.oreder_ID.text = order;
    }
    
    NSString *assgned_date_text = [NSString stringWithFormat:@"Assigned Date:"];
    NSString *assigend_date;
    @try {
        assigend_date = [NSString stringWithFormat:@"%@",[self formatter_DATE:[dict valueForKey:@"assigned_date"]]];
    } @catch (NSException *exception) {
        assigend_date = @"NA";
    }
    
//    NSString *delivery_date_text =[NSString stringWithFormat:@"Delivery Date:"];
//    NSString *delivery_date = @"NA";//[NSString stringWithFormat:@"%@",[dict valueForKey:@"key2"]];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@",assgned_date_text,assigend_date];
//    NSString *delivery_text = [NSString stringWithFormat:@"%@ %@",delivery_date_text,delivery_date];
    
    
    if ([_assigned_DATE respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_assigned_DATE.textColor,
                                  NSFontAttributeName: _assigned_DATE.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        NSRange greenTextRange = [text rangeOfString:assigend_date];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0] ,NSFontAttributeName:self.oreder_ID.font}
                                range:greenTextRange];
         _assigned_DATE.attributedText = attributedText;
    }
    else
    {
        _assigned_DATE.text = text;
    }
    
    
    
   /* if ([_delivery_DATE respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribsd = @{
                                   NSForegroundColorAttributeName:_delivery_DATE.textColor,
                                   NSFontAttributeName: _delivery_DATE.font
                                   };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:delivery_text attributes:attribsd];
        
        // UIFont *unboldFont = [UIFont fontWithName:@"Roboto-Medium" size:14];
        NSRange greenTextRange = [delivery_text rangeOfString:delivery_date];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0],NSFontAttributeName:self.oreder_ID.font}range:greenTextRange];
        _delivery_DATE.attributedText = attributedText;
    }
    else
    {
        _delivery_DATE.text = delivery_text;
    }
    */
    
    _delivery_DATE.hidden = YES;
    
    
    NSString *STR_customerName = [NSString stringWithFormat:@"%@ %@",[Orders valueForKey:@"shipping_firstname"],[Orders valueForKey:@"shipping_lastname"]];
    STR_customerName = [STR_customerName stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    
    if (STR_customerName.length == 0) {
        STR_customerName = @"No data";
    }
    
    _customer_name.text = STR_customerName;
    
    NSString *STR_address_ln1;
    NSString *STR_address_ln2;
    NSString *STR_address_city;
    NSString *STR_address_state;
    NSString *STR_address_cntry;
    NSString *STR_zip_Code;
    
    @try {
        STR_address_ln1 = [Orders valueForKey:@"shipping_address1"];
    } @catch (NSException *exception) {
        STR_address_ln1 = @"";
    }
    
    @try {
        STR_address_ln2 = [Orders valueForKey:@"shipping_address2"];
    } @catch (NSException *exception) {
        STR_address_ln2 = @"";
    }
    
    @try {
        STR_address_city = [Orders valueForKey:@"shipping_city"];
    } @catch (NSException *exception) {
        STR_address_city = @"";
    }
    
    @try {
        STR_address_state = [Orders valueForKey:@"shipping_state"];
    } @catch (NSException *exception) {
        STR_address_state = @"";
    }
    
    @try {
        STR_address_cntry = [Orders valueForKey:@"shipping_country"];
    } @catch (NSException *exception) {
        STR_address_cntry = @"";
    }
    
    @try {
        STR_zip_Code = [Orders valueForKey:@"shipping_zip_code"];
    } @catch (NSException *exception) {
        STR_zip_Code = @"";
    }
    
    NSString *STR_addr;
    if (STR_address_ln1.length == 0) {
        NSLog(@"No address line 1");
    }
    else
    {
        STR_addr = STR_address_ln1;
    }
    
    if (STR_address_ln2.length == 0) {
        NSLog(@"No Addressline 2");
    }
    else
    {
        STR_addr = [NSString stringWithFormat:@"%@, %@",STR_addr,STR_address_ln2];
    }
    
    if (STR_address_city.length == 0) {
        NSLog(@"No city");
    }
    else
    {
        STR_addr = [NSString stringWithFormat:@"%@, %@",STR_addr,STR_address_city];
    }
    
    if (STR_address_state.length == 0) {
        NSLog(@"No state");
    }
    else
    {
        STR_addr = [NSString stringWithFormat:@"%@, %@",STR_addr,STR_address_state];
    }
    
    if (STR_address_cntry.length == 0) {
        NSLog(@"No Cntry");
    }
    else
    {
        STR_addr = [NSString stringWithFormat:@"%@, %@",STR_addr,STR_address_cntry];
    }
    
    if (STR_zip_Code.length == 0) {
        NSLog(@"No zip code");
    }
    else
    {
        STR_addr = [NSString stringWithFormat:@"%@, %@",STR_addr,STR_zip_Code];
    }
    
    if (STR_addr.length == 0) {
        STR_addr = @": No data";
    }
    else
    {
        STR_addr = [NSString stringWithFormat:@": %@",STR_addr];
    }
    
    _customer_address.text = STR_addr;
    _customer_address.numberOfLines = 0;
    [_customer_address sizeToFit];
    
    
    NSString *STR_delivery_slot;
    NSString *STR_print_delivery;
    
    @try {
        STR_delivery_slot = [Orders valueForKey:@"delivery_slot"];
    } @catch (NSException *exception) {
        STR_delivery_slot = @"Not Mentioned";
    }
    
    STR_print_delivery = [NSString stringWithFormat:@"Delivery Slot : %@",STR_delivery_slot];
    
    if ([_lbl_del_slot respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribsd = @{
                                   NSForegroundColorAttributeName:_assigned_DATE.textColor,
                                   NSFontAttributeName: _assigned_DATE.font
                                   };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:STR_print_delivery attributes:attribsd];
        
        // UIFont *unboldFont = [UIFont fontWithName:@"Roboto-Medium" size:14];
        NSRange greenTextRange = [STR_print_delivery rangeOfString:STR_delivery_slot];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0],NSFontAttributeName:_assigned_DATE.font}range:greenTextRange];
        _lbl_del_slot.attributedText = attributedText;
    }
    else
    {
        _lbl_del_slot.text = STR_print_delivery;
    }
    
    
    NSString *STR_phone;
    @try {
        STR_phone = [Orders valueForKey:@"shipping_mobile"];
        STR_phone = [STR_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@"No data"];
    } @catch (NSException *exception) {
        STR_phone = @"No data";
    }
    
    _customer_phone.text = [NSString stringWithFormat:@" : %@",STR_phone];
    
    NSString *STR_img_url;
    
    @try {
        STR_img_url = [dict valueForKey:@"customer_signature"];
    } @catch (NSException *exception) {
        NSLog(@"Exception from customer signature %@",exception);
    }
    
    
    
   /* if (![STR_shipSTAT isEqualToString:@"Pending"]) {
        _sig_btn.userInteractionEnabled = NO;
        _sig_btn.alpha = 0.5;
    }*/
    
    /*if (STR_img_url) {
        @try {
            NSURL *URL_img = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",sig_img_path,[json_reponse valueForKey:@"customer_signature"]]];
            NSData *IMG_data = [NSData dataWithContentsOfURL:URL_img];
            
            if (IMG_data) {
                UIImage *IMG_sign = [UIImage imageWithData:IMG_data];
                [self.sig_display setTitle:@"" forState:UIControlStateNormal];
                [self.sig_display setBackgroundImage:IMG_sign forState:UIControlStateNormal];
            }
            
            
            
        } @catch (NSException *exception) {
            NSLog(@"Exception from update image");
        }
    }*/
    
    @try {
//        NSString *STR_shipSTAT = [NSString stringWithFormat:@"%@",[dict valueForKey:@"shipping_status"]];
        
//        if ([STR_shipSTAT isEqualToString:@"Pending"]) {
            [_IMG_pen_status setTag:0];
            _IMG_pen_status.image = [UIImage imageNamed:@"checked_order"];
            
            [_IMG_del_status setTag:1];
            _IMG_del_status.image = [UIImage imageNamed:@"uncheked_order"];
//        }
//        else
//        {
//            [_IMG_pen_status setTag:1];
//            _IMG_pen_status.image = [UIImage imageNamed:@"uncheked_order"];
//            
//            [_IMG_del_status setTag:0];
//            _IMG_del_status.image = [UIImage imageNamed:@"checked_order"];
//        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception from update button %@",exception);
    }
    
//    @try {
    NSString *STR_driverSTAT;
    STR_driverSTAT = [NSString stringWithFormat:@"%@",[dict valueForKey:@"driver_comment"]];
        if ([STR_driverSTAT isEqualToString:@"Null"]) {
            _sig_VW.userInteractionEnabled = YES;
        }
//    } @catch (NSException *exception) {
//        NSLog(@"Exception from update button %@",exception);
//    }
    
    
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    _sig_display.layer.borderWidth = 0.5;
    _sig_display.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _sig_VW.layer.borderWidth = 0.5;
    _sig_VW.layer.borderColor = [UIColor lightGrayColor].CGColor;

    
    [_BTN_stat addTarget:self action:@selector(status_chnaged) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_pending addTarget:self action:@selector(pen_status_changed) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_deliver addTarget:self action:@selector(deliver_stat_changed) forControlEvents:UIControlEventTouchUpInside];
    [_sig_btn addTarget:self action:@selector(get_signature) forControlEvents:UIControlEventTouchUpInside];
    [_sig_display addTarget:self action:@selector(get_signature) forControlEvents:UIControlEventTouchUpInside];
    
    [self set_UP_VW];

}

#pragma Button Actions
-(void)status_chnaged
{
    if(_LBL_stat.tag == 0)
    {
        _LBL_stat.image = [UIImage imageNamed:@"uncheked_order"];
        [_LBL_stat setTag:1];
    }
    else if(_LBL_stat.tag == 1)
    {
        _LBL_stat.image = [UIImage imageNamed:@"checked_order"];
        [_LBL_stat setTag:0];
    }
}
-(void)pen_status_changed
{
  
    if(_IMG_pen_status.tag == 0)
    {
        _IMG_pen_status.image = [UIImage imageNamed:@"uncheked_order"];
        [_IMG_pen_status setTag:1];
        
        _IMG_del_status.image = [UIImage imageNamed:@"checked_order"];
        [_IMG_del_status setTag:0];
    }
    else if(_IMG_pen_status.tag == 1)
    {
        _IMG_pen_status.image = [UIImage imageNamed:@"checked_order"];
        [_IMG_pen_status setTag:0];
        
        _IMG_del_status.image = [UIImage imageNamed:@"uncheked_order"];
        [_IMG_del_status setTag:1];
    }
    
    
}
-(void)deliver_stat_changed
{
    if(_IMG_del_status.tag == 0)
    {
        _IMG_del_status.image = [UIImage imageNamed:@"uncheked_order"];
        [_IMG_del_status setTag:1];
        
        _IMG_pen_status.image = [UIImage imageNamed:@"checked_order"];
        [_IMG_pen_status setTag:0];
    }
    else if(_IMG_del_status.tag == 1)
    {
        _IMG_del_status.image = [UIImage imageNamed:@"checked_order"];
        [_IMG_del_status setTag:0];
        
        _IMG_pen_status.image = [UIImage imageNamed:@"uncheked_order"];
        [_IMG_pen_status setTag:1];
    }
    
    
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    [_sig_VW resignFirstResponder];
    _sig_VW.text = @"Enter customer comments";
//        self.view.frame = initial_vw_frame;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"Swipe Up");
        
        CGRect frame_map = _map_VW.frame;
        frame_map.size.height = self.map_VW.frame.size.height/3 + _BTN_VW.frame.size.height;
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                            
                             _map_VW.frame = frame_map;
                             
                             CGRect btnframe_anim = _BTN_VW.frame;
                             btnframe_anim.origin.y = _map_VW.frame.size.height + _map_VW.frame.origin.y - _BTN_VW.frame.size.height - 10;
                             _BTN_VW.frame = btnframe_anim;
                             CGRect frame_scroll = _Scroll_Content.frame;
                             frame_scroll.origin.y =  _map_VW.frame.origin.y + _map_VW.frame.size.height;
//                             frame_scroll.size.height = [UIScreen mainScreen].bounds.size.height - _map_VW.frame.size.height - 100;
                             _Scroll_Content.frame = frame_scroll;
                         }];
        
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView commitAnimations];
        
        layout_height = _order_detail_VW.frame.origin.y + _order_detail_VW.frame.size.height;
        
        [_BTN_VW setTitle:@"" forState:UIControlStateNormal];

    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"Swipe Down");
        CGRect frame_map = _map_VW.frame;
        frame_map.size.height = initial_ht;
        
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _map_VW.frame = frame_map;
                             _BTN_VW.frame  = initial_btn_ht;
                             CGRect frame_scroll = _Scroll_Content.frame;
                             frame_scroll = initial_frame;
                             _Scroll_Content.frame = frame_scroll;                             
                             
                             
                         }];
        
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        
        
        [UIView commitAnimations];
        
        
        layout_height = initial_frame.size.height;
        
        [_BTN_VW setTitle:@"" forState:UIControlStateNormal];

    }
}
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

-(void)Swipe_Acion
{
    NSLog(@"Tap detected ");
     [_sig_VW resignFirstResponder];
    _sig_VW.text = @"Enter customer comments";
//      self.view.frame = initial_vw_frame;
    if ([_BTN_VW.titleLabel.text isEqualToString:@""])
    {
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                             CGRect frame_map = _map_VW.frame;
                             frame_map.size.height = self.map_VW.frame.size.height/3 + _BTN_VW.frame.size.height;
                             _map_VW.frame = frame_map;
                             
                             CGRect btnframe_anim = _BTN_VW.frame;
                             btnframe_anim.origin.y = _map_VW.frame.size.height + _map_VW.frame.origin.y - _BTN_VW.frame.size.height -10;
                             _BTN_VW.frame = btnframe_anim;
                             
                             CGRect frame_scroll = _Scroll_Content.frame;
                             frame_scroll.origin.y =  _map_VW.frame.origin.y + _map_VW.frame.size.height;
                             frame_scroll.size.height = [UIScreen mainScreen].bounds.size.height - _map_VW.frame.size.height;
                             _Scroll_Content.frame = frame_scroll;
                         }];
       
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
         [UIView commitAnimations];
        //self.view.frame = initial_vw_frame;
       
        layout_height = _order_detail_VW.frame.origin.y + _order_detail_VW.frame.size.height;
        
        [_BTN_VW setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        CGRect frame_map = _map_VW.frame;
        NSLog(@"the height is:%f",initial_ht);

        frame_map.size.height = initial_ht;
        
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                             
                             _map_VW.frame = frame_map;
                             _BTN_VW.frame  = initial_btn_ht;
                             CGRect frame_scroll = _Scroll_Content.frame;
                             frame_scroll = initial_frame;
//                             frame_scroll.size.height = [UIScreen mainScreen].bounds.size.height - _Scroll_Content.frame.origin.y;
                             _Scroll_Content.frame = frame_scroll;
                             
                         }];
        
        
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView commitAnimations];
       // self.view.frame = initial_vw_frame;

        layout_height = initial_frame.size.height;
        [_BTN_VW setTitle:@"" forState:UIControlStateNormal];
    }
}

-(void)send_IMAGE:(UIImage *)resimage
{
    chosenImage = resimage;
    [self.sig_display setTitle:@"" forState:UIControlStateNormal];
    [self.sig_display setBackgroundImage:resimage forState:UIControlStateNormal];
}
-(void)get_signature
{
    [self performSegueWithIdentifier:@"signature_segue" sender:self];
    [_sig_VW resignFirstResponder];
    _sig_VW.text = @"Enter customer comments";
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"signature_segue"]) {
        signature_VC *sign_vw = segue.destinationViewController;
        sign_vw.delegate = self;
    }
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _Scroll_Content.contentSize = CGSizeMake(_Scroll_Content.frame.size.width , _order_detail_VW.frame.size.height + _order_detail_VW.frame.origin.y + 100 );
}

#pragma mark - CLLocationManager
- (void)dealloc {
    [super dealloc];
//    [_map_VW removeObserver:self
//                 forKeyPath:@"myLocation"
//                    context:NULL];
}

/*-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    if (!firstLocationUpdate_)
    {
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _map_VW.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:13];
    }
}*/

/*-(void)GetCurrentLocation_WithBlock {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
}*/

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    locationManager.delegate = nil;
    CLLocation *currentLoc=[locations objectAtIndex:0];

    
    _map_VW.camera = [GMSCameraPosition cameraWithTarget:currentLoc.coordinate
                                                    zoom:17];
    
    GMSMarker *marker = [[GMSMarker alloc]init];
    marker.position = CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude);
    marker.tracksViewChanges = NO;
    //marker.tappable = YES;
    marker.tracksInfoWindowChanges = YES;
    //marker.title = @"Myloaction";
    marker.map = _map_VW;
  
    [_map_VW animateToLocation:CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)];

}

/*- (void)locationManager:(CLLocationManager *)manager  didUpdateHeading:(CLHeading *)newHeading
{
    double heading = (- newHeading.trueHeading) * M_PI / 180.0f;
    double headingDegrees = (heading*M_PI/180);
    [_map_VW animateToViewingAngle:headingDegrees];
    CLLocationDirection trueNorth = [newHeading trueHeading];
    //[mapView animateToBearing:trueNorth];
    marker2.rotation = trueNorth;
}
-(void)map_polyline
{
    [locationManager startUpdatingLocation];
   
    float destlat;
    float destlang;
    
    @try {
        destlat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] floatValue];
    } @catch (NSException *exception) {
        NSLog(@"Exception update route %@",exception);
    }
    
    @try {
        destlang =[[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] floatValue];
    } @catch (NSException *exception) {
        NSLog(@"Exception update long %@",exception);
    }
    
    if (destlat && destlang) {
        camera = [GMSCameraPosition cameraWithLatitude:destlat
                                             longitude:destlang  zoom:20];
        NSLog(@"the destination lat and long are:%f,%f",destlat,destlang);
        
        
        NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&alternateroutes=false&sensor=true" ,_coordinate.latitude,_coordinate.longitude,destlat,destlang]];
        NSURLResponse *res;
        NSError *err;
        NSData *data=[NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:url] returningResponse:&res error:&err];
        if(data)
        {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if(dic)
            {
                
                NSString *stattus = [dic valueForKey:@"status"];
                if([stattus isEqualToString:@"ZERO_RESULTS"] || [stattus isEqualToString:@"OVER_QUERY_LIMIT"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"No Route Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                else{
                    
                    NSLog(@"The Total dic:%@",dic);
                    NSArray *routes=dic[@"routes"];
                    
                    NSArray *legs=routes[0][@"legs"];
                    strt_address = [legs valueForKey:@"start_address"];
                    NSLog(@" the address :%@",strt_address);
                    //marker.title = strt_address;
                    end_address = [legs valueForKey:@"end_address"];
                    
                    
                    NSArray *steps=legs[0][@"steps"];
                    NSLog(@"the legs are:%@",steps);
                    NSMutableArray *textsteps=[[NSMutableArray alloc] init];
                    NSMutableArray *latlong=[[NSMutableArray alloc]init];
                    for(int i=0; i< [steps count]; i++){
                        NSString *html=steps[i][@"html_instructions"];
                        [latlong addObject:steps[i][@"end_location"]];
                        NSLog(@"the data:%@",steps[i][@"end_location"]);
                        [textsteps addObject:html];
                        encodedPath    = [[[steps objectAtIndex:i] valueForKey:@"polyline"] valueForKey:@"points"];
                        [self polylineWithEncodedString:encodedPath];
                        
                        // Add the polyline to the map.
                        polyline.strokeColor = [UIColor colorWithRed:0.01 green:3.10 blue:0.99 alpha:1.0];
                        polyline.strokeWidth =10.0f;
                        polyline.map = _map_VW;
                        NSLog(@"the encoded patg:%@",encodedPath);
                        
                        
                        //  [_locationManager stopUpdatingLocation];
                        
                        NSLog(@"Direction path");
                        
                        
                    }
                    detailedSteps=textsteps;
                    NSLog(@"the routes:%@",textsteps);
                    NSLog(@"the Latitude and langitudes:%@",latlong);
                    [self showDirection:latlong];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
            [alert show];
        }
    }
    
    
    
}*/

/*-(void)polylineWithEncodedString:(NSString *)encodedString {
    
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    path = [[GMSMutablePath alloc] init];
    
    int i;
    for (i = 0; i < coordIdx; i++)
    {
        [path addCoordinate:coords[i]];
        
        
    }
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    marker1 = [[GMSMarker alloc]init];
    marker1.position = [path coordinateAtIndex:idx];
    marker1.map = _map_VW;
    [CATransaction commit];
    
    polyline = [GMSPolyline polylineWithPath:path];
    free(coords);
    
}*/
/*-(void)showDirection:(NSMutableArray*) latlong        {
    double lat = 0.0,lng = 0.0;
    for(int i=0; i<[latlong count]; i++){
        lat=[latlong[i][@"lat"] doubleValue];
        lng=[latlong[i][@"lng"] doubleValue];
    }
    marker1 = [[GMSMarker alloc]init];
   // marker1.tappable = YES;
    marker1.position = CLLocationCoordinate2DMake(lat, lng);
   // marker1.title = end_address;
    marker1.snippet = end_address;
    
   // _map_VW.selectedMarker = marker1;
    marker1.map = _map_VW;
    
    
    NSLog(@"Direction path");
    camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:13];
    
    
}
#pragma textview delegates
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString *txt_vw_text = _sig_VW.text;
    if([txt_vw_text isEqualToString:@"Enter customer comments"])
    {
        _sig_VW.text = @"";
    }
    else
    {
        _sig_VW.text = txt_vw_text;
    }
}*/

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = @"Enter customer comments";
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *txt_vw_text = _sig_VW.text;
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140)
    {
        if (location != NSNotFound){
            [textView resignFirstResponder];
            _sig_VW.text = @"Enter customer comments";
            
        }
        return NO;
    }
    else if (location != NSNotFound){
        if([_sig_VW.text isEqualToString:@""])
        {
            _sig_VW.text = @"Enter customer comments";
            
        }
        else if(_sig_VW.text.length >0)
        {
            _sig_VW.text = txt_vw_text;
            
        }
        [textView resignFirstResponder];
        
        
        return NO;
        
    }
    
    return YES;
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
-(void) API_get_order_Detail
{
    float SUB_TOTAL_VAL = 0;
//    float TOTAL_VAL = 0;
//    float SHIPPING_VAL = 0;
    
    NSString *STR_orderid = [[NSUserDefaults standardUserDefaults] valueForKey:@"order_ID"];
    NSString *STR_driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *post = [NSString stringWithFormat:@"driver_id=%@&shipment_id=%@",STR_driver_ID,STR_orderid];
    
    NSLog(@"Post contents %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@DriverOrderDetailApi",SERVER_URL];
    
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
        json_reponse = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Order_Detail_VC.m API response DriverOrderDetailApi %@",json_reponse);
        
        @try {
            product_path1 = [json_reponse valueForKey:@"product_path1"];
        } @catch (NSException *exception) {
            NSLog(@"Exception from update product path %@",exception);
        }
        
        @try {
            sig_img_path = [json_reponse valueForKey:@"sig_img_path"];
        } @catch (NSException *exception) {
            NSLog(@"Exception from update sighn path %@",exception);
        }
        
        @try {
            product_path2 = [json_reponse valueForKey:@"product_path2"];
        } @catch (NSException *exception) {
            NSLog(@"Exception from update product path 2 %@",exception);
        }
        
        NSDictionary *order = [json_reponse valueForKey:@"order"];
        NSDictionary *Orders = [order valueForKey:@"Orders"];
        
        
        
        @try {
            @try {
                ARR_orderDetail = [json_reponse valueForKey:@"items"];
                int QTY_VAL = 0;

                for (int k = 0; k < [ARR_orderDetail count]; k++) {
                    NSDictionary *temp_dictin = [ARR_orderDetail objectAtIndex:k];
                    NSDictionary *OrderProducts = [temp_dictin valueForKey:@"OrderProducts"];
                    NSString *product_quantity = [OrderProducts valueForKey:@"product_quantity"];
                    QTY_VAL = QTY_VAL + [product_quantity intValue];
                    
                    NSString *product_price = [OrderProducts valueForKey:@"product_price"];
                    product_price = [product_price stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
                    product_price = [product_price stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
                    SUB_TOTAL_VAL = SUB_TOTAL_VAL + [product_price intValue];
                }
                
                
                
                NSString *total_orders_text = @"TOTAL ORDERS : ";
                NSString *order_quantity = [NSString stringWithFormat:@"%i",QTY_VAL];
                NSString *total_orders = [NSString stringWithFormat:@"%@%@",total_orders_text,order_quantity];
                if ([_total_orders respondsToSelector:@selector(setAttributedText:)]) {
                    
                    // Define general attributes for the entire text
                    NSDictionary *attribsd = @{
                                               NSForegroundColorAttributeName:_total_orders.textColor,
                                               NSFontAttributeName: _total_orders.font
                                               };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:total_orders attributes:attribsd];
                    
                    NSRange greenTextRange = [total_orders rangeOfString:order_quantity];
                    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0],NSFontAttributeName:self.lbl_titl_order.font}range:greenTextRange];
                    _total_orders.attributedText = attributedText;
                }
                else
                {
                    _total_orders.text = total_orders;
                }
                
                if ([ARR_orderDetail count] > 0) {
                    _TBL_orders.delegate = self;
                    _TBL_orders.dataSource = self;
                    [_TBL_orders reloadData];
                }
            } @catch (NSException *exception) {
                NSLog(@"Exception from order detail %@",exception);
            }
            
            
            NSDictionary *CustomerPayments = [order valueForKey:@"CustomerPayments"];
            
            @try {
                _lbl_payment_METH.text = [CustomerPayments valueForKey:@"payment_method"];
                if ([[CustomerPayments valueForKey:@"payment_method"] isEqualToString:@"COD"]) {
                    _LBL_stat.hidden = NO;
                }
                else
                {
                    CGRect frame = _LBL_stat.frame;
                    _LBL_stat.hidden = YES;
                    CGRect new_frame = _lbl_payment_METH.frame;
                    new_frame.origin.x = frame.origin.x;
                    _lbl_payment_METH.frame = new_frame;
                }
            } @catch (NSException *exception) {
                _lbl_payment_METH.text = @"";
            }
            
            //    _LBL_code
            NSDictionary *Currencies = [order valueForKey:@"Currencies"];
            NSString *STR_subtot,*STR_shipping,*STR_tot;
            
            @try {
                
                NSString *STR_totel = [NSString stringWithFormat:@"%.2f",SUB_TOTAL_VAL];
                
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
                [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
                [numberFormatter setCurrencySymbol:@""];
                NSString *result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[STR_totel floatValue]]];
                
                STR_subtot = [NSString stringWithFormat:@"%@ %@",[Currencies valueForKey:@"currency_symbol_left"],result];
            } @catch (NSException *exception) {
                STR_subtot = @"0.00";
            }
            
            _LBL_subtotal.text = STR_subtot;
            
            NSString *shiping_FLG = [NSString stringWithFormat:@"%@",[json_reponse valueForKey:@"shipping_charge_flag"]];
            if ([shiping_FLG isEqualToString:@"0"]) {
                STR_shipping = @"0.00";
            }
            else
            {
                @try {
                    
                    NSString *STR_totel = [NSString stringWithFormat:@"%.2f",[[Orders valueForKey:@"shipping_amount"] floatValue]];
                    
                    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
                    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
                    [numberFormatter setCurrencySymbol:@""];
                    NSString *result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[STR_totel floatValue]]];
                    
                    STR_shipping = [NSString stringWithFormat:@"%@ %@",[Currencies valueForKey:@"currency_symbol_left"],result];
                } @catch (NSException *exception) {
                    STR_shipping = @"0.00";
                }
            }
            
            
            _LBL_shippingcharge.text = STR_shipping;
            
            
            @try {
                
                float total;
                NSString *STR_totel;
                if ([shiping_FLG isEqualToString:@"0"]) {
                    total = SUB_TOTAL_VAL;
                }
                else
                {
                    total = SUB_TOTAL_VAL + [[Orders valueForKey:@"shipping_amount"] floatValue];
                }
                
                STR_totel = [NSString stringWithFormat:@"%.2f",total];
                
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
                [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
                [numberFormatter setCurrencySymbol:@""];
                NSString *result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[STR_totel floatValue]]];
                
                STR_tot = [NSString stringWithFormat:@"%@ %@",[Currencies valueForKey:@"currency_symbol_left"],result];
            } @catch (NSException *exception) {
                STR_tot = @"0.00";
            }
            
            _LBL_total.text = STR_tot;
            
            
            
          /*  NSString *total_txt = @"TOTAL - ";
            NSString *code_txt = [NSString stringWithFormat:@"%@%@",total_txt,STR_tot];
            if ([_LBL_code respondsToSelector:@selector(setAttributedText:)]) {
                
                // Define general attributes for the entire text
                NSDictionary *attribsd = @{
                                           NSForegroundColorAttributeName:_LBL_code.textColor,
                                           NSFontAttributeName: _LBL_code.font
                                           };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:code_txt attributes:attribsd];
                
                NSRange greenTextRange = [code_txt rangeOfString:STR_tot];
                [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0],NSFontAttributeName:self.stat_LBL.font}range:greenTextRange];
                _LBL_code.attributedText = attributedText;
            }
            else
            {
                _LBL_code.text = code_txt;
            }*/
            
            [self put_Data];
            
            NSString *STR_lat,*STR_long;
            @try {
                STR_lat = [Orders valueForKey:@"shipping_latitude"];
            } @catch (NSException *exception) {
                STR_lat = @"No data";
            }
            
            if (!STR_lat) {
                STR_lat = @"No data";
            }
            
            @try {
                STR_lat = [STR_lat stringByReplacingOccurrencesOfString:@"<null>" withString:@"No data"];
            } @catch (NSException *exception) {
                STR_lat = @"No data";
            }
            
            @try {
                STR_long = [Orders valueForKey:@"shipping_longitude"];
            } @catch (NSException *exception) {
                STR_long = @"No data";
            }
            
            if (!STR_long) {
                STR_long = @"No data";
            }
            
            @try {
                STR_long = [STR_long stringByReplacingOccurrencesOfString:@"<null>" withString:@"No data"];
            } @catch (NSException *exception) {
                STR_long = @"No data";
            }
            
            if (![STR_lat isEqualToString:@"No data"] && ![STR_long isEqualToString:@"No data"]) {
                
//                [[NSUserDefaults standardUserDefaults] setValue:STR_lat forKey:@"latitude"];
//                [[NSUserDefaults standardUserDefaults] setValue:STR_long forKey:@"longitude"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [self GetCurrentLocation_WithBlock];
                
                CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:[STR_lat longLongValue] longitude:[STR_long longLongValue]];
                _map_VW.camera = [GMSCameraPosition cameraWithTarget:currentLoc.coordinate
                                                                zoom:17];
                
                GMSMarker *marker = [[GMSMarker alloc]init];
                marker.position = CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude);
                marker.tracksViewChanges = NO;
                //marker.tappable = YES;
                marker.tracksInfoWindowChanges = YES;
                //marker.title = @"Myloaction";
                marker.map = _map_VW;
                
                [_map_VW animateToLocation:CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)];
                
            }
            else
            {
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude"];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                [self GetCurrentLocation_WithBlock];
                
                locationManager = [[CLLocationManager alloc] init];
                locationManager.delegate = self;
                locationManager.desiredAccuracy=kCLLocationAccuracyBest;
                locationManager.distanceFilter=kCLDistanceFilterNone;
                [locationManager requestWhenInUseAuthorization];
//                [locationManager startMonitoringSignificantLocationChanges];
                [locationManager startUpdatingLocation];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Exception from Add item %@",exception);
        }
        
    }
    else
    {
        NSLog(@"Error %@\nResponse %@",error,response);
    }
    
    [Helper_activity Stop_animation:self];
}
#pragma mark - Update order API
-(void) API_updateORDER
{
    NSString *urlString = [NSString stringWithFormat:@"%@updateOrderDeliveryApi",SERVER_URL];
    NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    NSString *STR_orderid = [[NSUserDefaults standardUserDefaults] valueForKey:@"order_ID"];
//    NSString *STR_STTT = @"Delivered";
    
    NSString *STR_comment = _sig_VW.text;
    STR_comment = [STR_comment stringByReplacingOccurrencesOfString:@"Enter customer comments" withString:@""];
    
    
    NSData *imageData1 = UIImagePNGRepresentation(chosenImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog(@"pre writing to file");
    if (![imageData1 writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"sig_img\"; filename=\"%@\"\r\n",imagePath] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"driver_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",driver_ID] dataUsingEncoding:NSASCIIStringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"shipping_status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",STR_STTT] dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"shipping_status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Delivered"] dataUsingEncoding:NSASCIIStringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"SS\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Delivered"] dataUsingEncoding:NSASCIIStringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"shipment_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",STR_orderid] dataUsingEncoding:NSASCIIStringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"driver_comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",STR_comment] dataUsingEncoding:NSASCIIStringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"order_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[[NSString stringWithFormat:@"%@",STR_orderid] dataUsingEncoding:NSASCIIStringEncoding]];
    //    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    NSError *error;
//    NSString *json_DATA = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    //return and test
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
     NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&error];
    
    NSLog(@"Posted data %@\nUploaded status %@",json_DATA, returnString);
    
    if ([[json_DATA valueForKey:@"status"]isEqualToString:@"success"]) {
        [self performSegueWithIdentifier:@"order_list_to_home" sender:self];
    }
//    order_list_to_home
    
    /*
     NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
     @"Content-Type": @"application/json",
     @"Cache-Control": @"no-cache",
     @"Postman-Token": @"a9b1b480-ab0e-6e01-d5c7-2313b2747279" };
     NSArray *parameters = @[ @{ @"name": @"driver_id", @"value": @"12" },
     @{ @"name": @"shipping_status", @"value": @"Delivered" },
     @{ @"name": @"order_id", @"value": @"366" },
     @{ @"name": @"driver_comment", @"value": @"dgdfgfdgdgdfg" },
     @{ @"name": @"sig_img", @"fileName": @"/Users/carmatecmac/Downloads/image.png" } ];
     NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
     
     NSError *error;
     NSMutableString *body = [NSMutableString string];
     for (NSDictionary *param in parameters) {
     [body appendFormat:@"--%@\r\n", boundary];
     if (param[@"fileName"]) {
     [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
     [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
     [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
     if (error) {
     NSLog(@"%@", error);
     }
     } else {
     [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
     [body appendFormat:@"%@", param[@"value"]];
     }
     }
     [body appendFormat:@"\r\n--%@--\r\n", boundary];
     NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
     
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dohasooq.carmatec.com/apis/updateOrderDeliveryApi"]
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     timeoutInterval:10.0];
     [request setHTTPMethod:@"POST"];
     [request setAllHTTPHeaderFields:headers];
     [request setHTTPBody:postData];
     
     NSURLSession *session = [NSURLSession sharedSession];
     NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     if (error) {
     NSLog(@"%@", error);
     } else {
     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
     NSLog(@"%@", httpResponse);
     }
     }];
     [dataTask resume];
     */
    
    [Helper_activity Stop_animation:self];
}


#pragma mark - UITableview Datasource Deligate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ARR_orderDetail count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell_order_items *cell = (Cell_order_items *)[tableView dequeueReusableCellWithIdentifier:@"Cell_order_items"];
    if(cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_order_items" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *dict;
    
    @try {
        dict = [ARR_orderDetail objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    
    @try {
        NSDictionary *ProductDescriptions = [dict valueForKey:@"ProductDescriptions"];
        cell.item_name.text = [ProductDescriptions valueForKey:@"title"];
    } @catch (NSException *exception) {
        cell.item_name.text = @"No data";
    }
    
    @try {
        NSDictionary *Orders = [dict valueForKey:@"Orders"];
        cell.order_date.text = [self formatter_DATE1:[Orders valueForKey:@"order_created"]];
    } @catch (NSException *exception) {
        cell.order_date.text = @"No data";
    }
    
    @try {
        NSDictionary *OrderProducts = [dict valueForKey:@"OrderProducts"];
        NSDictionary *Currencies = [dict valueForKey:@"Currencies"];
        cell.quantity.text = [NSString stringWithFormat:@": %@",[OrderProducts valueForKey:@"product_quantity"]];
        
        NSString *STR_totel = [NSString stringWithFormat:@"%.2f",[[OrderProducts valueForKey:@"product_price"] floatValue]];
        
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencySymbol:@""];
        [numberFormatter setMaximumFractionDigits:2];
        NSString *result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[STR_totel floatValue]]];
        
        cell.price.text = [NSString stringWithFormat:@": %@ %@",[Currencies valueForKey:@"currency_symbol_left"],result];
    } @catch (NSException *exception) {
        cell.quantity.text = @"No data";
        cell.price.text = @"No data";
    }
    
    @try {
        NSDictionary *Products = [dict valueForKey:@"Products"];
        NSString *product_image = [Products valueForKey:@"product_image"];
        NSString *merchant_id = [Products valueForKey:@"merchant_id"];
        NSString *URL_STR = [NSString stringWithFormat:@"%@%@%@%@",product_path1,merchant_id,product_path2,product_image];
        [cell.IMG_logo sd_setImageWithURL:[NSURL URLWithString:URL_STR]
                     placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
                              options:SDWebImageRefreshCached];
    } @catch (NSException *exception) {
        NSLog(@"Exception from display product image %@",exception);
    }
    
//    button_compass
    
    return cell;
    
    
}
/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *dict = [orders_arr objectAtIndex:indexPath.row];
    //    NSDictionary *OrderProducts = [dict valueForKey:@"OrderProducts"];
    //    NSDictionary *Orders = [dict valueForKey:@"Orders"];
    //
    //    NSString *STR_lat;
    //    NSString *STR_lon;
    
    
    //    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"key7"] forKey:@"latitude"];
    //    [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"key8"] forKey:@"longitude"];
    //    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"order_data"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSDictionary *dict = [orders_arr objectAtIndex:indexPath.row];
    NSDictionary *Orders = [dict valueForKey:@"Orders"];
    
    [[NSUserDefaults standardUserDefaults] setValue:[Orders valueForKey:@"id"] forKey:@"order_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(order_detail_vw) withObject:nil afterDelay:0.01];
}*/

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 157.0;
//}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 157.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - Date Format methods
-(NSString *)format_Date:(NSString *)STR_date
{
    NSArray *ARR_tmp = [STR_date componentsSeparatedByString:@" "];
    return [ARR_tmp objectAtIndex:0];
}

-(NSString *)formatter_DATE:(NSString *)STR_date
{
    NSArray *TMP_ARR = [STR_date componentsSeparatedByString:@"T"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [dateFormatter dateFromString:[TMP_ARR objectAtIndex:0]];
    NSLog(@"CurrentDate:%@", currentDate);
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"MMM dd, yyyy"];
    return [newFormat stringFromDate:currentDate];
}


//#pragma mark - Assighnvariables
//-(void) update_Values
//{
//    NSDictionary *dict = [json_reponse valueForKey:@"order"];
//    NSDictionary *order = [dict valueForKey:@"order"];
//    NSDictionary *Orders = [order valueForKey:@"Orders"];
//    NSString *order_text = @"ORDER ID:";
//    NSString *order_id;
//    
//    @try {
//        order_id = [Orders valueForKey:@"order_number"];
//    } @catch (NSException *exception) {
//        order_id = @"No data";
//    }
//    
//    NSString *order_STR = [NSString stringWithFormat:@"%@%@",order_text,order_id];
//    
//    if ([self.oreder_ID respondsToSelector:@selector(setAttributedText:)]) {
//        
//        // Define general attributes for the entire text
//        NSDictionary *attribs = @{
//                                  NSForegroundColorAttributeName:self.oreder_ID.textColor,
//                                  NSFontAttributeName: self.oreder_ID.font
//                                  };
//        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:order_STR attributes:attribs];
//        
//        
//        
//        NSRange greenTextRange = [order_STR rangeOfString:order_id];
//        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],  NSFontAttributeName:self.oreder_ID.font}
//                                range:greenTextRange];
//        
//        
//        
//        self.oreder_ID.attributedText = attributedText;
//    }
//    else
//    {
//        self.oreder_ID.text = order_STR;
//    }
//}

-(void) ACTN_complete
{
    char c = '"';
    if (!chosenImage) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please add customer signature" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else if (_IMG_del_status.tag == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please update status to %cDelivered%c",c,c] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else
    {
        NSLog(@"All ok");
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(API_updateORDER) withObject:nil afterDelay:0.01];
    }
    
}

#pragma mark - Google map deligate
-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSString *URL_STR = [NSString stringWithFormat:@"comgooglemaps://?q=%f,%f&oom=14&views=traffic",marker.position.latitude,marker.position.longitude];
//    [[UIApplication sharedApplication] openURL:
//     [NSURL URLWithString:@"comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic"]];
    
    NSLog(@"Selected order datas %@",URL_STR);
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSURL *url = [NSURL URLWithString:URL_STR];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please install google map from itunes" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    return YES;
}

-(NSString *)formatter_DATE1:(NSString *)STR_date
{
    NSArray *TMP_ARR = [STR_date componentsSeparatedByString:@" "];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [dateFormatter dateFromString:[TMP_ARR objectAtIndex:0]];
    NSLog(@"CurrentDate:%@", currentDate);
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"MMM dd, yyyy"];
    return [NSString stringWithFormat:@": %@",[newFormat stringFromDate:currentDate]];
}

@end
