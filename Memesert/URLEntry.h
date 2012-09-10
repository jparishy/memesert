//
//  URLEntry.h
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meme;

@interface URLEntry : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Meme *meme;

@end
