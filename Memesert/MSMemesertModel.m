//
//  MSMemesertModel.m
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import "MSMemesertModel.h"

@implementation MSMemesertModel

@synthesize managedObjectContext;

-(NSArray *)managedObjectsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(error != nil)
    {
        NSLog(@"Request failed.");
        return nil;
    }
    
    return results;
}

-(NSArray *)managedObjectsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate
{
    return [self managedObjectsForEntityName:entityName predicate:predicate sortDescriptors:nil];
}

@end
