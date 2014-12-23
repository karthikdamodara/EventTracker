//
//  EventListViewController.m
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "EventListViewController.h"
#import "AppDelegate.h"
#import "Event.h"
#import "Constants.h"
#import  "EventDetailViewController.h"
#import "TrackEventListViewControllers.h"

@interface EventListViewController ()

{
    TrackEventListViewControllers* trckEventContrlr;
    
}

@property(nonatomic,strong)NSArray *eventsArray;

-(void)fromLeftToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

-(void)fromRightToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
@end

@implementation EventListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.eventsArray=[[NSArray alloc] init];
  
    AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kentityname inManagedObjectContext:appdelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    self.eventsArray = [appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    }
    
    
    // swipe gestures
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(fromLeftToRightWithGestureRecognizer:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(fromRightToLeftWithGestureRecognizer:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.tableView addGestureRecognizer:swipeRight];
    [self.tableView addGestureRecognizer:swipeLeft];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.eventsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
    UILabel *eventName = (UILabel *)[cell viewWithTag:101];
    eventName.text = ((Event *)[self.eventsArray objectAtIndex:indexPath.row]).name;
    
    UILabel *eventAddress = (UILabel *)[cell viewWithTag:102];
    eventAddress.text = ((Event *)[self.eventsArray objectAtIndex:indexPath.row]).address;
    
    UILabel *eventType = (UILabel *)[cell viewWithTag:103];
    eventType.text = ((Event *)[self.eventsArray objectAtIndex:indexPath.row]).type;
    
    UIImageView *eventImage = (UIImageView *)[cell viewWithTag:100];
    eventImage.image=[UIImage imageNamed:((Event *)[self.eventsArray objectAtIndex:indexPath.row]).thumbnail];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Find the selected cell in the usual way
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kcellsegue sender:cell];
   
    }



     /******************************** methods have come by default   ***********************************************/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:kcellsegue]) {
        EventDetailViewController *detailView=[segue destinationViewController];
        detailView.title=((Event *)[self.eventsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row]).name;
        detailView.event=((Event *)[self.eventsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row]);
        
    }
    
}

#pragma - swipe gestures

-(void)fromLeftToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)fromRightToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
    trckEventContrlr =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                           instantiateViewControllerWithIdentifier:ktrackViewController];
    
    trckEventContrlr.delegate=self;
    
    [[self navigationController] pushViewController:trckEventContrlr animated:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
 
    
}



@end
