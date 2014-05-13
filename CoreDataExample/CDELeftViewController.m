//
//  CDELeftViewController.m
//  CoreDataExample
//
//  Created by Антон on 13.05.14.
//  Copyright (c) 2014 Akademon Ltd. All rights reserved.
//

#import "CDELeftViewController.h"
#import "CDECoreData.h"

@interface CDELeftViewController ()

@end

@implementation CDELeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Left: makeDefaults");
        [CDECoreData.sharedInstance performWithDocument:^(UIManagedDocument *document) {
            NSArray *array = [self makeDefaults:document.managedObjectContext];
            for (id element in array) {
                NSLog(@"Left: %@", element);
            }
        }];
    });
}

#pragma mark - Private

- (NSArray *)makeDefaults:(NSManagedObjectContext *)context {
    return @[@"111"];
}

@end
