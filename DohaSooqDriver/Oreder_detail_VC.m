//
//  Oreder_detail_VC.m
//  DohaSooqDriver
//
//  Created by Test User on 19/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Oreder_detail_VC.h"
#import <GoogleMaps/GoogleMaps.h>
#import  <CoreLocation/CoreLocation.h>
#import "Helper_activity.h"

@interface Oreder_detail_VC ()<CLLocationManagerDelegate,GMSMapViewDelegate>
{
    GMSMapView *mapView;
    GMSMarker *marker,*marker1;
    GMSMutablePath *path;
    GMSPolyline *polyline;
    GMSCameraPosition *camera;
//    float curlat;
//    float curlang;
    NSString *encodedPath ;
    BOOL firstLocationUpdate_;
    NSMutableArray *detailedSteps;
    

}
@property(nonatomic,retain)IBOutlet  UIView *mapview;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property(nonatomic,retain)IBOutlet UIButton *direction;



@end

@implementation Oreder_detail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUP_VIEW];
}
-(void)setUP_VIEW
{
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
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
    self.navigationItem.title = [@"Order Detail" uppercaseString];
    _direction.layer.borderWidth = 1;
    _direction.layer.borderColor = [UIColor blackColor].CGColor;
    
//    [self mapview_setUP];
    
    _coordinate = [self getLocation];
    [self mapview_setUP];
    
    camera = [GMSCameraPosition cameraWithLatitude:_coordinate.latitude
                                         longitude:_coordinate.longitude zoom:17];
    [mapView animateToCameraPosition:camera];
    
    [mapView animateToCameraPosition:camera];
    
    [self map_polyline];
    
//    TIMER_location = [NSTimer scheduledTimerWithTimeInterval:5.0 target: self selector: @selector(locationChangesHAndle) userInfo: nil repeats: YES];
    
    [Helper_activity Start_animation:self];
    [self performSelector:@selector(API_orderDetail) withObject:nil afterDelay:0.01];
}

-(void) locationChangesHAndle
{
    _coordinate = [self getLocation];
    [self map_polyline];
}

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

-(void)mapview_setUP
{
    mapView.delegate = self;
    
//    [self GetCurrentLocation_WithBlock];
    mapView = [GMSMapView mapWithFrame:_mapview.bounds camera:camera];
    mapView.accessibilityElementsHidden = NO;
    mapView.settings.compassButton = true;
    mapView.settings.myLocationButton = YES;
    
    [self.mapview addSubview:mapView];
    mapView.trafficEnabled = YES;
    
    
    /*[mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];
     */
    
    mapView.myLocationEnabled = YES;
    
    
//     marker = [[GMSMarker alloc]init];
//       camera = [GMSCameraPosition cameraWithLatitude:_coordinate.latitude
//                                         longitude:_coordinate.longitude zoom:10];

 }
- (void)dealloc {
    [super dealloc];
    [mapView removeObserver:self
                 forKeyPath:@"myLocation"
                    context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    if (!firstLocationUpdate_)
    {
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:17];
    }
}

#pragma mark - CLLocationManager
-(void)GetCurrentLocation_WithBlock {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=kCLDistanceFilterNone;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLoc=[locations objectAtIndex:0];
//    _coordinate=currentLoc.coordinate;
    NSString *lat,*lang;
    lat = [NSString stringWithFormat:@"%.4f",_coordinate.latitude];
    lang = [NSString stringWithFormat:@"%.4f",_coordinate.longitude];
    NSLog(@"the string lat & long are:%@,%@",lat,lang);
    marker.position = CLLocationCoordinate2DMake(_coordinate.latitude, _coordinate.longitude);

    marker.tracksViewChanges = NO;
    marker.tappable = YES;
    marker.tracksInfoWindowChanges = YES;
    marker.map = mapView;
    
    if(currentLoc)
    {
    manager.delegate = nil;
    [self map_polyline];
    }
    
    
   }
- (void)locationManager:(CLLocationManager *)manager  didUpdateHeading:(CLHeading *)newHeading
{
    double heading = (- newHeading.trueHeading) * M_PI / 180.0f;
    double headingDegrees = (heading*M_PI/180);
    [mapView animateToViewingAngle:headingDegrees];
    CLLocationDirection trueNorth = [newHeading trueHeading];
    //[mapView animateToBearing:trueNorth];
    marker.rotation = trueNorth;
}

