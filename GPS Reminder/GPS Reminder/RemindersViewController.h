//
//  MasterViewController.h
//  My Personal Helper
//
//  Created by Jerry on 25/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class InsertReminderViewController;

@interface RemindersViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *remindersTableView;
@property (strong, nonatomic) InsertReminderViewController *insertReminderController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
