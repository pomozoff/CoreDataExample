//
//  CDECenterViewController.m
//  CoreDataExample
//
//  Created by Антон on 13.05.14.
//  Copyright (c) 2014 Akademon Ltd. All rights reserved.
//

#import "CDECenterViewController.h"
#import "CDECoreData.h"

@interface CDECenterViewController ()

@end

@implementation CDECenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Center: setup fetch result controller");
        [CDECoreData.sharedInstance performWithDocument:^(UIManagedDocument *document) {
            NSArray *array = [self setupFetchRequestController];
            for (id element in array) {
                NSLog(@"Center: %@", element);
            }
        }];
    });
}

#pragma mark - Private

- (NSArray *)setupFetchRequestController {
    return @[@"222"];
}

@end
