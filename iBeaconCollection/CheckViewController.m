//
//  CheckViewController.m
//  iBeaconCollection
//
//  Created by Apple on 14-7-10.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import "CheckViewController.h"
#import "UrlClass.h"
#import "DKCircleButton.h"
#import "XYAlertViewHeader.h"
#import "MenuViewController.h"
@interface CheckViewController(){
    DKCircleButton *startButton;
    DKCircleButton *endButton;
    DKCircleButton *clearButton;
    DKCircleButton *saveButton;
    BOOL startButtonState;
    BOOL endButtonState;
    
}
@property (strong, nonatomic) NSMutableArray  *tableItems;
@property (nonatomic) CGPoint myPoint;
@property (nonatomic,strong) NSIndexPath *currentIndex;
@property (nonatomic,strong) NSMutableArray *pointArray;
@property (nonatomic,strong) UITableViewCell *currentCell;
@end

@implementation CheckViewController
@synthesize myPoint=_myPoint;
@synthesize imageView;
@synthesize currentIndex;
@synthesize pointArray;
@synthesize currentCell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    NSString* floorPlanId=[[UrlClass sharedManager] floorPlan];
    NSString *routeNameId=[[UrlClass sharedManager] currentRouteName];
    NSArray* foo = [routeNameId componentsSeparatedByString: @" ~ "];
    NSString* srcString = [foo objectAtIndex: 0];
    NSString* src=[srcString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString* dstString=[foo objectAtIndex:1];
    NSString* dst=[dstString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSString *urlString=[[[[[[NSString stringWithFormat:@"http://inav.zii.io/inav/%@",floorPlanId] stringByAppendingString:@"/"]stringByAppendingString:src]stringByAppendingString:@"/"] stringByAppendingString:dst] stringByAppendingString:@"/status"] ;
    NSURL *dataUrl=[[NSURL alloc] initWithString:urlString];
    NSData *data=[[NSData alloc] initWithContentsOfURL:dataUrl];
    NSError *error;
    NSMutableDictionary *allLocation = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:kNilOptions
                                        error:&error];
    self.tableItems=[[NSMutableArray alloc]initWithCapacity:100];
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSMutableArray *imageArray=[[NSMutableArray alloc]initWithCapacity:50];
        [imageArray addObject:[[allLocation[@"videoFrameMap"] objectForKey:@"0.0"] objectForKey:@"imageS3URL"]];
        [imageArray addObject:[[allLocation[@"videoFrameMap"] objectForKey:@"0.25"] objectForKey:@"imageS3URL"]];
        [imageArray addObject:[[allLocation[@"videoFrameMap"] objectForKey:@"0.5"] objectForKey:@"imageS3URL"]];
        [imageArray addObject:[[allLocation[@"videoFrameMap"] objectForKey:@"0.75"] objectForKey:@"imageS3URL"]];
        [imageArray addObject:[[allLocation[@"videoFrameMap"] objectForKey:@"1.0"] objectForKey:@"imageS3URL"]];
        for (NSString *object in imageArray) {
            NSURL *url = [NSURL URLWithString:object];
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            [self.tableItems addObject:image];

        }

    }
    pointArray=[[NSMutableArray alloc]initWithCapacity:10000];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Cell %d",), indexPath.row];
    cell.imageView.image = self.tableItems[indexPath.row];
    cell.imageView.transform=CGAffineTransformMakeRotation(M_PI/2);
