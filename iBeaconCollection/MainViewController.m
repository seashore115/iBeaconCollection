//
//  MainViewController.m
//  iBeaconCollection
//
//  Created by Apple on 14-6-5.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
//    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
//    [self.view addSubview:imageView];

    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"aValue"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"aValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            [self showIntroWithCrossDissolve];
    }
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255. green:242/255. blue:246/255. alpha:1.0]];
    [self setEdgesForExtendedLayout:UIRectEdgeTop];
    [_inputPlanId setRequired:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterInfo:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Do something interesting!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    if (![self validateInputInView:self.view]){
        
        [alertView setMessage:@"Invalid information please review and try again!"];
        [alertView setTitle:@"Login Failed"];
    }
    
    [alertView show];
}


- (BOOL)validateInputInView:(UIView*)view
{
    for(UIView *subView in view.subviews){
        if ([subView isKindOfClass:[UIScrollView class]])
            return [self validateInputInView:subView];
        
        if ([subView isKindOfClass:[DemoTextField class]]){
            if (![(MHTextField*)subView validate]){
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
  //  self.navigationController.navigationBarHidden=YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    // all settings are basic, pages with custom packgrounds, title image on each page

}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello iBeaconCollection";
    page1.desc = @"Frist you should input the floorplanid.";
    page1.bgImage = [UIImage imageNamed:@"1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Second Step";
    page2.desc = @"Choose the route you want to record.";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Final Step";
    page3.desc = @"Press the record button and test it.";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}
- (IBAction)enterId:(id)sender {
    if ([self.inputPlanId.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warnning" message:@"Please input your floorplanid!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];

    }else{
        UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
        MenuViewController *viewController = navigationController.viewControllers[0];
        
        // setup "inner" view controller
        [UrlClass sharedManager].defaultUrl=[@"http://mcc-backend.appspot.com/mcc/floorplan/mapping/" stringByAppendingString: self.inputPlanId.text];
        [UrlClass sharedManager].floorPlan=self.inputPlanId.text;
        viewController.floorPlanId=self.inputPlanId.text;
        
        [self presentViewController:navigationController animated:YES completion:nil];

    }
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"List"]){
//        MenuViewController *nameViewController;
//        nameViewController=segue.destinationViewController;
//        nameViewController.subUrlString=[@"http://mcc-backend.appspot.com/mcc/floorplan/mapping/" stringByAppendingString: self.inputPlanId.text];
//        nameViewController.floorPlanId=self.inputPlanId.text;
//    }
//}


@end
