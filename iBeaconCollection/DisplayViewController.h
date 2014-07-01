//
//  DisplayViewController.h
//  iBeaconCollection
//
//  Created by Apple on 14-6-11.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

@class MAConfirmButton;

@interface DisplayViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
	// the map view
	MKMapView* _mapView;
	
    // routes points
    NSMutableArray* _points;
    
	// the data representing the route points.
	MKPolyline* _routeLine;
	
	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
    
    // location manager
    CLLocationManager* _locationManager;
    
    // current location
    CLLocation* _currentLocation;
    
    
    MBProgressHUD *aMBProgressHUD;
    
    
}

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property(nonatomic,strong) NSString * fileName;
@property(strong,nonatomic)IBOutlet  UIProgressView *progressIndicator;
@property (strong,nonatomic) IBOutlet UILabel *progressLabel;

-(void) configureRoutes;


@end
