//
//  Keyword+Support.h
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import "Keyword.h"

@class MSMemesertModel;

@interface Keyword (Support)

+(Keyword *)keywordForValue:(NSString *)value model:(MSMemesertModel *)model;
-(NSArray *)urlEntriesInModel:(MSMemesertModel *)model;

@end
