//
//  CDEViewController.m
//  CoreDataExample
//
//  Created by Антон on 13.05.14.
//  Copyright (c) 2014 Akademon Ltd. All rights reserved.
//

#import "CDEViewController.h"
#import "CDELeftViewController.h"
#import "CDECenterViewController.h"

@interface CDEViewController ()

@end

@implementation CDEViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIViewController *left = [[CDELeftViewController alloc] init];
    UIViewController *center = [[CDECenterViewController alloc] init];
    [left.view description];
    [center.view description];
    
}

@end
