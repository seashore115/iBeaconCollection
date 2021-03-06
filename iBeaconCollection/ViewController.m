//
//  ViewController.m
//  iCollection
//
//  Created by mengwang on 06/03/14.
//  Copyright (c) 2013 mengwang. All rights reserved.


#import "ViewController.h"
#import "SVProgressHUD.h"
#import "AVCaptureManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ESTBeaconManager.h"
#import "DisplayViewController.h"
#import "UrlClass.h"


@interface ViewController ()
<AVCaptureManagerDelegate,ESTBeaconManagerDelegate,CLLocationManagerDelegate>
{
    NSTimeInterval startTime;
    BOOL isNeededToSave;
}
@property (nonatomic, strong) AVCaptureManager *captureManager;
@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, strong) UIImage *recStartImage;
@property (nonatomic, strong) UIImage *recStopImage;
@property (nonatomic, strong) UIImage *outerImage1;
@property (nonatomic, strong) UIImage *outerImage2;

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *fpsControl;
@property (nonatomic, weak) IBOutlet UIButton *recBtn;
@property (nonatomic, weak) IBOutlet UIImageView *outerImageView;

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@end


@implementation ViewController
@synthesize zeroQuarter;
@synthesize oneQuarter;
@synthesize twoQuarter;
@synthesize threeQuarter;
@synthesize fourQuarter;
@synthesize locationManager;
@synthesize xValue;
@synthesize yValue;
@synthesize zValue;
@synthesize latitude;
@synthesize longitude;
@synthesize beaconArray;
@synthesize outputString;
@synthesize flag;
@synthesize time;
@synthesize outputFrontString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    oneQuarter=@"";
    twoQuarter=@"";
    threeQuarter=@"";
    fourQuarter=@"";
    outputString=@"";
    flag=false;
 
    [self setupManager];
    
    self.locationManager = [[CLLocationManager alloc] init] ;
	if ([CLLocationManager headingAvailable] == NO) {
		// No compass is available. This application cannot function without a compass,
        // so a dialog will be displayed and no magnetic data will be measured.
        self.locationManager = nil;
        UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"No Compass!" message:@"This device does not have the ability to measure magnetic fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noCompassAlert show];
	} else {
        // heading service configuration
        locationManager.headingFilter = kCLHeadingFilterNone;
        
        // setup delegate callbacks
        locationManager.delegate = self;
        
        // start the compass
        [locationManager startUpdatingHeading];
    }
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    self.captureManager = [[AVCaptureManager alloc] initWithPreviewView:self.view];
    self.captureManager.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleDoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    
    
    // Setup images for the Shutter Button
    UIImage *image;
    image = [UIImage imageNamed:@"ShutterButtonStart"];
    self.recStartImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.recBtn setImage:self.recStartImage
                 forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"ShutterButtonStop"];
    self.recStopImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.recBtn setTintColor:[UIColor colorWithRed:245./255.
                                              green:51./255.
                                               blue:51./255.
                                              alpha:1.0]];
    self.outerImage1 = [UIImage imageNamed:@"outer1"];
    self.outerImage2 = [UIImage imageNamed:@"outer2"];
    self.outerImageView.image = self.outerImage1;
    
//    NSString *subName=@"";
//    subName=[name substringFromIndex:1];
//    trimName =[subName substringToIndex:[subName length]-1];
    
    //arff
//    NSString *outputRoomString=@"";
//    outputFrontString=@"";
//    outputFrontString=[[@"@relation " stringByAppendingString: [UrlClass sharedManager].floorPlan] stringByAppendingString: @"\n\n"];
//    outputFrontString=[outputFrontString stringByAppendingString: @"@attribute time date \"HH:mm:ss\"\n@attribute major numeric\n@attribute minor numeric\n@attribute distance numeric\n"];
//    outputRoomString=[@"@attribute room " stringByAppendingString: @"string\n"];
//    outputFrontString=[outputFrontString stringByAppendingString: outputRoomString];
//    outputFrontString=[[[[[outputFrontString  stringByAppendingString:@"@attribute x numeric\n"] stringByAppendingString: @"@attribute y numeric\n"] stringByAppendingString: @"@attribute z numeric\n"] stringByAppendingString: @"@attribute latitude numeric\n"] stringByAppendingString:@"@attribute longitude numeric\n\n@data\n"];
}

// ============================================================================
#pragma mark - Beacon Tracking

- (void)setupManager
{
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                  identifier:@"EstimoteSampleRegion"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    xValue=[NSString stringWithFormat:@"%.1f", newHeading.x];
    yValue=[NSString stringWithFormat:@"%.1f", newHeading.y];
    zValue=[NSString stringWithFormat:@"%.1f", newHeading.z];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    latitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    if([beacons count] > 0)
        beaconArray=beacons;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


// =============================================================================
#pragma mark - Gesture Handler

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    
    [self.captureManager toggleContentsGravity];
}


// =============================================================================
#pragma mark - Private


