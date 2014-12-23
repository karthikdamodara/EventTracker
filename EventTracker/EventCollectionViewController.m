//
//  EventCollectionViewController.m
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "EventCollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Event.h"
#import "EventDetailViewController.h"
#import "TrackEventListViewControllers.h"


@interface EventCollectionViewController (){
    
    TrackEventListViewControllers* trckEventContrlr;
}

@property(nonatomic,strong)NSArray *eventsArray;

-(void)fromLeftToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

-(void)fromRightToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
@end

@implementation EventCollectionViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
   // [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // Do any additional setup after loading the view.
    
    self.title=@"Events";

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
    
    [self.collectionView addGestureRecognizer:swipeRight];
    [self.collectionView addGestureRecognizer:swipeLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.eventsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:
    (NSIndexPath *)indexPath {
    
    
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    
    cell.img.image=[UIImage imageNamed:((Event *)[self.eventsArray objectAtIndex:indexPath.row]).thumbnail];
    
    cell.eventName.text=((Event *)[self.eventsArray objectAtIndex:indexPath.row]).name;
    
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

//
//// Uncomment this method to specify if the specified item should be highlighted during tracking
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}
//
//
//// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
 
 */


/*
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Find the selected cell in the usual way
   // CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
  //  [self performSegueWithIdentifier:kgridsegue sender:cell];
    
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:kgridsegue]) {
        
        EventDetailViewController *detailView=[segue destinationViewController];
        detailView.title=((Event *)[self.eventsArray objectAtIndex:[self.collectionView
                                                                    indexPathForCell:(CustomCollectionViewCell *)sender].row]).name;
        detailView.event=((Event *)[self.eventsArray objectAtIndex:[self.collectionView
                                                                    indexPathForCell:(CustomCollectionViewCell *)sender].row]);
        
    }
    
}

#pragma - swipe gestures

-(void)fromLeftToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    
 
    
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
