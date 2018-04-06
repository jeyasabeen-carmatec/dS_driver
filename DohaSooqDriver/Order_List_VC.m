//
//  Order_List_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 17/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Order_List_VC.h"
#import "order_list_cell.h"
#import "Order_filter_VC.h"
#import "UITableView+NewCategory.h"
#import "Helper_activity.h"
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@class FrameObservingView;

@protocol FrameObservingViewDelegate <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingView *)view;
@end

@interface FrameObservingView : UIView
@property (nonatomic,assign) id<FrameObservingViewDelegate>delegate;
@end

@implementation FrameObservingView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end

@interface Order_List_VC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CLLocationManagerDelegate,FrameObservingViewDelegate, UITableViewDragLoadDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *orders_arr;
    
    NSMutableDictionary *post_Date;
    NSArray *ARR_order_list;
//    CGRect frame_or;
    long page_count;
    NSIndexPath *buttonIndexPath;
    
    NSString *STR_date_1;
    NSString *STR_staus_1;
}
@property (nonatomic,retain) IBOutlet UITableView *Order_TAB;

@end

@implementation Order_List_VC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    post_Date = [[NSMutableDictionary alloc] init];
    
    NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    [post_Date setValue:driver_ID forKey:@"driver_id"];
    [post_Date setValue:@"10" forKey:@"page_limit"];
    [post_Date setValue:@"1" forKey:@"page_no"];
    [post_Date setValue:@"" forKey:@"filter_order_number"];
    [post_Date setValue:@"" forKey:@"filter_shipping_status"];
    
    _Order_TAB.delegate = self;
    _Order_TAB.dataSource = self;
    [_Order_TAB setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _Order_TAB.showLoadMoreView = YES;
//    frame_or = _Order_TAB.frame;
    
    orders_arr = [[NSMutableArray alloc]init];
    
    _VW_no_Data.center = self.navigationController.view.center;
    _VW_no_Data.hidden = YES;
    
    _IMG_pp1.layer.cornerRadius = _IMG_pp1.frame.size.width / 2;
    _IMG_pp1.layer.masksToBounds = YES;
    
//    _IMG_pp1.hidden = YES;
    
    _Order_TAB.hidden = YES;
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:35.0f]
       } forState:UIControlStateNormal];
    
//
//    UIImageView *IMG_btn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
//    IMG_btn.image = [UIImage imageNamed:@"TOp_logo"];
    UIButton *BTN_refresh = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    [BTN_refresh setImage:[UIImage imageNamed:@"IMG_barBTN1"] forState:UIControlStateNormal];
//    [BTN_refresh addSubview:IMG_btn];
    [BTN_refresh addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:BTN_refresh];
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
        [_filter_button.titleLabel setFont: [_filter_button.titleLabel.font fontWithSize: 17]];
    }
    else if(result.height >= 667)
    {
        [_filter_button.titleLabel setFont: [_filter_button.titleLabel.font fontWithSize: 19]];
    }
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]}];
    self.navigationItem.title = [@"Order List" uppercaseString];
    
    /*[ _profilebutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"FontAwesome" size:25.0], NSFontAttributeName,
                                             [UIColor whiteColor], NSForegroundColorAttributeName,[UIColor blackColor],NSBackgroundColorAttributeName,
                                             nil]
                                   forState:UIControlStateNormal];
    _profilebutton.title =@"";*/
    
//    UIImageView *IMG_VW = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    NSString *img_url = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"profile_pic"]];
    
//    [IMG_VW sd_setImageWithURL:[NSURL URLWithString:img_url]
//                     placeholderImage:[UIImage imageNamed:@"profile_pic"]
//                              options:SDWebImageRefreshCached];
    
    NSData *img_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]];
    UIImage *img_dd = [UIImage imageWithData:img_data];
    
    UIButton *btn_PF = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn_PF addTarget:self action:@selector(BTN_profile) forControlEvents:UIControlEventTouchUpInside];
    [btn_PF setImage:img_dd forState:UIControlStateNormal];
    btn_PF.layer.cornerRadius = 15.0;
    btn_PF.layer.masksToBounds = YES;
    
