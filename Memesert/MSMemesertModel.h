//
//  MSMemesertModel.h
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSMemesertModel : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(NSArray *)managedObjectsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate  sortDescriptors:(NSArray *)sortDescriptors;

-(NSArray *)managedObjectsForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;

@end
