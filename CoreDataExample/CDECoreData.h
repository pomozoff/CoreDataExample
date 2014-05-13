//
//  CDECoreData.h
//  VidimoPlayer
//
//  Created by Антон on 22.03.14.
//  Copyright (c) 2014 Akademon Ltd. All rights reserved.
//

@import Foundation;
@import CoreData;

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface CDECoreData : NSObject

//@property (nonatomic, weak) id<VPDataInitializer> dataInitializer;

+ (instancetype)sharedInstance;

- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end
