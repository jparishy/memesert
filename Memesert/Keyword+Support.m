//
//  Keyword+Support.m
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import "Keyword+Support.h"

#import "MSMemesertModel.h"

@implementation Keyword (Support)

+(Keyword *)keywordForValue:(NSString *)value model:(MSMemesertModel *)model
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value = %@", value];
    NSArray *results = [model managedObjectsForEntityName:@"Keyword" predicate:predicate];
    
    if(results && results.count > 0)
        return [results objectAtIndex:0];
    
    Keyword *createdKeyword = [NSEntityDescription insertNewObjectForEntityForName:@"Keyword" inManagedObjectContext:model.managedObjectContext];
    createdKeyword.value = value;
    
    return createdKeyword;
}

-(NSArray *)urlEntriesInModel:(MSMemesertModel *)model
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY meme.keywords = %@", self.value];
    return [model managedObjectsForEntityName:@"URLEntry" predicate:predicate];
}

@end
