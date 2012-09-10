//
//  Meme.h
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Keyword, URLEntry;

@interface Meme : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *urlEntries;
@property (nonatomic, retain) NSSet *keywords;
@end

@interface Meme (CoreDataGeneratedAccessors)

- (void)addUrlEntriesObject:(URLEntry *)value;
- (void)removeUrlEntriesObject:(URLEntry *)value;
- (void)addUrlEntries:(NSSet *)values;
- (void)removeUrlEntries:(NSSet *)values;

- (void)addKeywordsObject:(Keyword *)value;
- (void)removeKeywordsObject:(Keyword *)value;
- (void)addKeywords:(NSSet *)values;
- (void)removeKeywords:(NSSet *)values;

@end
