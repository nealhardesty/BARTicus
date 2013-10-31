//
//  BarticusViewController.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "BarticusViewController.h"
#import "AlertsViewController.h"
#import "Model/BARTApi.h"

@interface BarticusViewController ()
@property (nonatomic, strong) BARTApi *bartapi;
@property (nonatomic, strong) Station *closestStation;
@property (nonatomic, strong) Schedule *schedule;
@property (nonatomic, strong) NSArray *currentTrainsGroupedByDestinationSortedByTime;
@property (nonatomic, strong) NSTimer *scheduleRefreshTimer;
@property (nonatomic, strong) Alerts *alerts;
@end

@implementation BarticusViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)hasTrains {
    return (self.currentTrainsGroupedByDestinationSortedByTime && [self.currentTrainsGroupedByDestinationSortedByTime count] > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self hasTrains]) {
        return [self.currentTrainsGroupedByDestinationSortedByTime count];
    } else {
        return 1; // So we can show an error message
    }
}

#define CELL_IDENTIFIER @"Schedule Cell"
#define CELL_IDENTIFIER_NO_SCHEDULE @"Schedule Cell No Schedule"
#define CELL_IDENTIFIER_REFRESHING @"Schedule Cell Refreshing"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self hasTrains]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        }
        
        NSMutableAttributedString *detail = [[NSMutableAttributedString alloc] init];
        NSAttributedString *commaString = [[NSAttributedString alloc] initWithString:@","];
        
        NSArray *trains = [self.currentTrainsGroupedByDestinationSortedByTime objectAtIndex:indexPath.item];
        BOOL first=YES;
        for(Train *train in trains) {
            Station *destinationStation = self.bartapi.stationsByAbbreviation[train.destination];
            
            cell.textLabel.text = destinationStation.name;
            
            if(first) {
                first=NO;
            } else {
                [detail appendAttributedString:commaString];
            }
            [detail appendAttributedString:[self formatMinutes:train.minutes]];
        }
        [detail appendAttributedString:[[NSAttributedString alloc] initWithString:@" mins"]];
        
        [cell.detailTextLabel setAttributedText:detail];
        
        return cell;
    } else {
        UITableViewCell *cell;
        if(self.currentTrainsGroupedByDestinationSortedByTime) {
            cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_NO_SCHEDULE];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_NO_SCHEDULE];
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_REFRESHING];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_REFRESHING];
            }
        }
        return cell;
    }
}

- (NSAttributedString *)formatMinutes:(short)minutes {
    if(minutes == 0) {
        /*IFontDescriptor *fontDescriptor =
         [UIFontDescriptor preferredFontDescriptorWithTextStyle: UIFontTextStyleBody];
         UIFontDescriptor *boldFontDescriptor =
         [fontDescriptor fontDescriptorWithSymbolicTraits: UIFontDescriptorTraitBold];
         UIFont *boldFont = [UIFont fontWithDescriptor: boldFontDescriptor size: 0.0]; */
        //UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:18.0f];
        //NSDictionary *atStationAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor greenColor]};
        NSDictionary *atStationAttributes = @{NSForegroundColorAttributeName:[UIColor greenColor]};
        NSAttributedString *atStationFormat = [[NSAttributedString alloc] initWithString:@"at station" attributes:atStationAttributes];
        return atStationFormat;
    } else {
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%hd", minutes]];
    }
    
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.closestStation) {
        return [NSString stringWithFormat:@"%@\nDepartures",self.closestStation.name];
    } else {
        return @"Loading Departures...";
    }
}
 */

- (BARTApi *)bartapi {
    if(!_bartapi) {
        _bartapi = [[BARTApi alloc] init];
    }
    
    return _bartapi;
}

// Triggered by the refresh indicator turning on/off
- (IBAction)refreshAction:(UIRefreshControl *)sender {
    //NSLog(@"got refresh action");
    if(sender.refreshing) {
        [self doRefresh];
    }
}

