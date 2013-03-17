//
//  NSObject+BackgroundOperation.h
//
//  Created by Stephen Lind on 2/19/13.
//  This software is provided under the MIT License
//  http://opensource.org/licenses/MIT

/*
 The purpose of this category is to facilitate testing of threaded gui classes.
 In your threaded class, call performBackgroundOperation instead of dispatch_async.
 
 Then, in your test, you may call waitForBackgroundOperationsToFinish to block the test until
 all of the background tasks called with performBackgroundOperation have finished. 
 
 The original reason for this category was to deal with issues related to one 
 background operation calling another. Note that each object's operation count is separate,
 meaning that there is no "global" operation count.
 
*/

#import <Foundation/Foundation.h>

@interface NSObject (BackgroundOperation)
// This must be called from the main thread. It will perform the block threaded.
- (void)performBackgroundOperation:(void (^)(void))block;

// Use this (probably in a test) to block until the background operations have finished.
- (void)waitForBackgroundOperationsToFinish;
@end
