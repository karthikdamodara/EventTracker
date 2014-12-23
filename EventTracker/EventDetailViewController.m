//
//  EventDetailViewController.m
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "EventDetailViewController.h"
#import "Constants.h"
#import "TrackEventListViewControllers.h"

@interface EventDetailViewController (){
    
    
    TrackEventListViewControllers* trckEventContrlr;
}


@property(assign,nonatomic)BOOL isEventSavedBefore;
@property(strong,nonatomic)IBOutlet UILabel *eventName;
@property(strong,nonatomic)IBOutlet UILabel *eventAddress;
@property(strong,nonatomic)IBOutlet UILabel *eventType;
@property(strong,nonatomic)IBOutlet UILabel *eventDate;
@property(strong,nonatomic)IBOutlet UIImageView *eventImage;

-(void)fromLeftToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

-(void)fromRightToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.eventName.text=self.event.name;
    self.eventAddress.text=self.event.address;
    self.eventType.text=self.event.type;
    self.eventDate.text=self.event.date;
    
    self.eventImage.image=[UIImage imageNamed:self.event.mainImage];
    
    
    
    // swipe gestures
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(fromLeftToRightWithGestureRecognizer:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(fromRightToLeftWithGestureRecognizer:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swipeRight];
    [self.view addGestureRecognizer:swipeLeft];
    
}

  - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.eventImage.image=[UIImage imageNamed:self.event.mainImage];
}

-(IBAction)trackEventButtonClicked:(id)sender{
    NSMutableArray *trackingArray=[[[NSUserDefaults standardUserDefaults] arrayForKey:ktrackingobjects] mutableCopy];
    
    if (trackingArray==nil) {
        trackingArray =[[NSMutableArray alloc] init];
    }
    
    if ([trackingArray count] !=0)
    {
        
           for(NSDictionary *dic in trackingArray){
            
               if([dic objectForKey:keventID]== self.event.eventID){
                self.isEventSavedBefore=YES;
                   
                   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Event has been added already"
                                                                delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                   [alert show];
                   
                break;
                
            }
            
        }
    
    }
   
    if (!self.isEventSavedBefore) {
    [trackingArray addObject:[self.event toDictionary]];
        self.isEventSavedBefore=NO;
    }
    
      NSArray *tempArray=[NSArray arrayWithArray:trackingArray];
      [[NSUserDefaults standardUserDefaults] setValue:tempArray forKey:ktrackingobjects];
      [[NSUserDefaults standardUserDefaults] synchronize];

    


    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