//    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    addFriendButton.frame = CGRectMake(250.0f, 25.0f, 75.0f, 30.0f);
//    [addFriendButton setTitle:@"Add" forState:UIControlStateNormal];
//    [cell addSubview:addFriendButton];
    cell.backgroundColor=[UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1];
    startButton=[[DKCircleButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    startButton.titleLabel.font = [UIFont systemFontOfSize:9];
    startButton.center=CGPointMake(280.0f, 65.0f);
    [startButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [startButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [startButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [startButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
    [startButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
    
    [startButton addTarget:self action:@selector(tapOnStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:startButton];
    
    endButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    endButton.center = CGPointMake(280.0f,150.0f);
    endButton.titleLabel.font = [UIFont systemFontOfSize:9];
    [endButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [endButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [endButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [endButton setTitle:NSLocalizedString(@"End", nil) forState:UIControlStateNormal];
    [endButton setTitle:NSLocalizedString(@"End", nil) forState:UIControlStateSelected];
    [endButton setTitle:NSLocalizedString(@"End", nil) forState:UIControlStateHighlighted];
    
    [endButton addTarget:self action:@selector(tapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:endButton];
    
    
    clearButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    clearButton.center = CGPointMake(280, 235);
    clearButton.titleLabel.font = [UIFont systemFontOfSize:9];
    
    [clearButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [clearButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [clearButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [clearButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateSelected];
    [clearButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateHighlighted];
    
    [clearButton addTarget:self action:@selector(tapOnClearButton) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:clearButton];

    saveButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    saveButton.center = CGPointMake(280, 320);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:9];
    
    [saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [saveButton setTitle:NSLocalizedString(@"Draw", nil) forState:UIControlStateNormal];
    [saveButton setTitle:NSLocalizedString(@"Draw", nil) forState:UIControlStateSelected];
    [saveButton setTitle:NSLocalizedString(@"Draw", nil) forState:UIControlStateHighlighted];
    
    [saveButton addTarget:self action:@selector(tapOnSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:saveButton];
    
    return cell;
}

-(void)tapOnStartButton:(UITableViewCell*) cell{
        [startButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
        [startButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateSelected];
        [startButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateHighlighted];
    cell=[self.tableView cellForRowAtIndexPath:currentIndex];
    cell.imageView.userInteractionEnabled=YES;
        startButtonState = !startButtonState;
    endButtonState=NO;
}

- (void)tapOnButton:(UITableViewCell*) cell{
        
        [endButton setTitle:NSLocalizedString(@"End", nil) forState:UIControlStateNormal];
        [endButton setTitle:NSLocalizedString(@"End", nil) forState:UIControlStateSelected];
        [endButton setTitle:NSLocalizedString(@"End", nil) forState:UIControlStateHighlighted];
    cell=[self.tableView cellForRowAtIndexPath:currentIndex];
    cell.imageView.userInteractionEnabled=NO;
    endButtonState=YES;
}

-(void)tapOnClearButton{
    [clearButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [clearButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateSelected];
    [clearButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateHighlighted];
    [self saveCGcontext:currentCell];
}

-(void)tapOnSaveButton{
    [saveButton setTitle:NSLocalizedString(@"Drwa", nil) forState:UIControlStateNormal];
    [saveButton setTitle:NSLocalizedString(@"Draw", nil) forState:UIControlStateSelected];
    [saveButton setTitle:NSLocalizedString(@"Draw", nil) forState:UIControlStateHighlighted];
    [self drawLine:currentCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    currentIndex=indexPath;
    if(startButtonState&&!endButtonState){
        cell.imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelectedInTable:)];
        tapped.numberOfTapsRequired = 1;
        imageView=cell.imageView;
        currentCell=cell;
        [cell.imageView addGestureRecognizer:tapped];
    }
    


    
}


-(void)drawLine:(UITableViewCell*) cell{
    if([pointArray count]<2){
         XYShowAlert(@"Please tap more than one time");
    }else{
        cell=[self.tableView cellForRowAtIndexPath:currentIndex ];
//        CGFloat imageHeight=imageView.image.size.height;
//        CGFloat imageWidth=imageView.image.size.width;
        NSValue *fromValue=[pointArray objectAtIndex:[pointArray count]-2];
        NSValue *toValue=[pointArray objectAtIndex:[pointArray count]-1];
        CGPoint from=[fromValue CGPointValue];
        CGPoint to=[toValue CGPointValue];
        NSLog(@"x:----%f  y:-----%f",from.x,to.x);
        UIGraphicsBeginImageContextWithOptions(cell.imageView.image.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0, -cell.imageView.image.size.height);
        CGContextDrawImage(context, CGRectMake(0, 0, cell.imageView.image.size.width, cell.imageView.image.size.height), cell.imageView.image.CGImage);
        CGContextRestoreGState(context);
//        CGFloat startX= from.x;
//        CGFloat startY= from.y;
//        CGContextMoveToPoint(context, startX, startY);
//        CGFloat endX= to.x;
//        CGFloat endY= to.y;
        double slopy, cosy, siny;
        // Arrow size
        double length = 10.0;
        double width = 5.0;
        
        slopy = atan2((from.y - to.y), (from.x - to.x));
        cosy = cos(slopy);
        siny = sin(slopy);
        
        //draw a line between the 2 endpoint
        CGContextMoveToPoint(context, from.x - length * cosy, from.y - length * siny );
        CGContextAddLineToPoint(context, to.x + length * cosy, to.y + length * siny);
        //paints a line along the current path
        CGContextSetLineWidth(context, 20.0);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokePath(context);
        
        //here is the tough part - actually drawing the arrows
        //a total of 6 lines drawn to make the arrow shape
        CGContextMoveToPoint(context, from.x, from.y);
//        CGContextAddLineToPoint(context,
//                                from.x + ( - length * cosy - ( width / 2.0 * siny )),
//                                from.y + ( - length * siny + ( width / 2.0 * cosy )));
//        CGContextAddLineToPoint(context,
//                                from.x + (- length * cosy + ( width / 2.0 * siny )),
//                                from.y - (width / 2.0 * cosy + length * siny ) );
        CGContextSetLineWidth(context, 20.0);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextClosePath(context);
        CGContextStrokePath(context);
        
        /*/-------------similarly the the other end-------------/*/
        CGContextMoveToPoint(context, to.x, to.y);
        CGContextAddLineToPoint(context,
                                to.x +  (length * cosy - ( width / 2.0 * siny )),
                                to.y +  (length * siny + ( width / 2.0 * cosy )) );
        CGContextAddLineToPoint(context,
                                to.x +  (length * cosy + width / 2.0 * siny),
                                to.y -  (width / 2.0 * cosy - length * siny) );
        CGContextSetLineWidth(context, 40.0);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextClosePath(context);
        CGContextStrokePath(context);
        
//        CGContextAddLineToPoint(context, endX, endY);
//        CGContextSetLineWidth(context, 20.0);
//        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//        CGContextStrokePath(context);
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        cell.imageView.image=result;
        
    }
}


-(void)saveCGcontext:(UITableViewCell*) cell{

}

-(void)imageSelectedInTable:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView: imageView];
    [pointArray addObject:[NSValue valueWithCGPoint:touchPoint]];
}

-(void)returnAction{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    MenuViewController *viewController = navigationController.viewControllers[0];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(returnAction)];
    self.navigationItem.leftBarButtonItem = backButton;
}





@end
