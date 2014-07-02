//
//  ViewController.h
//  iBeaconCollection
//
//  Created by Apple on 14-6-4.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>{
        CLLocationManager *locationManager;
}

@property(nonatomic) double oneQuarter;
@property(nonatomic) double twoQuarter;
@property(nonatomic) double threeQuarter;
@property(nonatomic) double fourQuarter;
@property(nonatomic) double zeroQuarter;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong,nonatomic)NSString* xValue;
@property (strong,nonatomic)NSString* yValue;
@property (strong,nonatomic)NSString* zValue;
@property (strong,nonatomic)NSString* latitude;
@property (strong,nonatomic)NSString* longitude;
@property (nonatomic, copy)NSArray*  beaconArray;
@property (nonatomic, strong)NSString *outputString;
@property (nonatomic) bool flag;
@property (nonatomic,strong)NSString *timeString;
@property (nonatomic,strong)NSString *time;
@property (strong,nonatomic)NSString* outputFrontString;



@end