- (void)saveRecordedFile:(NSURL *)recordedFile {
    flag=true;
    [SVProgressHUD showWithStatus:@"Saving..."
                         maskType:SVProgressHUDMaskTypeGradient];

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
//        //Read File in local
//        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString* filename=[NSString stringWithFormat:@"%@.arff",[UrlClass sharedManager].floorPlan];
//        NSString* foofile = [documentsPath stringByAppendingPathComponent:filename];
//        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
//        NSError *csvError = NULL;
//        if (fileExists) {
//            NSString *string=[NSString stringWithContentsOfFile:foofile encoding:NSUTF8StringEncoding error:nil];
//            outputString=[string stringByAppendingString:outputString];
//            NSLog(@"\n+++++\n\n%@\n",outputString);
//            [outputString writeToFile:foofile atomically:YES encoding:NSUTF8StringEncoding error:&csvError];
//            NSLog(@"******%@",csvError);
//        }else{
//            outputString=[outputFrontString stringByAppendingString:outputString];
//            //        outputString=[@"major,minor,distance,room,x,y,z,latitude,longitude\n" stringByAppendingString:outputString];
////            NSLog(@"$$$$$%@",outputString );
//            NSLog(@"\n first time +++++\n\n%@\n",outputString);
//            [outputString writeToFile:foofile atomically:YES encoding:NSUTF8StringEncoding error:&csvError];
//            NSLog(@"----%@",csvError);
//        }
//        NSString *text=@"";
//        text=[[[[[[[text stringByAppendingString:[NSString stringWithFormat:@"%.3f",oneQuarter ]] stringByAppendingString:@","] stringByAppendingString:[NSString stringWithFormat:@"%.3f",twoQuarter]] stringByAppendingString:@","] stringByAppendingString:[NSString stringWithFormat:@"%.3f",threeQuarter]]stringByAppendingString:@","] stringByAppendingString:[NSString stringWithFormat:@"%.3f",fourQuarter]];
        NSString* floorPlanId=[[UrlClass sharedManager] floorPlan];
        NSString *routeNameId=[[UrlClass sharedManager] currentRouteName];
        NSArray* foo = [routeNameId componentsSeparatedByString: @" ~ "];
        NSString* srcString = [foo objectAtIndex: 0];
        NSString* dstString=[foo objectAtIndex:1];
        NSMutableDictionary *videoTimestamp=[[NSMutableDictionary alloc]initWithCapacity:30];
        [videoTimestamp setObject: zeroQuarter forKey:@"0.0"];
        [videoTimestamp setObject: oneQuarter  forKey:@"0.25"];
        [videoTimestamp setObject: twoQuarter forKey:@"0.50"];
        [videoTimestamp setObject: threeQuarter forKey:@"0.75"];
        [videoTimestamp setObject: fourQuarter forKey:@"1.0"];
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]initWithCapacity:50];
        [dictionary setObject:floorPlanId forKey:@"floorplanId"];
        [dictionary setObject:srcString forKey:@"srcLocationId"];
        [dictionary setObject:dstString forKey:@"trgLocationId"];
        [dictionary setObject:videoTimestamp forKey:@"videoTimestamp"];
        if ([NSJSONSerialization isValidJSONObject:dictionary]) {
            NSError *error;
            //NSLog(@"1");
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString* textname=[NSString stringWithFormat:@"%@.json",[[UrlClass sharedManager]currentRouteName]];
            NSString* textfile = [documentsPath stringByAppendingPathComponent:textname];
            [jsonData writeToFile:textfile atomically:YES];
        }
       


       // outputString=@"";
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        [assetLibrary writeVideoAtPathToSavedPhotosAlbum:recordedFile
                                         completionBlock:
         ^(NSURL *assetURL, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [SVProgressHUD dismiss];
                 
                 NSString *title;
                 NSString *message;
                 
                 if (error != nil) {
                     
                     title = @"Failed to save video";
                     message = [error localizedDescription];
                 }
                 else {
                     title = @"Saved!";
                     message = nil;
                 }
                 
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                 message:message
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             });
         }];
    });
}



// =============================================================================
#pragma mark - Timer Handler

