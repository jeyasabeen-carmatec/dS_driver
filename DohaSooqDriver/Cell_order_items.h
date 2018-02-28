//
//  Cell_order_items.h
//  DohaSooqDriver
//
//  Created by jeya sabeen on 15/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_order_items : UITableViewCell

@property (nonatomic,retain) IBOutlet  UIImageView *IMG_logo;
@property (nonatomic,retain) IBOutlet  UILabel *item_name;
@property (nonatomic,retain) IBOutlet  UILabel *order_date;
@property (nonatomic,retain) IBOutlet  UILabel *quantity;
@property (nonatomic,retain) IBOutlet  UILabel *price;

@end