//    _profilebutton = [[UIBarButtonItem alloc] initWithCustomView:IMG_VW];
    
    UIBarButtonItem *profilebutton = [[UIBarButtonItem alloc] initWithCustomView:btn_PF];
    
    self.navigationItem.rightBarButtonItem = profilebutton;
    
    //_filter_button.title =@"";
    _filter_button.hidden = NO;
    
    NSDictionary *DICTN_notification = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"notification_DICT"];
    if (DICTN_notification) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notification_DICT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(API_get_orerList) withObject:nil afterDelay:0.01];
        [_Order_TAB reloadData];
    }
    else
    {
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(API_get_orerList) withObject:nil afterDelay:0.01];
        [_Order_TAB reloadData];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    
    NSString *img_url = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"profile_pic"]];
    
    //    [IMG_VW sd_setImageWithURL:[NSURL URLWithString:img_url]
    //                     placeholderImage:[UIImage imageNamed:@"profile_pic"]
    //                              options:SDWebImageRefreshCached];
    
    NSData *img_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]];
    UIImage *img_dd = [UIImage imageWithData:img_data];
    
    if (!img_dd) {
        img_dd = [UIImage imageNamed:@"profile_pic"];
    }
    
    UIButton *btn_PF = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn_PF addTarget:self action:@selector(BTN_profile) forControlEvents:UIControlEventTouchUpInside];
    [btn_PF setImage:img_dd forState:UIControlStateNormal];
    btn_PF.layer.cornerRadius = 15.0;
    btn_PF.layer.masksToBounds = YES;
    
    //    _profilebutton = [[UIBarButtonItem alloc] initWithCustomView:IMG_VW];
    
    UIBarButtonItem *profilebutton = [[UIBarButtonItem alloc] initWithCustomView:btn_PF];
    
    self.navigationItem.rightBarButtonItem = profilebutton;
    
   /* NSDictionary *DICTN_notification = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"notification_DICT"];
    if (DICTN_notification) {
        NSDictionary *aps = [DICTN_notification valueForKey:@"aps"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notification_DICT"];
        [[NSUserDefaults standardUserDefaults] setValue:[aps valueForKey:@"order_id"] forKey:@"order_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(order_detail_vw) withObject:nil afterDelay:0.01];
    }*/
    
//    [self setup_VIEW];
    
    /*CGRect frame_tbl = _Order_TAB.frame;
    frame_tbl.size.height = [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20);
    _Order_TAB.frame = frame_tbl;*/
    
//    _filter_button.hidden = YES;
    
    /*if ([orders_arr count] == 0) {
     
    }*/
}
/*
-(void)setup_VIEW
{
    NSDictionary *temp_dictin;
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567891",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Delivered",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"9866852369",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"8500314596",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"17-06-2017",@"key1",@"25-06-2017",@"key2",@"David Smith",@"key3",@"703 B Street, Malaysillle",@"key4",@"#0958954623",@"key5",@"Pending",@"key6",@"12.9519",@"key7",@"77.6990",@"key8",@"1234567892",@"key9",nil];
    [orders_arr addObject:temp_dictin];
}*/


