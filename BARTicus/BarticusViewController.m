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
@end

@implementation BarticusViewController

- (BARTApi *)bartapi {
    if(!_bartapi) {
        _bartapi = [[BARTApi alloc] init];
    }
    
    return _bartapi;
}

- (IBAction)refreshAction:(UIRefreshControl *)sender {
    NSLog(@"got refresh action");
    if(sender.refreshing) {
        [self doRefresh];
    }
}

- (void)doRefresh
{
    NSLog(@"got refresh");
    dispatch_async(dispatch_queue_create("testing", NULL), ^{
        Station *closest = [self.bartapi findClosestStation];
        NSLog(@"%@", closest);
        
        Schedule *schedule = [self.bartapi getScheduleForStation:closest];
        NSLog(@"%@", schedule);
        
        [NSThread sleepForTimeInterval:5];
        [self hideRefresh];
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

- (void)showRefresh {
    [self.refreshControl beginRefreshing];
    CGPoint newOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.tableView setContentOffset:newOffset
                            animated:YES];
    
}

- (void) hideRefresh {
    [self.refreshControl endRefreshing];
}

@end
