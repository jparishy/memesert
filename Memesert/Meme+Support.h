//
//  Meme+Support.h
//  Memesert
//
//  Created by Julius Parishy on 9/9/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import "Meme.h"

@class MSMemesertModel;
@class Keyword;

@interface Meme (Support)

+(NSArray *)memeSearchWithString:(NSString *)searchString model:(MSMemesertModel *)model;

+(BOOL)insertMemeWithKeyword:(NSString *)keyword value:(NSString *)value model:(MSMemesertModel *)model;
+(BOOL)populateBaseMemesInModel:(MSMemesertModel *)model;

@end
