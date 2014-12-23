//
//  ViewController.m
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "TrackEventListViewControllers.h"
#import "EventListViewController.h"

@interface LoginViewController ()

@property(nonatomic,weak)IBOutlet UITextField *usrName;
@property(nonatomic,weak)IBOutlet UITextField *pwd;
@property(nonatomic,weak)IBOutlet UIButton *loginButton;

-(IBAction)loginButtonPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//method used when login button is pressed
-(IBAction)loginButtonPressed:(id)sender{
    
    if ([self.usrName.text isEqual:@""] || [self.pwd.text isEqual:@""]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"User Credentials" message:@"Please enter username and password"
                                                     delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
    
    else{
    UINavigationController *nav =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                  instantiateViewControllerWithIdentifier:keventNavigation];
   
    NSMutableArray *trackingArray=[[[NSUserDefaults standardUserDefaults] arrayForKey:ktrackingobjects] mutableCopy];
    
    // if trckable items are not there show events list
    
    if ([trackingArray count] !=0) {
        
        TrackEventListViewControllers *trck= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                       instantiateViewControllerWithIdentifier:ktrackviewctrlr];
        
        
        EventListViewController *evnt=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                       instantiateViewControllerWithIdentifier:keventlstcntrlr];
        trck.delegate=evnt;
        
        [nav setViewControllers:@[evnt,trck] animated:YES];
        
     }
    
  [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


@end
