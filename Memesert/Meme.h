//
//  Meme.h
//  Memesert
//
//  Created by Julius Parishy on 10/3/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meme : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * keyword;

@end