#pragma Table_VIEW delegate Mehods
#pragma mark - UItableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orders_arr.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    order_list_cell *cell = (order_list_cell *)[tableView dequeueReusableCellWithIdentifier:@"order_list_cell"];
    if(cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"order_list_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.location.layer.borderWidth = 1.0f;
    cell.location.layer.borderColor = [UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0].CGColor;
    cell.phone.layer.borderWidth = 1.0f;
    cell.phone.layer.borderColor = [UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0].CGColor;
    
    
    NSDictionary *dict = [orders_arr objectAtIndex:indexPath.row];
    NSDictionary *Orders = [dict valueForKey:@"Orders"];
    
    NSString *assgned_date_text = [NSString stringWithFormat:@"Assigned Date :"];
    NSString *assigend_date = [NSString stringWithFormat:@"%@",[self formatter_DATE:[dict valueForKey:@"assigned_date"]]];
    assigend_date = [assigend_date stringByReplacingOccurrencesOfString:@"(null)" withString:@"NA"];
//    NSString *delivery_date_text = [NSString stringWithFormat:@"Delivery Date :"];
   // NSString *delivery_date;// = [NSString stringWithFormat:@"%@",[self formatter_DATE:[dict valueForKey:@"assigned_date"]]];
 //   delivery_date = @"NA";//[delivery_date stringByReplacingOccurrencesOfString:@"(null)" withString:];

    NSString *text = [NSString stringWithFormat:@"%@ %@",assgned_date_text,assigend_date];
  //  NSString *delivery_text = [NSString stringWithFormat:@"%@ %@",delivery_date_text,delivery_date];

    
    if ([cell.Assigned_Date_text respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:cell.Assigned_Date_text.textColor,
                                  NSFontAttributeName: cell.Assigned_Date_text.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        

        NSRange greenTextRange = [text rangeOfString:assigend_date];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0] ,  NSFontAttributeName:cell.order_ID.font}
                                range:greenTextRange];
        
        
        
        cell.Assigned_Date_text.attributedText = attributedText;
    }
    else
    {
        cell.Assigned_Date_text.text = text;
    }
  
    /*if ([cell.Deliver_date_text respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribsd = @{
                                  NSForegroundColorAttributeName:cell.Deliver_date_text.textColor,
                                  NSFontAttributeName: cell.Deliver_date_text.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:delivery_text attributes:attribsd];
        
       // UIFont *unboldFont = [UIFont fontWithName:@"Roboto-Medium" size:14];
        NSRange greenTextRange = [delivery_text rangeOfString:delivery_date];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0],NSFontAttributeName:cell.order_ID.font}range:greenTextRange];
                cell.Deliver_date_text.attributedText = attributedText;
    }
    else
    {
        cell.Deliver_date_text.text = delivery_text;
    }*/
    
    cell.Deliver_date_text.hidden = YES;

    NSString *STR_customer_name;
    @try {
        STR_customer_name = [NSString stringWithFormat:@"%@ %@",[Orders valueForKey:@"shipping_firstname"],[Orders valueForKey:@"shipping_lastname"]];
    } @catch (NSException *exception) {
        STR_customer_name = @"";
    }
    
    cell.customer_name.text = [STR_customer_name uppercaseString];
    
    NSString *STR_customer_address;
    @try {
        STR_customer_address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",[Orders valueForKey:@"shipping_address1"],[Orders valueForKey:@"shipping_address2"],[Orders valueForKey:@"shipping_city"],[Orders valueForKey:@"shipping_state"],[Orders valueForKey:@"shipping_country"],[Orders valueForKey:@"shipping_zip_code"]];
    } @catch (NSException *exception) {
        STR_customer_address = @"";
    }
    
    STR_customer_address = [STR_customer_address stringByReplacingOccurrencesOfString:@", ," withString:@", "];
    
    cell.customer_address.text = STR_customer_address;
    
    NSString *STR_order_id;
    @try {
        STR_order_id = [NSString stringWithFormat:@"#%@",[Orders valueForKey:@"order_number"]];
    } @catch (NSException *exception) {
        STR_order_id = @"";
    }
    STR_order_id = [STR_order_id stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
    
    
    cell.order_ID.text = STR_order_id;
    
    NSString *STR_delivery_slot;
    NSString *STR_print_delivery;
    
    @try {
        STR_delivery_slot = [Orders valueForKey:@"delivery_slot"];
    } @catch (NSException *exception) {
        STR_delivery_slot = @"Not Mentioned";
    }
    
    
    if ([STR_delivery_slot isEqualToString:@"No Delivery slot Choosen"]) {
        cell.delivery_slot.text = @" ";
        cell.delivery_slot.font = [cell.delivery_slot.font fontWithSize:0];
    }
    else
    {
        STR_print_delivery = [NSString stringWithFormat:@"Delivery Slot : %@",STR_delivery_slot];
        
        if ([cell.delivery_slot respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribsd = @{
                                       NSForegroundColorAttributeName:cell.Deliver_date_text.textColor,
                                       NSFontAttributeName: cell.Deliver_date_text.font
                                       };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:STR_print_delivery attributes:attribsd];
            
            // UIFont *unboldFont = [UIFont fontWithName:@"Roboto-Medium" size:14];
            NSRange greenTextRange = [STR_print_delivery rangeOfString:STR_delivery_slot];
            [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.33 blue:0.62 alpha:1.0],NSFontAttributeName:cell.order_ID.font}range:greenTextRange];
            cell.delivery_slot.attributedText = attributedText;
        }
        else
        {
            cell.delivery_slot.text = STR_print_delivery;
        }
    }
    
    NSString *STR_order_STAT;
    @try {
        STR_order_STAT = [dict valueForKey:@"shipping_status"];
    } @catch (NSException *exception) {
        STR_order_STAT = @"";
    }