// Called every 60 seconds
- (void)onAutoRefreshTick:(NSTimer *)timer {
    if(self.schedule) {
        [self.schedule decrementSchedule];
        self.currentTrainsGroupedByDestinationSortedByTime = [self.schedule getTrainsGroupedByDestinationSortedByTime];
        //NSLog(@"decrementing schedule");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)startAutoRefreshTimer {
    //NSLog(@"startRefreshTimer");
    // Start the timer for automatic decrementing:
    if(!self.scheduleRefreshTimer) {
        self.scheduleRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(onAutoRefreshTick:) userInfo:nil repeats:YES];
    }
}

- (void)stopAutoRefreshTimer {
    //NSLog(@"stopRefreshTimer");
    if(self.scheduleRefreshTimer) {
        // Stop the timer
        [self.scheduleRefreshTimer invalidate];
        self.scheduleRefreshTimer = nil;
    }
}

// This actually does the API refresh
- (void)doRefresh
{
    [self stopAutoRefreshTimer];
    
    //NSLog(@"got refresh");
    dispatch_async(dispatch_queue_create("Reload Data", NULL), ^{
        
        // First, find the closest station
        self.closestStation = [self.bartapi findClosestStation];
        //NSLog(@"closest: %@", closest);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = self.closestStation.name;
            
        });
        

        // Now load it's schedule
        self.schedule = [self.bartapi getScheduleForStation:self.closestStation];
        //NSLog(@"schedule: %@", schedule);
        
        self.currentTrainsGroupedByDestinationSortedByTime = [self.schedule getTrainsGroupedByDestinationSortedByTime];
        
        //NSLog(@"station info: %@", [self.bartapi.stationsByAbbreviation objectForKey:closest.abbreviation]);

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self startAutoRefreshTimer];
            
            NSDate *now = [[NSDate alloc] init];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"'Last Updated' h:mm:ss a"];
            NSString *lastUpdated = [format stringFromDate:now];
            // UIBarButtonItem *toolbarLabel = [[UIBarButtonItem alloc] initWithTitle:lastUpdated style:UIBarButtonItemStylePlain target:self action:@selector(showAndStartRefresh)];
            UIBarButtonItem *toolbarLabel = [[UIBarButtonItem alloc] initWithTitle:lastUpdated style:UIBarButtonItemStylePlain target:nil action:nil];
            toolbarLabel.enabled = NO;
            UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [self.navigationController.toolbar setItems:[NSArray arrayWithObjects:flexiSpace, toolbarLabel, flexiSpace, nil] animated:YES];

            [self hideRefresh];
            
            [self.tableView reloadData];
            
        });
        
        // And finally, check if there are any service announcements/alerts
        self.alerts = [self.bartapi getAlerts];
        //NSLog(@"alerts: %@", self.alerts);
        if(!self.alerts.infoOnly) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *warningImage = [UIImage imageNamed:@"warning.png"];
                UIBarButtonItem *alertButtonItem=[[UIBarButtonItem alloc] initWithImage:warningImage style:UIBarButtonItemStyleBordered target:self action:@selector(didClickAlertButton)];
                [self.navigationItem setRightBarButtonItem:alertButtonItem];
                
            });
        }
        

    });
    
}

#define ALERTS_SEGUE_IDENT @"Alerts Segue"
- (void)didClickAlertButton {
    [self performSegueWithIdentifier:ALERTS_SEGUE_IDENT sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:ALERTS_SEGUE_IDENT]) {
        //UIViewController *controller = segue.destinationViewController;
        //NSLog(@"%@", controller);
        AlertsViewController *controller = (AlertsViewController *)segue.destinationViewController;
        controller.alerts = self.alerts;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    [self showAndStartRefresh];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshAction:)
                  forControlEvents:UIControlEventValueChanged];
    
}
                          
- (void)testTheTimer:(NSTimer *)timer
{
    NSLog(@"testing the timer...");
}

// Called from viewDidLoad and as callback for clicking refresh.
- (void)showAndStartRefresh
{
    [self showRefresh];
    [self doRefresh];
}


// Force the refresh indicator on to the screen, and animate it
- (void)showRefresh {
    [self.refreshControl beginRefreshing];
    //CGPoint newOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    //[self.tableView setContentOffset:newOffset animated:YES];
    
}

// Stop the animation on the refresh indicator, and hide it
- (void) hideRefresh {
    [self.refreshControl endRefreshing];
}

@end
