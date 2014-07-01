//
//  DisplayViewController.m
//  iBeaconCollection
//
//  Created by Apple on 14-6-11.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import "DisplayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MAConfirmButton.h"
#import "MenuViewController.h"
#import "ASIFormDataRequest.h"
#import "UrlClass.h"
#import "XYAlertViewHeader.h"
#import "ASIProgressDelegate.h"



@interface DisplayViewController ()
@property(nonatomic,strong) MPMoviePlayerViewController *moviePlayer;
@end

@implementation DisplayViewController
@synthesize fileName;
@synthesize moviePlayer;
@synthesize points = _points;
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize locationManager = _locationManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = nil;
    //filePath =[NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, fileName];
    filePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    NSLog(@"%@",filePath);
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (fileExists){
        NSLog(@"exist!");
    }else{
        NSLog(@"no exist!");
    }
   moviePlayer=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filePath]];


//    [moviePlayer.view setFrame:self.view.frame];
    [moviePlayer.view setFrame:CGRectMake(0,18,320,250)];
    [self.view addSubview:moviePlayer.view];
    moviePlayer.moviePlayer.controlStyle=MPMovieControlStyleDefault;
//    moviePlayer.moviePlayer.movieSourceType= MPMovieSourceTypeStreaming;
    moviePlayer.moviePlayer.fullscreen = NO;
    moviePlayer.moviePlayer.repeatMode = NO;
    [moviePlayer.moviePlayer prepareToPlay];
    [moviePlayer.moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMovie:) name:MPMoviePlayerLoadStateDidChangeNotification object:moviePlayer.moviePlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayerDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:moviePlayer.moviePlayer];
    
    // setup map view
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 268, 320, 250)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [self.view addSubview:self.mapView];

    
    // configure location manager
    // [self configureLocationManager];
    
    [self configureRoutes];
    
    
    MAConfirmButton *uploadButton=[MAConfirmButton buttonWithTitle:@"Upload" confirm:@"OK?"];
    [uploadButton addTarget:self action:@selector(uploadVideo) forControlEvents:UIControlEventTouchUpInside];
    [uploadButton setTintColor:[UIColor colorWithRed:0.176 green:0.569 blue:0.820 alpha:1]];
    [uploadButton setAnchor:CGPointMake(140, 530)];
    [self.view addSubview:uploadButton];
    
    
    MAConfirmButton *exitButton=[MAConfirmButton buttonWithTitle:@"Exit" confirm:@"OK?"];
    [exitButton addTarget:self action:@selector(exitVideo) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTintColor:[UIColor colorWithRed:0.694 green:0.184 blue:0.196 alpha:1]];
    [exitButton setAnchor:CGPointMake(250, 530)];
    [self.view addSubview:exitButton];
}

-(void)exitVideo{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        NSLog(@"Path: %@", [paths objectAtIndex:0]);
        
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Remove Documents directory and all the files
        BOOL deleted = [fileManager removeItemAtPath:[paths objectAtIndex:0] error:&error];
        
        if (deleted != YES || error != nil)
        {
            // Deal with the error...
        }
        
    }
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    MenuViewController *viewController = navigationController.viewControllers[0];
    [self presentViewController:navigationController animated:YES completion:nil];

}



//-(void)removeVideo{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString* filename=[NSString stringWithFormat:@"%@.mp4",fileName];
//    NSString* arffName=[NSString stringWithFormat:@"%@.arff",fileName];
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
//    NSString *arffFilePath = [documentsPath stringByAppendingPathComponent:arffName];
//    NSError *error;
//    [fileManager removeItemAtPath:filePath error:&error];
//    [fileManager removeItemAtPath:arffFilePath error:&error];
//}

-(void)uploadVideo{

    
    NSString* floorPlanId=[[UrlClass sharedManager] floorPlan];
    NSString *routeNameId=[[UrlClass sharedManager] currentRouteName];
    NSArray* foo = [routeNameId componentsSeparatedByString: @" ~ "];
    NSString* srcString = [foo objectAtIndex: 0];
    NSString* src=[srcString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString* dstString=[foo objectAtIndex:1];
    NSString* dst=[dstString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSLog(@"/n%@/n",dst);
    NSString *urlString=[[[[[[NSString stringWithFormat:@"http://inav.zii.io/inav/%@",floorPlanId] stringByAppendingString:@"/"]stringByAppendingString:src]stringByAppendingString:@"/"] stringByAppendingString:dst] stringByAppendingString:@"/video"] ;
    NSURL *dataUrl=[[NSURL alloc] initWithString:urlString];
    NSLog(@"website---%@/n",urlString);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = nil;
    filePath =[NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, fileName];
    filePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    NSString *textFile=nil;
    textFile=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
    
    //PROGRESS

    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:dataUrl];
    [request setDelegate:self];
    [request setUploadProgressDelegate:self];
    [request setFile:filePath forKey:@"videoFile" ];
    [request setFile:textFile forKey:@"timeFile"];
    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setTimeOutSeconds:500];
    [request setShowAccurateProgress:YES];
    [request startAsynchronous];

}

