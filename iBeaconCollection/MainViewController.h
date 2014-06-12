//
//  MainViewController.h
//  iBeaconCollection
//
//  Created by Apple on 14-6-5.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"
#import "EAIntroView.h"
#import "UrlClass.h"

@interface MainViewController : UIViewController<EAIntroDelegate>
@property (strong, nonatomic) IBOutlet DemoTextField *inputPlanId;
@property (strong, nonatomic) IBOutlet UIButton *enterInfo;


@end
