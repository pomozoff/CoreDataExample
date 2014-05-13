//
//  CDEManagedDocument.m
//  VidimoPlayer
//
//  Created by Антон on 22.03.14.
//  Copyright (c) 2014 Akademon Ltd. All rights reserved.
//

#import "CDEManagedDocument.h"

@implementation CDEManagedDocument

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSLog(@"Managed Document: Auto-Saving Document");
    return [super contentsForType:typeName error:outError];
}
- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {
    NSLog(@"Managed Document: Error: %@ userInfo=%@", error.localizedDescription, error.userInfo);
    [super handleError:error userInteractionPermitted:userInteractionPermitted];
}

@end
