//
//  ForgeKeyStroke.h
//  Memesert
//
//  Created by Julius Parishy on 10/7/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import <Foundation/Foundation.h>

// Hacky hack hack from StackOverflow
// A better method would be appreciated, altogether
// but I've yet to find another way to get the
// functionality I want.

// Preferably I'd like to find a way to do this without
// resorting to using Carbon, but I'm not sure that it's
// entirely possible right now.

#define KEY_CODE_V ((CGKeyCode)9)

void DCPostCommandAndKey(CGKeyCode key);
