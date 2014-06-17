//
//  ImageViewController.m
//  iBeaconCollection
//
//  Created by Apple on 14-6-16.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import "ImageViewController.h"
#import "UrlClass.h"
#import "ViewController.h"
#import "DetailViewController.h"
#import "ViewController.h"
#import "CUSFlashLabel.h"

@interface ImageViewController ()
@property(nonatomic,strong) CUSFlashLabel *roomTitle;
@end

@implementation ImageViewController
@synthesize imageView;
@synthesize roomTitle;
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
    
    self.confirm.layer.cornerRadius = 15; // this value vary as per your desire
    self.confirm.clipsToBounds = YES;
    [[self.confirm layer] setBorderWidth:1.0f];
    [[self.confirm layer] setBorderColor:[UIColor yellowColor].CGColor];
    
    NSString *apple=[[UrlClass sharedManager] currentRouteName];
    NSArray *APPLE= [apple componentsSeparatedByString:@" ~ "];
    
    NSData *allLocationData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[[UrlClass sharedManager]defaultUrl]]];
    NSError *error;
    NSMutableDictionary *allLocation = [NSJSONSerialization
                                        JSONObjectWithData:allLocationData
                                        options:kNilOptions
                                        error:&error];
    NSDictionary *array=allLocation[@"mapping"];
    NSArray *level= [array objectForKey:@"imageUrlsByLevel"] ;
    NSString *object;
    NSString *defaultFlag=@"http://mcc-backend.appspot.com";
    NSString *imageString = [level objectAtIndex:0];
    object=[defaultFlag stringByAppendingString:imageString];
    NSURL *url = [NSURL URLWithString:object];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
        //            NSLog(@"%f ----- %f",image.size.width,image.size.height);
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSDictionary *mapping=[allLocation[@"mapping"] objectForKey:@"mapping"];
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0, -image.size.height);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
        CGContextRestoreGState(context);
        CGFloat startX= [[[mapping objectForKey:[APPLE objectAtIndex:0]] objectForKey:@"x"] floatValue];
        CGFloat startY= [[[mapping objectForKey:[APPLE objectAtIndex:0]] objectForKey:@"y"] floatValue];
        CGContextMoveToPoint(context, startX, startY);
        CGFloat endX= [[[mapping objectForKey:[APPLE objectAtIndex:1]] objectForKey:@"x"] floatValue];
        CGFloat endY= [[[mapping objectForKey:[APPLE objectAtIndex:1]] objectForKey:@"y"] floatValue];
        CGContextAddLineToPoint(context, endX, endY);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokePath(context);
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageView.image=result;
    }
    
    roomTitle = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(45, 70, 300, 50)];
    [roomTitle setFont:[UIFont systemFontOfSize:20]];
    [roomTitle setContentMode:UIViewContentModeTop];
    [roomTitle setSpotlightColor:[UIColor yellowColor]];
    [roomTitle startAnimating];
    [self.view addSubview:roomTitle];
    roomTitle.text=[[UrlClass sharedManager] currentRouteName];
    

}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    float imageScale = sqrtf(recognizer.view.transform.a * recognizer.view.transform.a +
                             recognizer.view.transform.c * recognizer.view.transform.c);
    if ((recognizer.scale > 1.0) && (imageScale >= 2.00)) {
        return;
    }
    if ((recognizer.scale < 1.0) && (imageScale <= 0.75)) {
        return;
    }
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(print_back)];
    backButton.tintColor=[UIColor yellowColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void) print_back{
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)nextPage:(id)sender{
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Video"];
    [self presentViewController:viewController animated:YES completion:nil];
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
