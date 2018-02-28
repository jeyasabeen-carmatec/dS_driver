//
//  Order_filter_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 19/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Order_filter_VC.h"
#import "Helper_activity.h"

@interface Order_filter_VC ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property(nonatomic,strong) NSMutableArray *status_arr;
@end

@implementation Order_filter_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUP_VIEW];
}
-(void)setUP_VIEW
{
    
    _status_picker = [[UIPickerView alloc] init];
    _TXT_order_ID.layer.borderWidth = 0.8f;
    _TXT_order_ID.layer.borderColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.0].CGColor;
    _TXT_status.layer.borderWidth = 0.8f;
    _TXT_status.layer.borderColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.0].CGColor;

    _status_picker.delegate = self;
    _status_picker.dataSource = self;
    
//    _PICK_date.hidden = YES;
    
    UIToolbar * Tool_close_picker = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 50)];
    Tool_close_picker.barStyle = UIBarStyleBlackTranslucent;
    [Tool_close_picker sizeToFit];
    
    UIButton *close1 = [[UIButton alloc]init];
    close1.frame=CGRectMake(Tool_close_picker.frame.size.width - 100, 0, 100, Tool_close_picker.frame.size.height);
    [close1 setTitle:@"Done" forState:UIControlStateNormal];
    [close1 addTarget:self action:@selector(datecloseClick) forControlEvents:UIControlEventTouchUpInside];
    [Tool_close_picker addSubview:close1];
    
    _PICK_date   = [[UIDatePicker alloc] init]; //initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height - 200, self.navigationController.view.frame.size.width, 200)];
    _PICK_date.datePickerMode = UIDatePickerModeDate;
//    [_PICK_date setMinimumDate: [NSDate date]];
    //    [picker1 setDatePickerMode:UIDatePickerModeDate];
    //    picker1.backgroundColor = [UIColor whiteColor];
    //    [picker1 addTarget:self action:@selector(startDateSelected:) forControlEvents:UIControlEventValueChanged];
    
    _TXT_order_ID.inputAccessoryView = Tool_close_picker;
    _TXT_order_ID.inputView = _PICK_date;
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_status_picker addGestureRecognizer:tapToSelect];
    
    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [close setTitle:@"Done" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(statuscloseClick) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:close];
    _TXT_status.inputAccessoryView=conutry_close;
   _TXT_status.inputView = _status_picker;
    
    _status_arr = [NSMutableArray arrayWithObjects:@"Pending",@"Dispatched", nil];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height >= 480)
    {
        
        [_BTN_submit.titleLabel setFont: [_BTN_submit.titleLabel.font fontWithSize: 17]];
    }
    else if(result.height >= 667)
    {
        
        [_BTN_submit.titleLabel setFont: [_BTN_submit.titleLabel.font fontWithSize: 19]];
        
    }
    
    if (_STR_status) {
        _TXT_status.text = _STR_status;
    }
    
    if (_STR_date) {
        _TXT_order_ID.text = _STR_date;
    }
}
-(void)startDateSelected:(UIDatePicker *)PIC_dddd
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _TXT_status) {
        _TXT_status.text = [self.status_arr objectAtIndex:0];
    }
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.status_arr count];
}
#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
       return self.status_arr[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.TXT_status.text = self.status_arr[row];
    NSLog(@"the text is:%@",_TXT_status.text);
        
}

#pragma Button Actions

-(void)statuscloseClick
{
    [_TXT_status resignFirstResponder];
}
-(void)datecloseClick
{
//    _TXT_order_ID.text = _PICK_date.date;
    NSString *STR_date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYY-MM-dd"];
    STR_date = [df stringFromDate:_PICK_date.date];
    _TXT_order_ID.text = STR_date;
    
    [_TXT_order_ID resignFirstResponder];
//    _PICK_date.hidden = YES;
}
- (IBAction)close_clikced:(id)sender
{
    if (!_STR_date) {
        _STR_date = @"";
    }
    if (!_STR_status) {
        _STR_status = @"";
    }
    
    [_TXT_status resignFirstResponder];
    if(_delegate && [_delegate respondsToSelector:@selector(GET_filter_content:get_Status:)])
    {
        [_delegate GET_filter_content:_STR_date get_Status:_STR_status];
        [Helper_activity Start_animation:self];
    }
    [self performSelector:@selector(dismiss_VC) withObject:nil afterDelay:0.01];
}

-(void) dismiss_VC
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [Helper_activity Stop_animation:self];
}

- (IBAction)clear_ation:(id)sender
{
    _TXT_status.text = @"";
    _TXT_order_ID.text = @"";
    
    _STR_date = @"";
    _STR_status = @"";
}
- (IBAction)submit_action:(id)sender
{
//    if (!_STR_date) {
        _STR_date =  _TXT_order_ID.text;
//    }
//    if (!_STR_status) {
        _STR_status = _TXT_status.text;
//    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(GET_filter_content:get_Status:)])
    {
//        NSString *STR_orderid,*STR_status;
//        STR_orderid = _TXT_order_ID.text;
//        STR_status = _TXT_status.text;
        [_delegate GET_filter_content:_STR_date get_Status:_STR_status];
    }
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(dismiss_VC) withObject:nil afterDelay:0.01];
}
- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_status_picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_status_picker.bounds, 0.0, (CGRectGetHeight(_status_picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_status_picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_status_picker selectedRowInComponent:0];
            [self pickerView:_status_picker didSelectRow:selectedRow inComponent:0];
        }
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}
#pragma textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_TXT_order_ID resignFirstResponder];
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

@end
