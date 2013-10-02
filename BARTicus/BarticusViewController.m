//
//  BarticusViewController.m
//  BARTicus
//
//  Created by Neal Hardesty on 10/1/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import "BarticusViewController.h"
#import "Model/BARTApi.h"

@interface BarticusViewController ()
@property (nonatomic, strong) BARTApi *bartapi;
@property (nonatomic, strong) Station *closestStation;
@property (nonatomic, strong) NSArray *currentTrainsGroupedByDestinationSortedByTime;
@end

@implementation BarticusViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentTrainsGroupedByDestinationSortedByTime count];
}

#define CELL_IDENTIFIER @"Schedule Cell"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    NSArray *trains = [self.currentTrainsGroupedByDestinationSortedByTime objectAtIndex:indexPath.item];
    BOOL first=YES;
    for(Train *train in trains) {
        Station *destinationStation = self.bartapi.stationsByAbbreviation[train.destination];
        cell.textLabel.text = destinationStation.name;
        if(first) {
            first=NO;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", train.minutes];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%hd", cell.detailTextLabel.text, train.minutes];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@\nDepartures",self.closestStation.name];
}

- (BARTApi *)bartapi {
    if(!_bartapi) {
        _bartapi = [[BARTApi alloc] init];
    }
    
    return _bartapi;
}

// Triggered by the refresh indicator turning on/off
- (IBAction)refreshAction:(UIRefreshControl *)sender {
    NSLog(@"got refresh action");
    if(sender.refreshing) {
        [self doRefresh];
    }
}

// This actually does the API refresh
- (void)doRefresh
{
    NSLog(@"got refresh");
    dispatch_async(dispatch_queue_create("testing", NULL), ^{
        self.closestStation = [self.bartapi findClosestStation];
        //NSLog(@"closest: %@", closest);

        Schedule *schedule = [self.bartapi getScheduleForStation:self.closestStation];
        //NSLog(@"schedule: %@", schedule);
        
        self.currentTrainsGroupedByDestinationSortedByTime = [schedule getTrainsGroupedByDestinationSortedByTime];
        
        //NSLog(@"station info: %@", [self.bartapi.stationsByAbbreviation objectForKey:closest.abbreviation]);
        
        //[NSThread sleepForTimeInterval:5];
        [self hideRefresh];
        
        [self.tableView reloadData];
    });
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showRefresh];
    [self doRefresh];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshAction:)
                  forControlEvents:UIControlEventValueChanged];
}


// Force the refresh indicator on to the screen, and animate it
- (void)showRefresh {
    [self.refreshControl beginRefreshing];
    CGPoint newOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.tableView setContentOffset:newOffset
                            animated:YES];
    
}

// Stop the animation on the refresh indicator, and hide it
- (void) hideRefresh {
    [self.refreshControl endRefreshing];
}

@end
