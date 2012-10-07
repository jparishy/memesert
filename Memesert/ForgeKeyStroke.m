//
//  ForgeKeyStroke.c
//  Memesert
//
//  Created by Julius Parishy on 10/7/12.
//  Copyright (c) 2012 jparishy. All rights reserved.
//

#import "ForgeKeyStroke.h"

void DCPostCommandAndKey(CGKeyCode key)
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    
    CGEventRef keyDown = CGEventCreateKeyboardEvent(source, key, TRUE);
    CGEventSetFlags(keyDown, kCGEventFlagMaskCommand);
    CGEventRef keyUp = CGEventCreateKeyboardEvent(source, key, FALSE);
    
    CGEventPost(kCGAnnotatedSessionEventTap, keyDown);
    CGEventPost(kCGAnnotatedSessionEventTap, keyUp);
    
    CFRelease(keyUp);
    CFRelease(keyDown);
    CFRelease(source);
}