- (void)theActionMethod {
//    [polyline setMap:nil];
//    
//    [mapView clear];
//    
//    [_locationManager startUpdatingHeading];
//    marker.position = CLLocationCoordinate2DMake(_coordinate.latitude, _coordinate.longitude);
//
//    marker.icon = [UIImage imageNamed:@"arrow.png"];
//    marker.map = mapView;
//
//    [_locationManager startUpdatingLocation];
//    
//    
//    mapView.myLocationEnabled = NO;
    
    
    [self mapdirections];
    
}

- (IBAction)button_click:(id)sender {

    GMSCameraPosition  *camera1 = [GMSCameraPosition cameraWithLatitude:_coordinate.latitude longitude:_coordinate.longitude zoom:35];
    mapView.camera = camera1;
    if(camera1.zoom == 35)
    {
        camera1 = [GMSCameraPosition cameraWithLatitude:_coordinate.latitude longitude:_coordinate.longitude zoom:0];
    }
    
    [self theActionMethod];
}


-(void)mapdirections
{
//      [_locationManager startUpdatingLocation];
    
//   if(!_coordinate.latitude)
//   {
//     
//     NSLog(@"the destination lat and long are:%f,%f",_coordinate.latitude,_coordinate.longitude);

       [self map_polyline];
       
//   }
//   else
//   {
//       [self map_polyline];
//   
//   }
}
-(void)map_polyline
{
//    [_locationManager startUpdatingLocation];
    
    float destlat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] floatValue];
    float destlang = [[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] floatValue];
    NSLog(@"the destination lat and long are:%f,%f",destlat,destlang);
    
//    _coordinate.latitude = 47.390607;
//    _coordinate.longitude = -122.286127;
    

    NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&alternateroutes=false&sensor=true",_coordinate.latitude,_coordinate.longitude,destlat,destlang]];
    NSURLResponse *res;
    NSError *err;
    NSData *data=[NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:url] returningResponse:&res error:&err];
    if(data)
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if(dic)
        {
            
            NSString *stattus = [dic valueForKey:@"status"];
            if([stattus isEqualToString:@"ZERO_RESULTS"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"No Route Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else{
                
                [mapView clear];
                
                NSLog(@"The Total dic:%@",dic);
                NSArray *routes=dic[@"routes"];
                NSArray *legs=routes[0][@"legs"];
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
                    polyline.map = mapView;
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

-(void)polylineWithEncodedString:(NSString *)encodedString {
    
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
    marker1.map = mapView;
    [CATransaction commit];
    
    polyline = [GMSPolyline polylineWithPath:path];
    free(coords);
    
}
-(void)showDirection:(NSMutableArray*) latlong        {
    double lat = 0.0,lng = 0.0;
    for(int i=0; i<[latlong count]; i++){
        lat=[latlong[i][@"lat"] doubleValue];
        lng=[latlong[i][@"lng"] doubleValue];
    }
    marker1 = [[GMSMarker alloc]init];
    
    marker1.position = CLLocationCoordinate2DMake(lat, lng);
    marker1.map = mapView;
    
    NSLog(@"Direction path");
//    camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:15];
}

#pragma Button Actions
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
/*-(void) API_orderDetail
 {
 NSString *STR_orderid = [[NSUserDefaults standardUserDefaults] valueForKey:@"order_ID"];
 NSString *STR_driver_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"driver_id"];
 
 NSError *error;
 NSHTTPURLResponse *response = nil;
 
 NSString *post = [NSString stringWithFormat:@"driver_id=%@&order_id=%@",STR_driver_ID,STR_orderid];
 
 NSLog(@"Post contents %@",post);
 
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
 NSLog(@"Oreder_detail_VC.m Api response 1 DriverOrderDetailApi  %@",json_DATA);
 
 }
 else
 {
 NSLog(@"Error %@\nResponse %@",error,response);
 }
 
 [Helper_activity Stop_animation:self];
 
 
 
 
 }*/

#pragma mark - API Integration
-(void) API_orderDetail
{
    NSString *STR_orderid = [[NSUserDefaults standardUserDefaults] valueForKey:@"order_ID"];
   
    NSString *post = [NSString stringWithFormat:@"order_id=%@",STR_orderid];
    
    NSLog(@"Post contents %@",post);
    

    
   NSString *urlGetuser =[NSString stringWithFormat:@"%@DriverOrderListApi",SERVER_URL];

    
    [Helper_activity apiWith_PostString:urlGetuser andParams:post completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [Helper_activity Stop_animation:self];
                NSLog(@"%@",[error localizedDescription]);
            }
            if (data) {
                  [Helper_activity Stop_animation:self];
                NSLog(@"OUT Json Push register %@",data);
                
                
            }
            
        });
        
    }];
   
    
}
@end
