//
//  Meme+Support.m
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import "Meme+Support.h"

#import "MSMemesertModel.h"

@implementation Meme (Support)

+(NSArray *)memeSearchWithString:(NSString *)searchString model:(MSMemesertModel *)model
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"keyword contains %@", searchString];
    NSArray *results = [model managedObjectsForEntityName:@"Meme" predicate:searchPredicate];
    
    return results;
}

+(BOOL)insertMemeWithKeyword:(NSString *)keyword value:(NSString *)value model:(MSMemesertModel *)model
{
    Meme *meme = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"keyword = %@ OR value = %@", keyword, value];
    NSArray *results = [model managedObjectsForEntityName:@"Meme" predicate:predicate];
    if(results && results.count > 0)
    {
        meme = results[0];
    }
    else
    {
        meme = [NSEntityDescription insertNewObjectForEntityForName:@"Meme" inManagedObjectContext:model.managedObjectContext];
    }
    
    if(meme)
    {
        meme.keyword = keyword;
        meme.value = value;
        
        return YES;
    }
    
    return NO;
}

+(BOOL)populateBaseMemesInModel:(MSMemesertModel *)model
{
    NSString *baseMemesFilename = @"BaseMemes.plist";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:baseMemesFilename ofType:nil];
    NSDictionary *memes = [NSDictionary dictionaryWithContentsOfFile:path];
    
    BOOL success = YES;
    
    for(NSString *keyword in memes)
    {
        NSString *value = [memes objectForKey:keyword];
        
        BOOL succeeded = [Meme insertMemeWithKeyword:keyword value:value model:model];
        success = success && succeeded;
    }
    
    if(success)
    {
        NSError *error = nil;
        [model.managedObjectContext save:&error];
        
        if(error)
        {
            NSLog(@"CoreData save error occurred.");
            NSLog(@"Error: %@", error.localizedDescription);
            
            return NO;
        }
    }
    
    return YES;
}

@end
