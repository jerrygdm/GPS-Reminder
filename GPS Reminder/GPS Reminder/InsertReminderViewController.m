	//
//  NewReminderViewController.m
//  GPS Reminder
//
//  Created by Jerry on 25/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InsertReminderViewController.h"

#import "ActionViewController.h"

@interface InsertReminderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *insertTableView;
@property (strong, nonatomic) ActionViewController *actionViewController;

-(IBAction)doneButtonTapped:(id)sender;

@end

@implementation InsertReminderViewController
@synthesize delegate;
@synthesize insertTableView;
@synthesize actionViewController;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.actionViewController = nil;
	self.managedObjectContext = nil;
	self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private methods
-(IBAction)doneButtonTapped:(id)sender
{
	[self.delegate dismissController:self];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
	
	cell.textLabel.text = @"Prova";
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.actionViewController) {
	        self.actionViewController = [[ActionViewController alloc] initWithNibName:@"ActionViewController_iPhone" bundle:nil];
	    }
    } else {
		if (!self.actionViewController) {
	        self.actionViewController = [[ActionViewController alloc] initWithNibName:@"ActionViewController_iPad" bundle:nil];
	    }
    }
	self.actionViewController.managedObjectContext = self.managedObjectContext;
	
	[self.navigationController pushViewController:self.actionViewController animated:YES];
	[self.insertTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
