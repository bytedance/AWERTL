//
//  AWERTLIndexTableViewController.m
//  AWERTL_Example
//
//  Created by ByteDance on 2019/2/21.
//  Copyright © 2019 ByteDance. All rights reserved.
//

#import "AWERTLIndexTableViewController.h"
#import "AWERTLManager.h"

@interface AWERTLIndexTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *enableRTLSwitch;

@end

@implementation AWERTLIndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)enableRTLSwitchChanged:(UISwitch *)sender {
    [AWERTLManager sharedInstance].enableRTL = sender.isOn;
}

@end