- (void)timerHandler:(NSTimer *)timer {
    
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval recorded = current - startTime;
    self.statusLabel.text = [NSString stringWithFormat:@"%.2f", recorded];
    
//    dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(currentQueue, ^{
//        
//        dispatch_sync(currentQueue, ^{
//            
//            //download the image here
//            [self performSelector:@selector(beaconMessage) withObject:nil afterDelay:3.0];
//
//            
//        });
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            //handle the image to the user here on the main queue
//            self.statusLabel.text = [NSString stringWithFormat:@"%.2f", recorded];
//            
//        }); 
//    });
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        if (flag==false) {
//            [self performSelector:@selector(beaconMessage) withObject:nil afterDelay:3.0];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.statusLabel.text = [NSString stringWithFormat:@"%.2f", recorded];
//        });
//    });
    
}


//-(void)beaconMessage{
//    NSDate *now = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"hh:mm:ss";
//    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//    time = [dateFormatter stringFromDate:now];
//    //Get Message
//    for (ESTBeacon *beacon in beaconArray) {
//        float rawDistance=[beacon.distance floatValue];
//        outputString=[outputString stringByAppendingFormat:@"%@,%i,%i,%.3f,%@,%.3f,%.3f,%.3f,%.3f,%.3f\n",time,[beacon.major unsignedShortValue],[beacon.minor unsignedShortValue],rawDistance,[UrlClass sharedManager].routeData,[xValue floatValue] ,[yValue floatValue],[zValue floatValue],[latitude floatValue],[longitude floatValue]];
//        NSLog(@"\n++++---- %@\n ",outputString);
//    }
//}

// =============================================================================
#pragma mark - AVCaptureManagerDeleagte

- (void)didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL error:(NSError *)error {
    
    if (error) {
        NSLog(@"error:%@", error);
        return;
    }
    
    if (!isNeededToSave) {
        return;
    }
    
    [self saveRecordedFile:outputFileURL];
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)recButtonTapped:(id)sender {
    
    // REC START
    if (!self.captureManager.isRecording) {
        
        // change UI
        [self.recBtn setImage:self.recStopImage
                     forState:UIControlStateNormal];
        self.fpsControl.enabled = NO;
        
        // timer start
        startTime = [[NSDate date] timeIntervalSince1970];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                      target:self
                                                    selector:@selector(timerHandler:)
                                                    userInfo:nil
                                                     repeats:YES];
        self.fpsControl.enabled = YES;
//        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
//        NSString* dateTimePrefix = [formatter stringFromDate:[NSDate date]];
//        
//        int fileNamePostfix = 0;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = nil;
        do
            filePath =[NSString stringWithFormat:@"/%@/%@.mp4", documentsDirectory, [[UrlClass sharedManager] currentRouteName]];
        while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
//        NSURL *fileURL = [NSURL URLWithString:[@"file://" stringByAppendingString:filePath]];
        NSURL *fileURL =[NSURL fileURLWithPath:filePath];
        [self.captureManager startRecording:fileURL];
        
    }
    // REC STOP
    else {
        flag=false;
        isNeededToSave = YES;
        [self.captureManager stopRecording];
        
        [self.timer invalidate];
        self.timer = nil;
        self.statusLabel.text=@"00:00:00";
        
        // change UI
        [self.recBtn setImage:self.recStartImage
                     forState:UIControlStateNormal];
        self.fpsControl.enabled = NO;
    }
}

//- (IBAction)retakeButtonTapped:(id)sender {
//
//    isNeededToSave = NO;
//    [self.captureManager stopRecording];
//
//    [self.timer invalidate];
//    self.timer = nil;
//
//    self.statusLabel.text = nil;
//}

- (IBAction)fpsChanged:(UISegmentedControl *)sender {
    
    // Switch FPS
    NSInteger zeroCnt=0, firstCnt=0, secondCnt=0, thirdCnt=0, fourthCnt=0;
    
    //    CGFloat desiredFps = 0.0;;
    switch (self.fpsControl.selectedSegmentIndex) {
        case 0:
            zeroCnt= [self.statusLabel.text integerValue];
            zeroQuarter=[self changeFormatter:zeroCnt];
            break;
        case 1:
            firstCnt= [self.statusLabel.text integerValue];
            oneQuarter=[self changeFormatter:firstCnt];
            break;
        case 2:
            secondCnt= [self.statusLabel.text integerValue];
            twoQuarter=[self changeFormatter:secondCnt];
            break;
        case 3:
            thirdCnt= [self.statusLabel.text integerValue];
            threeQuarter=[self changeFormatter:thirdCnt];
            break;
        case 4:
            fourthCnt= [self.statusLabel.text integerValue];
            fourQuarter=[self changeFormatter:fourthCnt];
            flag=true;
            break;
    }
//    zeroQuarter=[self changeFormatter:zeroCnt];
//    oneQuarter=[self changeFormatter:firstCnt];
//    twoQuarter=[self changeFormatter:secondCnt];
//    twoQuarter=[self changeFormatter:secondCnt];
//    twoQuarter=[self changeFormatter:secondCnt];
    NSLog(@"time0---%@",zeroQuarter);
    NSLog(@"time1---%@",oneQuarter);
    NSLog(@"time2---%@",twoQuarter);
    NSLog(@"time3---%@",threeQuarter);
    NSLog(@"time4---%@",fourQuarter);
    
    
}

-(NSString *)changeFormatter:(NSUInteger)elapsedSeconds{
    NSUInteger h = elapsedSeconds / 3600;
    NSUInteger m = (elapsedSeconds / 60) % 60;
    NSUInteger s = elapsedSeconds % 60;
    
    NSString *formattedTime = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s];
    return formattedTime;
}
- (IBAction)Exit:(id)sender {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Display"];
    DisplayViewController *viewController = navigationController.viewControllers[0];
    viewController.fileName=[[UrlClass sharedManager] currentRouteName];
    [self presentViewController:navigationController animated:YES completion:nil];

}

@end

