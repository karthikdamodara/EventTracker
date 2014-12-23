//
//  TrackEventListViewControllers.m
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "TrackEventListViewControllers.h"
#import "AppDelegate.h"
#import "Event.h"
#import "Constants.h"
#import "EventDetailViewController.h"
#import "EventListViewController.h"

@interface TrackEventListViewControllers (){

}

@property(strong,nonatomic)NSMutableArray *trackingEvents;
-(void)fromLeftToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

@end

@implementation TrackEventListViewControllers

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.trackingEvents=[[NSMutableArray alloc] init];
    self.trackingEvents=[[[NSUserDefaults standardUserDefaults] arrayForKey:ktrackingobjects] mutableCopy];
    
    
    // swipe gestures
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(fromLeftToRightWithGestureRecognizer:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=nil;
    
    self.title=ktrackingEventsTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trackingEvents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    
   
   
    
    UILabel *eventName = (UILabel *)[cell viewWithTag:101];
    eventName.text = [[self.trackingEvents objectAtIndex:indexPath.row] objectForKey:kname];
    
    UIImageView *eventImage = (UIImageView *)[cell viewWithTag:100];
    eventImage.image=[UIImage imageNamed:[[self.trackingEvents objectAtIndex:indexPath.row] objectForKey:kthumbnail]];
    
    
    UILabel *eventAddress = (UILabel *)[cell viewWithTag:102];
    eventAddress.text = [[self.trackingEvents objectAtIndex:indexPath.row] objectForKey:kaddress];
    
    UILabel *eventType = (UILabel *)[cell viewWithTag:103];
    eventType.text = [[self.trackingEvents objectAtIndex:indexPath.row] objectForKey:ktype];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Find the selected cell in the usual way
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:ktrackcellsegue sender:cell];
    
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
         [self.trackingEvents removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
         NSArray *tempArray=[NSArray arrayWithArray:self.trackingEvents];
        [[NSUserDefaults standardUserDefaults] setValue:tempArray forKey:ktrackingobjects];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.trackingEvents exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    
    NSArray *tempArray=[NSArray arrayWithArray:self.trackingEvents];
    [[NSUserDefaults standardUserDefaults] setValue:tempArray forKey:ktrackingobjects];
    [[NSUserDefaults standardUserDefaults] synchronize];
  
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
   return YES;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    if ([segue.identifier isEqual:ktrackcellsegue]) {
        EventDetailViewController *detailView=[segue destinationViewController];
        
        
        detailView.title= [[self.trackingEvents objectAtIndex:[self.tableView indexPathForSelectedRow].row] objectForKey:kname];
        
        NSNumber *tempEventId=[[self.trackingEvents objectAtIndex:[self.tableView indexPathForSelectedRow].row]
                                                   objectForKey:keventID];
        
        
        AppDelegate *appdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:kentityname inManagedObjectContext:appdelegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *tempArray = [appdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for(Event *event in tempArray){
            
            if(tempEventId == event.eventID){
             
                detailView.event=event;
                break;
                
            }
            
        }
         [[self navigationController] setNavigationBarHidden:NO animated:YES];
        
        
    }
}

#pragma - swipe gestures

-(void)fromLeftToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    
   
       // [[self navigationController] popToRootViewControllerAnimated:YES];
    
       [[self navigationController] popToViewController:self.delegate animated:YES];
    
        [self.delegate fromLeftToRightWithGestureRecognizer:gestureRecognizer];
    
    
}

#pragma user defined methods

-(void)editEvents:(id)sender{
    
    self.tableView.editing=!self.tableView.editing;
    
}


@end
