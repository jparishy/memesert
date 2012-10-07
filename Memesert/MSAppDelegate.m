
//
//  MSAppDelegate.m
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import "MSAppDelegate.h"

#import "MSMemesertModel.h"
#import "Meme.h"
#import "Meme+Support.h"

#define KEY_CODE_x ((CGKeyCode)7)
#define KEY_CODE_c ((CGKeyCode)8)
#define KEY_CODE_v ((CGKeyCode)9)

// Hacky hack hack from StackOverflow
// A better method would be appreciated, altogether
// but I've yet to find another way to get the
// functionality I want.
void DCPostCommandAndKey(CGKeyCode key)
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    
    CGEventRef keyDown = CGEventCreateKeyboardEvent(source, key, TRUE);
    CGEventSetFlags(keyDown, kCGEventFlagMaskCommand);
    CGEventRef keyUp = CGEventCreateKeyboardEvent(source, key, FALSE);
    
    CGEventPost(kCGAnnotatedSessionEventTap, keyDown);
    CGEventPost(kCGAnnotatedSessionEventTap, keyUp);
    
    CFRelease(keyUp);
    CFRelease(keyDown);
    CFRelease(source);
}

@interface MSAppDelegate ()

@property (nonatomic, strong) NSRunningApplication *previousApplication;

@property (nonatomic, strong) MSMemesertModel *model;
@property (nonatomic, strong) NSArray *results;

-(void)updateKeywordSearchResults;
-(void)sendSimulatedKeystrokeEventsForString:(NSString *)string;

-(NSRunningApplication *)activeApplication;

@end

@implementation MSAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize inputTextField;
@synthesize resultsTableView;

@synthesize previousApplication;

@synthesize model;
@synthesize results;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRunningApplication *applicationBeforeLaunch = [self activeApplication];
    [applicationBeforeLaunch activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    
    model = [[MSMemesertModel alloc] init];
    self.model.managedObjectContext = self.managedObjectContext;
    
    [Meme populateBaseMemesInModel:self.model];
    
    self.results = [NSArray array];

    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {

        unsigned short keyCode = event.keyCode;
        
        __block MSAppDelegate *bself = self;
        
        unsigned short semicolonKeyCode = 0x29;
        if(keyCode == semicolonKeyCode && (event.modifierFlags & NSControlKeyMask) && (event.modifierFlags & NSCommandKeyMask))
        {
            bself.previousApplication = [bself activeApplication];
            
            bself.results = [NSArray array];
            bself.inputTextField.stringValue = @"";
            
            [NSApp activateIgnoringOtherApps:YES];
            [bself.window makeKeyAndOrderFront:bself];
        }
    }];
}

-(NSRunningApplication *)activeApplication
{
    NSArray *applications = [[NSWorkspace sharedWorkspace] runningApplications];
    for(NSRunningApplication *application in applications)
    {
        if(application.active && !(application == [NSRunningApplication currentApplication]))
        {
            return application;
        }
    }
    
    return nil;
}

-(void)updateKeywordSearchResults
{
    NSString *keywordSearchText = self.inputTextField.stringValue;
    NSArray *searchResults = [Meme memeSearchWithString:keywordSearchText model:self.model];
    
    self.results = [searchResults subarrayWithRange:NSMakeRange(0, MIN(5, searchResults.count))];
    
    [self.resultsTableView reloadData];
}

-(IBAction)sendMemesertionToPreviousApplication:(id)sender
{
    [self.window close];
    
    if(self.previousApplication)
    {
        if([self.previousApplication activateWithOptions:NSApplicationActivationPolicyRegular])
        {
            if(self.results.count > 0)
            {
                NSString *memeValue = [self.results[0] value];
                
                [self sendSimulatedKeystrokeEventsForString:memeValue];
            }
        }
        else
        {
            NSLog(@"Failed to activate previous application: %@", self.previousApplication.localizedName);
        }
    }
    else
    {
        // We can fail silently for now, me thinks...
    }
}

-(void)sendSimulatedKeystrokeEventsForString:(NSString *)string;
{
    NSString *output = [NSString stringWithFormat:@"%@ ", string];
    
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setData:[output dataUsingEncoding:NSUTF8StringEncoding] forType:NSPasteboardTypeString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        usleep(100000); // Why usleep is in microseconds? I am not sure.
        DCPostCommandAndKey(KEY_CODE_v);
    });
}

-(void)controlTextDidChange:(NSNotification *)obj
{
    [self updateKeywordSearchResults];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.results.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(self.results)
    {
        if(self.results.count > row)
        {
            Meme *meme = [self.results objectAtIndex:row];
            
            if([tableColumn.identifier isEqualToString:@"keyword"])
            {
                return meme.keyword;
            }
            else if([tableColumn.identifier isEqualToString:@"value"])
            {
                return meme.value;
            }
        }
    }
    
    return @"";
}

- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"Memesert"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Memesert" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Memesert.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSDictionary *storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:storeOptions error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
