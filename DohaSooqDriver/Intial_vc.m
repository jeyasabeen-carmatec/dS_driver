//
//  Intial_vc.m
//  DohaSooqDriver
//
//  Created by Test User on 12/07/17.
//  Copyright © 2017 Test User. All rights reserved.

//

#import "Intial_vc.h"

@interface Intial_vc ()
{
    NSTimer  *spinTimer;
}
@property (nonatomic,retain) IBOutlet UIImageView *launch_img;

@end

@implementation Intial_vc

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [UIView animateWithDuration:2.0 animations:^(void) {
        _launch_img.alpha = 0;
        _launch_img.alpha = 1;
    }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:2.0 animations:^(void) {
                             
                             _launch_img.alpha = 1;
                             [self performSegueWithIdentifier:@"launch_to_login" sender:self];
                             
                         }];
                     }];

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

@end
