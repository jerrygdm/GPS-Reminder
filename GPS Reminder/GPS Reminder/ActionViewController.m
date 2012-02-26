//
//  ActionViewController.m
//  GPS Reminder
//
//  Created by Jerry on 25/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *actionScrollView;
@property (weak, nonatomic) IBOutlet UITableView *actionTableView;
@property (weak, nonatomic) IBOutlet UITextField *actionTextField;
@property (strong, nonatomic) NSArray *actionArray;

@property (strong, nonatomic) NSString *actionString;

-(void) loadData;
-(void)actionButtonPressed:(id)sender;

@end

@implementation ActionViewController
@synthesize actionScrollView;
@synthesize actionTableView;
@synthesize actionTextField;
@synthesize actionArray;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize actionString;

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
	if (!self.actionArray) {
		self.actionArray = [[NSMutableArray alloc] init];
	}
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionButtonPressed:)];
	self.navigationItem.rightBarButtonItem = saveButton;
		
	
	NSManagedObjectContext *context = [self managedObjectContext];
	
	//Creiamo un'istanza di NSManagedObject per l'Entità che ci interessa
	NSManagedObject *contatto = [NSEntityDescription
								 insertNewObjectForEntityForName:@"Reminder" 
								 inManagedObjectContext:context];
	
	//Usando il Key-Value Coding inseriamo i dati presi dall'interfaccia nell'istanza dell'Entità appena creata
	[contatto setValue:@"Prova in action" forKey:@"name"];
	
	//Effettuiamo il salvataggio gestendo eventuali errori
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
	}
	
//	NSString *string;
//	for (int i = 0; i<10; i++) {
//		string = [NSString stringWithFormat:@"Azione %d",i];
//		[self.actionArray addObject:string];
//	}
}

-(void)viewDidAppear:(BOOL)animated	
{
	[self loadData];
	[self.actionTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.managedObjectContext = nil;
	self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private methods

-(void)loadData
{
	NSManagedObjectContext *context = [self managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminder" inManagedObjectContext:context];
	[request setEntity:entity];
	
	self.actionArray = [context executeFetchRequest:request error:nil];
}

-(void)actionButtonPressed:(id)sender
{
	if (![self.actionTextField.text isEqualToString:@""]) {
		self.actionString = self.actionTextField.text;
	}
	if (self.actionString) {
		NSManagedObjectContext *context = [self managedObjectContext];
		NSManagedObject *actionSel = [NSEntityDescription
									 insertNewObjectForEntityForName:@"Reminder" 
									 inManagedObjectContext:context];
		
		[actionSel setValue:self.actionString forKey:@"name"];
	
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
		}
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Action not selected" message:@"You have to select an action!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
	}
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	return [self.actionArray count];
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
	
	NSManagedObject *model = [self.actionArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [model valueForKey:@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!actionString)
	{
		actionString = [NSString stringWithFormat:@"Action: %d",indexPath.row];
	}
	[self.actionTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	// modify a custom contentsize and offset
	[self.actionScrollView setContentSize:CGSizeMake(320.0, 500.0)];
	CGPoint point = CGPointMake(0.0, 84.0);
	[self.actionScrollView setContentOffset:point animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	if (textField.text != @"") {
		return YES;
	}
	return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	// restore the detault contentsize and offset
	[self.actionScrollView setContentSize:CGSizeMake(320.0, 416.0)];
	CGPoint point = CGPointMake(0.0, 0.0);
	[self.actionScrollView setContentOffset:point animated:YES];
	self.actionString = textField.text;
}
@end