//    if (STR_order_STAT.length == 0) {
//        STR_order_STAT = @"";
//    }
    
    
    if ([STR_order_STAT isEqualToString:@"Pending"]) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
    
//        cell.LBL_pickUP.font = [cell.LBL_pickUP.font fontWithSize:17];
        [cell.LBL_pickUP addGestureRecognizer:tapGestureRecognizer];
        [cell.LBL_pickUP setTag:indexPath.row];
        cell.LBL_pickUP.userInteractionEnabled = YES;
        cell.LBL_pickUP.text = @" PICK UP ORDER";
    }
    else
    {
        cell.LBL_pickUP.text = @"";
//        cell.LBL_pickUP.font = [cell.LBL_pickUP.font fontWithSize:0];
    }
    
    cell.order_status.text = [STR_order_STAT uppercaseString];
    
  /*  if (indexPath.row == 1) {
//        cell.BTN_pickup.hidden = YES;
//        CGRect frame_pickUP = cell.LBL_pickUP.frame;
//        frame_pickUP.size.height = 0.0f;
//        cell.LBL_pickUP.frame = frame_pickUP;
//        [cell.BTN_pickup setTitle:@"" forState:UIControlStateNormal];
        cell.LBL_pickUP.text = @"";
    }
    else
    {
//        CGRect frame_pickUP = cell.LBL_pickUP.frame;
//        frame_pickUP.origin.x = 0;
//        frame_pickUP.origin.y = 0;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        
        [cell.LBL_pickUP addGestureRecognizer:tapGestureRecognizer];
        [cell.LBL_pickUP setTag:indexPath.row];
        cell.LBL_pickUP.userInteractionEnabled = YES;
        cell.LBL_pickUP.text = @" PICK UP ORDER"; //
//        [cell.BTN_pickup setTitle:@"PICK UP ORDER" forState:UIControlStateNormal];
//        [cell.BTN_pickup addTarget:self action:@selector(ACTN_Pickup:) forControlEvents:UIControlEventTouchUpInside];
    }*/
    
    cell.location.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.phone.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [cell.phone addTarget:self action:@selector(mobile_dial:) forControlEvents:UIControlEventTouchUpInside];
    [cell.location addTarget:self action:@selector(location_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.location setTag:indexPath.row];
    [cell.phone setTag:indexPath.row];
    
    return cell;

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
//    NSDictionary *Orders = [dict valueForKey:@"Orders"];
    
    @try {
        if ([[dict valueForKey:@"shipping_status"] isEqualToString:@"Pending"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please pick the order" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"id"] forKey:@"order_ID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [Helper_activity Start_animation:self];
            [self performSelector:@selector(order_detail_vw) withObject:nil afterDelay:0.01];
        }
    } @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

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

#pragma mark - Uitableview BUTTON
-(void)ACTN_Pickup : (UIButton *) sender
{
    NSIndexPath *buttonIndexPathsdsd = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//    NSString *index_str = [NSString stringWithFormat:@"%ld",(long)buttonIndexPath.row];
//    
    NSLog(@"The selected index = %@",buttonIndexPathsdsd);
}

-(void) labelTapped : (UIGestureRecognizer *) sender //
{
    NSIndexPath *buttonIndexPath11 = [NSIndexPath indexPathForRow:sender.view.tag inSection:0];
    buttonIndexPath = buttonIndexPath11;
    order_list_cell *cell = (order_list_cell *)[_Order_TAB cellForRowAtIndexPath:buttonIndexPath11];
    cell.LBL_pickUP.text = @" PICK UP ORDER";
    [Helper_activity Stop_animation:self];
    [self performSelector:@selector(API_updatePICKUP) withObject:nil afterDelay:0.01];
}


-(void) API_updatePICKUP
{
    NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    NSDictionary *dict = [orders_arr objectAtIndex:buttonIndexPath.row];
//    NSDictionary *Orders = [dict valueForKey:@"Orders"];
    NSString *STR_orderid = [dict valueForKey:@"id"];
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *post = [NSString stringWithFormat:@"driver_id=%@&shipment_id=%@&shipping_status=Dispatched",driver_ID,STR_orderid];
    
    NSLog(@"Post contents %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@updateOrderDispatchedStatus",SERVER_URL];
    
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
        [Helper_activity Stop_animation:self];
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Order Update pickup %@",json_DATA);
        
        if ([[json_DATA valueForKey:@"status"]isEqualToString:@"success"]) {
            orders_arr = [[NSMutableArray alloc]init];
            NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
            [post_Date setValue:driver_ID forKey:@"driver_id"];
            [post_Date setValue:@"10" forKey:@"page_limit"];
            [post_Date setValue:@"1" forKey:@"page_no"];
            [post_Date setValue:@"" forKey:@"filter_order_number"];
            [post_Date setValue:@"" forKey:@"filter_shipping_status"];
            [Helper_activity Start_animation:self];
            [self performSelector:@selector(API_get_orerList) withObject:nil afterDelay:0.01];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    else
    {
        [Helper_activity Stop_animation:self];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

#pragma mark - UIButton

-(void)order_detail_vw
{
    [Helper_activity Stop_animation:self];
    [self performSegueWithIdentifier:@"order_Detail_VC" sender:self];
}
-(void)backAction
{
    _VW_no_Data.hidden = YES;
    _Order_TAB.hidden = YES;
    
    orders_arr = [[NSMutableArray alloc] init];
    ARR_order_list = [[NSArray alloc] init];
    
    NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    [post_Date setValue:driver_ID forKey:@"driver_id"];
    [post_Date setValue:@"10" forKey:@"page_limit"];
    [post_Date setValue:@"1" forKey:@"page_no"];
    [post_Date setValue:@"" forKey:@"filter_order_number"];
    [post_Date setValue:@"" forKey:@"filter_shipping_status"];
    
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(API_get_orerList) withObject:nil afterDelay:0.01];
    [_Order_TAB reloadData];
//    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)BTN_profile
{
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(Profile_page_nav) withObject:nil afterDelay:0.01];
}
- (IBAction)filter_tapped:(id)sender
{
    [Helper_activity Stop_animation:self];
    [self performSelector:@selector(oredr_filter) withObject:nil afterDelay:0.01];
}
-(void)oredr_filter
{
    Order_filter_VC *filter_VC = [self.storyboard instantiateViewControllerWithIdentifier:@"filter_VC"];
    filter_VC.delegate = self;
    filter_VC.STR_status = STR_staus_1;
    filter_VC.STR_date = STR_date_1;
    [self presentViewController:filter_VC animated:YES completion:nil];
   // [self performSegueWithIdentifier:@"order_filter" sender:self];
}
-(void)Profile_page_nav
{
    [self performSegueWithIdentifier:@"order_profile" sender:self];
    [Helper_activity Stop_animation:self];
}


-(void)mobile_dial:(UIButton *)sender
{
    NSIndexPath *buttonIndexPath1 = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"From Delete Skill %ld",(long)buttonIndexPath1.row);
    NSString *index_str = [NSString stringWithFormat:@"%ld",(long)buttonIndexPath1.row];
    NSLog(@"Index path of Upcomming Event %@",index_str);
    NSLog(@"thedata:%@",[orders_arr objectAtIndex:[index_str intValue]]);
    NSDictionary *dictdat =[orders_arr objectAtIndex:[index_str intValue]];
    NSString *Orders = [dictdat valueForKey:@"Orders"];
    NSString *phone_number;
    @try {
        phone_number = [Orders valueForKey:@"shipping_mobile"];
    } @catch (NSException *exception) {
        NSLog(@"No phone number available %@",exception);
    }
    
    if (phone_number) {
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phone_number]];
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Phone number not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}
-(void)location_clicked:(UIButton *)sender
{
    buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Acess denighed" message:@"Please enable location services to proceed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
    else{
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 100.0;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
    
    
   /* */
    
//    [[NSUserDefaults standardUserDefaults] setValue:[dictdat1 valueForKey:@"key7"] forKey:@"latitude"];
//    [[NSUserDefaults standardUserDefaults] setValue:[dictdat1 valueForKey:@"key8"] forKey:@"longitude"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [Helper_activity Start_animation:self];
//    [self performSelector:@selector(location_page) withObject:nil afterDelay:0.01];
}

#pragma mark - Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
//    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    
    CLLocation *LOC_current = newLocation;
//    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:@"lat_STR"];
//    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:@"long_STR"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    manager.delegate = nil;
    
    NSLog(@"From Delete Skill %ld",(long)buttonIndexPath.row);
    NSString *index_str = [NSString stringWithFormat:@"%ld",(long)buttonIndexPath.row];
    NSLog(@"Index path of Upcomming Event %@",index_str);
    NSLog(@"thedata:%@",[orders_arr objectAtIndex:[index_str intValue]]);
    NSDictionary *dictdat1 = [orders_arr objectAtIndex:[index_str intValue]];
    NSDictionary *Orders = [dictdat1 valueForKey:@"Orders"];
    
    @try {
        NSString *STR_ship_LAT = [Orders valueForKey:@"shipping_latitude"];
        NSString *STR_ship_LON = [Orders valueForKey:@"shipping_longitude"];
        
        NSString *URL_STR = [NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&q=%f,%f",LOC_current.coordinate.latitude,LOC_current.coordinate.longitude, [STR_ship_LAT floatValue],[STR_ship_LON floatValue]];
        
        NSLog(@"Selected order datas %@",dictdat1);
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            NSURL *url = [NSURL URLWithString:URL_STR];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please install google map from itunes" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception from location %@",exception);
      /*  NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14&views=traffic",LOC_current.coordinate.latitude,LOC_current.coordinate.longitude];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:urlString]];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please install google map from itunes" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        } */
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Destination location not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

-(void)location_page
{
    [self performSegueWithIdentifier:@"order_to_orderDetail" sender:self];
    [Helper_activity Stop_animation:self];
}


#pragma mark - UIScrollview Deligate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*NSString *direction = ([scrollView.panGestureRecognizer translationInView:scrollView.superview].y >0)?@"up":@"down";
    if([direction isEqualToString:@"up"])
    {
        if (_filter_button.hidden == NO) {
//            CGRect frame_tbl = _Order_TAB.frame;
//            frame_tbl.size.height = _Order_TAB.frame.size.height + _filter_button.frame.size.height;
            _Order_TAB.frame = frame_or;
            
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFade;
            animation.duration = 0.4;
            [_filter_button.layer addAnimation:animation forKey:nil];
            _filter_button.hidden = YES;
        }
    }
    else if([direction isEqualToString:@"down"])
    {
        if (_filter_button.hidden == YES) {
            CGRect frame_tbl = frame_or;
            frame_tbl.size.height = frame_or.size.height - _filter_button.frame.size.height - _filter_button.frame.size.height - 20;
            _Order_TAB.frame = frame_tbl;
            
            _filter_button.hidden = NO;
        }
    }
    //NSLog(@"%@",direction);*/
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

-(void)dealloc
{
    [super dealloc];
   // [orders_arr release];
}

#pragma mark - API Calling
-(void) API_get_orerList
{
    NSString *driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
    
    NSLog(@"Post contents %@",post_Date);
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    //    NSDictionary *parameters = @{ @"driver_id":driver_ID,@"old_pwd":original_PWD,@"new_pwd":Confirm_new_pwd};
    
    NSString *post = [NSString stringWithFormat:@"driver_id=%@&page_limit=%@&page_no=%@&filter_shipping_status=%@&filter_delivery_date=%@",driver_ID,[post_Date valueForKey:@"page_limit"],[post_Date valueForKey:@"page_no"],[post_Date valueForKey:@"filter_shipping_status"],[post_Date valueForKey:@"filter_order_number"]];
    
    NSLog(@"Post contents %@",post);
    
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@DriverOrderListApi",SERVER_URL];
    
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
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Order list %@",json_DATA);
        ARR_order_list = [json_DATA valueForKey:@"order_list"];
        
        page_count = [[json_DATA valueForKey:@"total_page_cnt"] longValue];
        
        if ([ARR_order_list count] > 0) {
//            [anotherButton setEnabled:NO];
//            [anotherButton setTintColor: [UIColor clearColor]];
            
            _VW_no_Data.hidden = YES;
            _Order_TAB.hidden = NO;
            
            [orders_arr addObjectsFromArray:ARR_order_list];
            [_Order_TAB reloadData];
        }
        else
        {
            _VW_no_Data.hidden = NO;
            _Order_TAB.hidden = YES;
        }
    }
    else
    {
        NSLog(@"Error %@\nResponse %@",error,response);
    }
    [Helper_activity Stop_animation:self];
}

#pragma mark - Control datasource
- (void)finishRefresh
{
    [_Order_TAB finishRefresh];
    [Helper_activity Stop_animation:self];
}

- (void)finishLoadMore
{
    [_Order_TAB finishLoadMore];
    [Helper_activity Stop_animation:self];
}

#pragma mark - Drag delegate methods
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //Pull up go to First Page
    NSLog(@"Insert code to first page");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You are in 1st page" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:1.0];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //Pull up go to NextPage
    NSLog(@"Insert code to next page");
    if (page_count > [orders_arr count]) {
        NSString *STR_pg = [NSString stringWithFormat:@"%@",[post_Date valueForKey:@"page_no"]];
        long cur_pg = [STR_pg longLongValue];
        cur_pg = cur_pg + 1;
        [post_Date setValue:[NSString stringWithFormat:@"%ld",cur_pg] forKey:@"page_no"];
        
        [Helper_activity Start_animation:self];
        [self performSelector:@selector(API_get_orerList) withObject:nil afterDelay:0.01];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Last page" message:@"You are in last page" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:1.0];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

#pragma mark - Orderfilter Deligate
-(void)GET_filter_content:(NSString *)STR_orderID get_Status:(NSString *)STR_status
{
    STR_date_1 = STR_orderID;
    STR_staus_1 = STR_status;
    orders_arr = [[NSMutableArray alloc] init];
    ARR_order_list = [[NSArray alloc] init];
    [post_Date setValue:STR_orderID forKey:@"filter_order_number"];
    [post_Date setValue:STR_status forKey:@"filter_shipping_status"];
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(API_get_orerList) withObject:nil afterDelay:0.01];
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

@end
