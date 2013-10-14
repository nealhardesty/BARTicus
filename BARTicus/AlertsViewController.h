//
//  AlertsViewController.h
//  BARTicus
//
//  Created by Neal Hardesty on 10/10/13.
//  Copyright (c) 2013 RoadWaffle Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model/Alerts.h"

@interface AlertsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *theText;
@property (weak, nonatomic) Alerts *alerts;
@end
