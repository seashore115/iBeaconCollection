//
//  DetailViewController.h
//  iBeaconCollection
//
//  Created by Apple on 14-6-9.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRFlabbyTableManager.h"
#import "BRFlabbyTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,BRFlabbyTableManagerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D  newLocCoordinate;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BRFlabbyTableManager    *flabbyTableManager;
@property (strong, nonatomic) NSArray                 *cellColors;
@property (nonatomic,strong)  NSString * levelName;
@property (nonatomic,strong)  NSString *linkUrl;
@property(strong,nonatomic)CLLocation *currentLocation;


@end