-(void)showProgress
{
    if (!aMBProgressHUD)
        aMBProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:aMBProgressHUD];
    aMBProgressHUD.mode=MBProgressHUDModeDeterminateHorizontalBar;
    aMBProgressHUD.labelText = @"Uploading Video";
    [aMBProgressHUD show:YES];
    [aMBProgressHUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

-(void)hideProgress
{
    [aMBProgressHUD hide:YES];
    [aMBProgressHUD removeFromSuperview];
    aMBProgressHUD=nil;
}

- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		aMBProgressHUD.progress = progress;
		usleep(50000);
	}
}


- (void)requestStarted:(ASIHTTPRequest *)theRequest {
    NSLog(@"response started new::%@",[theRequest responseString]);
    [self showProgress];
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideProgress];
    NSLog(@"Error %@", [request error]);
    if ([request error]) {
        
        XYShowAlert(@"Upload file fails");
        return;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [self hideProgress];
    NSLog(@"%@",responseString);
    XYShowAlert(@"Upload file succeeds");
   
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.mapView = nil;
	self.routeLine = nil;
	self.routeLineView = nil;
}

- (void)playMovie:(NSNotification *)notification {
    MPMoviePlayerController *player = notification.object;
    if (player.loadState & MPMovieLoadStatePlayable)
    {
        NSLog(@"Movie is Ready to Play");
        [player play];
    }
}

- (void)moviePlayerDidFinish:(NSNotification *)note
{
    if (note.object == moviePlayer) {
        NSInteger reason = [[note.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        if (reason == MPMovieFinishReasonPlaybackEnded)
        {
            [moviePlayer.moviePlayer play];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)configureRoutes
{
    // define minimum, maximum points
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
	
	// create a c array of points.
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
    
	// for(int idx = 0; idx < pointStrings.count; idx++)
    for(int idx = 0; idx < _points.count; idx++)
	{
        CLLocation *location = [_points objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
		CLLocationDegrees longitude = location.coordinate.longitude;
        
		// create our coordinate and add it to the correct spot in the array
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
		
		// if it is the first point, just use them, since we have nothing to compare to yet.
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		} else {
			if (point.x > northEastPoint.x)
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x)
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y)
				southWestPoint.y = point.y;
		}
        
		pointArray[idx] = point;
	}
	
    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArray count:_points.count];
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
	}
    
    // clear the memory allocated earlier for the points
	free(pointArray);
    
    /*
     double width = northEastPoint.x - southWestPoint.x;
     double height = northEastPoint.y - southWestPoint.y;
     
     _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
     
     // zoom in on the route.
     [self.mapView setVisibleMapRect:_routeRect];
     */
}

/*
 #pragma mark
 #pragma mark Location Manager
 
 - (void)configureLocationManager
 {
 // Create the location manager if this object does not already have one.
 if (nil == _locationManager)
 _locationManager = [[CLLocationManager alloc] init];
 
 _locationManager.delegate = self;
 _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
 _locationManager.distanceFilter = 50;
 [_locationManager startUpdatingLocation];
 // [_locationManager startMonitoringSignificantLocationChanges];
 }
 
 #pragma mark
 #pragma mark CLLocationManager delegate methods
 - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 
 // If it's a relatively recent event, turn off updates to save power
 NSDate* eventDate = newLocation.timestamp;
 NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
 
 if (abs(howRecent) < 2.0)
 {
 NSLog(@"recent: %g", abs(howRecent));
 NSLog(@"latitude %+.6f, longitude %+.6f\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
 }
 
 // else skip the event and process the next one
 }
 
 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 NSLog(@"error: %@",error);
 }
 */

#pragma mark
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
//    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
//    NSLog(@"overlayViews: %@", overlayViews);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
//    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now.
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 10;
        
		overlayView = self.routeLineView;
	}
	
	return overlayView;
}

/*
 - (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
 {
 NSLog(@"mapViewWillStartLoadingMap:(MKMapView *)mapView");
 }
 
 - (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
 {
 NSLog(@"mapViewDidFinishLoadingMap:(MKMapView *)mapView");
 }
 
 - (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
 {
 NSLog(@"mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error");
 }
 
 - (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
 {
 NSLog(@"mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated");
 NSLog(@"%f, %f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
 }
 
 - (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 NSLog(@"centerCoordinate: %f, %f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
 }
 */

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
//    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
//    NSLog(@"annotation views: %@", views);
}

/*
 - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
 {
 NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
 }
 
 - (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
 {
 NSLog(@"mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated");
 }
 
 - (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
 {
 NSLog(@"mapViewWillStartLocatingUser:(MKMapView *)mapView");
 }
 
 - (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
 {
 NSLog(@"mapViewDidStopLocatingUser:(MKMapView *)mapView");
 }
 */

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude
                                                      longitude:userLocation.coordinate.longitude];
    // check the zero point
    if  (userLocation.coordinate.latitude == 0.0f ||
         userLocation.coordinate.longitude == 0.0f)
        return;
    
    // check the move distance
    if (_points.count > 0) {
        CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
        if (distance < 5)
            return;
    }
    
    if (nil == _points) {
        _points = [[NSMutableArray alloc] init];
    }
    
    [_points addObject:location];
    _currentLocation = location;
    
//    NSLog(@"points: %@", _points);
    
    [self configureRoutes];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}


@end
