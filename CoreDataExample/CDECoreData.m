//
//  CDECoreData.m
//  VidimoPlayer
//
//  Created by Антон on 22.03.14.
//  Copyright (c) 2014 Akademon Ltd. All rights reserved.
//

@import CoreData;

#import "CDECoreData.h"
#import "CDEManagedDocument.h"

#ifdef TEST
static NSString * const DatabaseName = @"Tests.sqlite";
#else
static NSString * const DatabaseName = @"Database.sqlite";
#endif

@interface CDECoreData()

@property (nonatomic, strong) CDEManagedDocument *document;
@property (nonatomic, strong) NSMutableArray *delayedBlocks;
@property (atomic, assign) BOOL isDocumentBusy;

@end

@implementation CDECoreData

#pragma mark - Public

+ (instancetype)sharedInstance {
    __strong static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)performWithDocument:(OnDocumentReady)onDocumentReady {
    void (^OnDocumentDidCreate)(BOOL) = ^(BOOL success) {
        if (success) {
            NSLog(@"Core Data: document created");
        } else {
            NSLog(@"Core Data: error creating document");
        }
    };
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        if (success) {
            NSLog(@"Core Data: document opened");
        } else {
            NSLog(@"Core Data: error opening document");
        }
    };
    
    if (self.isDocumentBusy) {
        NSLog(@"Core Data: document is busy");
        NSLog(@"Core Data: add block to delayed run: %@", onDocumentReady);
        [self.delayedBlocks addObject:[onDocumentReady copy]];
    } else if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        self.isDocumentBusy = YES;
        NSLog(@"Core Data: document not found");
        NSLog(@"Core Data: add block to delayed run: %@", onDocumentReady);
        [self.delayedBlocks addObject:[onDocumentReady copy]];
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:OnDocumentDidCreate];
        NSLog(@"Core Data: create leaving");
    } else if (self.document.documentState == UIDocumentStateClosed) {
        self.isDocumentBusy = YES;
        NSLog(@"Core Data: document is closed");
        NSLog(@"Core Data: add block to delayed run: %@", onDocumentReady);
        [self.delayedBlocks addObject:[onDocumentReady copy]];
        [self.document openWithCompletionHandler:OnDocumentDidLoad];
        NSLog(@"Core Data: open leaving");
    } else if (self.document.documentState == UIDocumentStateNormal) {
        onDocumentReady(self.document);
    }
}

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        // Set our document up for automatic migrations
        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption : @YES,
                                  NSInferMappingModelAutomaticallyOption       : @YES
                                  };
        self.document.persistentStoreOptions = options;
        
        // Register for notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentStateChanged:)
                                                     name:UIDocumentStateChangedNotification
                                                   object:self.document];
    }
    
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDocumentStateChangedNotification
                                                  object:self.document];
}

#pragma mark - Properties

- (CDEManagedDocument *)document {
    if (!_document) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:DatabaseName];
        _document = [[CDEManagedDocument alloc] initWithFileURL:url];
    }
    return _document;
}
- (NSMutableArray *)delayedBlocks {
    if (!_delayedBlocks) {
        _delayedBlocks = [[NSMutableArray alloc] init];
    }
    return _delayedBlocks;
}

#pragma mark - Private

- (void)documentStateChanged:(NSNotification *)notification {
    NSLog(@"Core Data: Document state has changed: %@", self.document);
    self.isDocumentBusy = NO;
    if (self.document.documentState == UIDocumentStateNormal) {
        while (self.delayedBlocks.count > 0) {
            OnDocumentReady block = self.delayedBlocks.firstObject;
            NSLog(@"Core Data: execute delayed block: %@", block);
            block(self.document);
            [self.delayedBlocks removeObjectAtIndex:0];
        }
    }
}

@end
