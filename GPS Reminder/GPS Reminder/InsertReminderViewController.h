//
//  NewReminderViewController.h
//  GPS Reminder
//
//  Created by Jerry on 25/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InsertReminderViewController;

@protocol InsertReminderViewControllerDelegate
-(void)dismissController:(InsertReminderViewController *)insertReminderController;
@end

@interface InsertReminderViewController : UIViewController
@property (weak, nonatomic) id <InsertReminderViewControllerDelegate> delegate; 
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
