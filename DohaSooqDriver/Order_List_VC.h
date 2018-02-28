//
//  Order_List_VC.h
//  DohaSooqDriver
//
//  Created by Test User on 17/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORderfilterDeligate.h"

@interface Order_List_VC : UIViewController <ORderfilterDeligate>
//@property (nonatomic,retain) IBOutlet UIBarButtonItem *profilebutton;
@property (nonatomic,retain) IBOutlet UIButton *filter_button;
@property (nonatomic,retain) IBOutlet UIImageView *IMG_pp1;
@property (nonatomic,retain) IBOutlet UIView *VW_no_Data;
@end
