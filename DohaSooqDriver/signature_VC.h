//
//  signature_VC.h
//  DohaSooqDriver
//
//  Created by Test User on 27/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol image_delgate<NSObject>
-(void)send_IMAGE:(UIImage *)resimage;
@end
@interface signature_VC : UIViewController
@property(nonatomic,assign) id<image_delgate> delegate;

@end
