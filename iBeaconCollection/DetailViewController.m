//
//  DetailViewController.m
//  iBeaconCollection
//
//  Created by Apple on 14-6-9.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import "DetailViewController.h"
#import "MenuViewController.h"
#import "UrlClass.h"
#import "ImageViewController.h"
#import <Foundation/Foundation.h>

@interface DetailViewController ()
@property (nonatomic,strong)  NSMutableArray *routeArray;

@end

@implementation DetailViewController
@synthesize levelName;
@synthesize routeArray;
@synthesize mapView;
@synthesize currentLocation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
     }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(print_back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem=[[MKUserTrackingBarButtonItem alloc]initWithMapView:self.mapView];
    self.mapView.userTrackingMode=MKUserTrackingModeFollow;
//    NSLog(@"%@",levelName);

}

-(void)print_back{
    MenuViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    
    [self presentViewController:vc animated:YES completion:nil];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _flabbyTableManager = [[BRFlabbyTableManager alloc] initWithTableView:_tableView];
    [_flabbyTableManager setDelegate:self];
    
    _cellColors = @[[UIColor colorWithRed:27.0f/255.0f green:191.0f/255.0f blue:161.0f/255.0f alpha:1.0f],
                    [UIColor colorWithRed:126.0f/255.0f green:113.0f/255.0f blue:128.0f/255.0f alpha:1.0f],
                    [UIColor colorWithRed:255.0f/255.0f green:79.0f/255.0f blue:75.0f/255.0f alpha:1.0f],
                    [UIColor colorWithRed:150.0f/255.0f green:214.0f/255.0f blue:217.0f/255.0f alpha:1.0f],
                    [UIColor colorWithRed:230.0f/255.0f green:213.0f/255.0f blue:143.0f/255.0f alpha:1.0f]];
    
    [self.view addSubview:mapView];
    [mapView setShowsUserLocation:YES];
    self.mapView.delegate=self;
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    if(CLLocationManager.locationServicesEnabled) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度
        locationManager.distanceFilter = 100.0f;//响应位置变化的最小距离(m)
        [locationManager startUpdatingLocation];
    }
    [locationManager startUpdatingLocation];

    
    NSData *allLocationData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[UrlClass sharedManager].defaultUrl]];
    NSError *error;
    NSMutableDictionary *allLocation = [NSJSONSerialization
                                        JSONObjectWithData:allLocationData
                                        options:kNilOptions
                                    error:&error];
    routeArray=[[NSMutableArray alloc]initWithCapacity:10000];
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSDictionary *edges=[allLocation[@"floorplan"] objectForKey:@"edges"];
        NSDictionary *object;
        for (object in edges){
            NSString *route=@"";
            NSString *reverseRoute=@"";
            route=[[[object objectForKey:@"start"] stringByAppendingString:@" ~ "]stringByAppendingString:[object objectForKey:@"end"]];
            reverseRoute=[[[object objectForKey:@"end"] stringByAppendingString:@" ~ "]stringByAppendingString:[object objectForKey:@"start"]];
            [routeArray addObject:route];
            [routeArray addObject:reverseRoute];
            
            
        }
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailwithError: %@",error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    currentLocation=newLocation;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BRFlabbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRFlabbyTableViewCellIdentifier" forIndexPath:indexPath];
    [cell setFlabby:YES];
    [cell setLongPressAnimated:YES];
    [cell setFlabbyColor:[self colorForIndexPath:indexPath]];
    cell.textLabel.text=[routeArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:@"Arail" size:30.0f];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
}

#pragma mark - BRFlabbyTableManagerDelegate methods

- (UIColor *)flabbyTableManager:(BRFlabbyTableManager *)tableManager flabbyColorForIndexPath:(NSIndexPath *)indexPath{
    return [self colorForIndexPath:indexPath];
}

#pragma mark - Miscellenanious

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = indexPath.row;
    return _cellColors[row%_cellColors.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [self performSegueWithIdentifier:@"Detail" sender:self];
    //    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Image"];
    ImageViewController *viewController = navigationController.viewControllers[0];
    NSString *romeNameString=@"";
    romeNameString=[[@"'" stringByAppendingString:[routeArray objectAtIndex:indexPath.row]] stringByAppendingString:@"'"];
    [UrlClass sharedManager].currentRouteName=[routeArray objectAtIndex:indexPath.row];
    [UrlClass sharedManager].routeData=romeNameString;
    [self presentViewController:navigationController animated:YES completion:nil];

    
//    ImageViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Video"];
//    NSString *romeNameString=@"";
//    romeNameString=[[@"'" stringByAppendingString:[routeArray objectAtIndex:indexPath.row]] stringByAppendingString:@"'"];
//    [UrlClass sharedManager].currentRouteName=romeNameString;
//    viewController.name=romeNameString;
//    // setup "inner" view controller
//    [self presentViewController:viewController animated:YES completion:nil];
    
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

@end
