//
//  signature_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 27/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "signature_VC.h"
#import "UviSignatureView.h"
#import "SignatureView.h"
@interface signature_VC ()
@property (nonatomic,weak) IBOutlet UviSignatureView *sign_view;
@end

@implementation signature_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]}];
    self.navigationItem.title = [@"Signature View" uppercaseString];
}
- (IBAction)save_action:(id)sender {
    
    UIGraphicsBeginImageContext(self.sign_view.bounds.size);
    [[self.sign_view.layer presentationLayer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
   // UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
     [self.navigationController popViewControllerAnimated:YES];
   // UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Successfully Saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
   // [alert show];
    UIGraphicsEndImageContext();
    [self.delegate send_IMAGE:viewImage];
   

}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)cancel_action:(id)sender {
    
    [_sign_view erase];
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
