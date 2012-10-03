//
//  MSAppDelegate.h
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MSAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) IBOutlet NSTextField *inputTextField;
@property (nonatomic, strong) IBOutlet NSTableView *resultsTableView;

- (IBAction)saveAction:(id)sender;
- (IBAction)sendMemesertionToPreviousApplication:(id)sender;

@end
