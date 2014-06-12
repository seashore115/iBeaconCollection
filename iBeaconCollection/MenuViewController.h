//
//  MenuViewController.h
//  iBeaconCollection
//
//  Created by Apple on 14-6-6.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (nonatomic,retain)NSString* floorPlanId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain)NSString* titleChoose;
@end
