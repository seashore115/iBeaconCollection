//
//  MenuViewController.m
//  iBeaconCollection
//
//  Created by Apple on 14-6-6.
//  Copyright (c) 2014年 meng.wang. All rights reserved.
//

#import "MenuViewController.h"
#import "DetailViewController.h"
#import "MainViewController.h"
#import "UrlClass.h"


@interface MenuViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *tableItems;

@end

@implementation MenuViewController

@synthesize floorPlanId;
@synthesize titleChoose;

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
    self.navigationController.navigationBarHidden=NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableItems=[[NSMutableArray alloc]initWithCapacity:100];
    //@"http://mcc-backend.appspot.com/mcc/floorplan/mapping/mccdemo"
    NSData *allLocationData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[UrlClass sharedManager].defaultUrl]];
    NSError *error;
    NSMutableDictionary *allLocation = [NSJSONSerialization
                                        JSONObjectWithData:allLocationData
                                        options:kNilOptions
                                        error:&error];
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSDictionary *array=allLocation[@"mapping"];
        
        NSArray *level= [array objectForKey:@"imageUrlsByLevel"] ;
        NSString *object;
        NSString *defaultFlag=@"http://mcc-backend.appspot.com";
        for (object in level){
            object=[defaultFlag stringByAppendingString:object];
            NSURL *url = [NSURL URLWithString:object];
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
//            NSLog(@"%f ----- %f",image.size.width,image.size.height);
            [self.tableItems addObject:image];
            
        }
//        NSLog(@"%@",self.tableItems);
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(print_back)];
    self.navigationItem.leftBarButtonItem = backButton;
    [super viewDidAppear:animated];
//    [self scrollViewDidScroll:nil];
}

-(void)print_back{
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    
    [self presentViewController:vc animated:YES completion:nil];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"parallaxCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Cell %d",), indexPath.row];
    cell.imageView.image = self.tableItems[indexPath.row];
    
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    // Get visible cells on table view.
//    NSArray *visibleCells = [self.tableView visibleCells];
//    
//    for (JBParallaxCell *cell in visibleCells) {
//        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"Detail" sender:self];
    //    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    DetailViewController *viewController = navigationController.viewControllers[0];
    
    // setup "inner" view controller
    titleChoose=[NSString stringWithFormat:NSLocalizedString(@"%d",), indexPath.row];
//    NSLog(@"index:%@",titleChoose);
    viewController.levelName=titleChoose;
    [self presentViewController:navigationController animated:YES completion:nil];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"Detail"]) {
//        
//
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        titleChoose=[NSString stringWithFormat:NSLocalizedString(@"%d",), indexPath.row];
//        NSLog(@"index:%@",titleChoose);
//        DetailViewController *detail=segue.destinationViewController;
//        detail.levelName=titleChoose;
//        detail.linkUrl=subUrlString;
//
//    }
//}

@end
