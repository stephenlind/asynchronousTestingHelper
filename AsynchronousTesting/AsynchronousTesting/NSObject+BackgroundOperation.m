//
//  NSObject+OperationBlocker.m
//  Draft Control
//
//  Created by Stephen Lind on 2/19/13.
//  This software is provided under the MIT License
//  http://opensource.org/licenses/MIT

#import "NSObject+BackgroundOperation.h"
#import <objc/runtime.h>

@interface NSObject()
@property (atomic, strong) NSNumber *operationCount;
@end

@implementation NSObject (BackgroundOperation)

- (void)endOperation {
    if (self.operationCount) {
        NSInteger oc = [self.operationCount integerValue];
        self.operationCount = [NSNumber numberWithInteger:oc - 1];
        //NSLog(@"end operation - count: %lu", oc - 1);
    }
}

- (void)beginOperation {
    NSInteger oc = [self.operationCount integerValue];
    self.operationCount = [NSNumber numberWithInteger:oc + 1];
    //NSLog(@"begin operation - count: %lu", oc + 1);
}

- (void)performBackgroundOperation:(void (^)(void))block {
    if (dispatch_get_current_queue() != dispatch_get_main_queue()) {
        [NSException raise:@"performBackgroundOperation non-main thread"
                    format:@"performBackgroundOperation can only be called from the main thread."];
        return;
    }
    
    [self beginOperation];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        block();
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endOperation];
        });
    });
}

- (void)waitForBackgroundOperationsToFinish {
    if (self.operationCount) {
        while ([self.operationCount integerValue] > 0)
        {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, YES);
        }
    }
}

//Associative Reference
static void * const kOperationCountKey = (void*)&kOperationCountKey;
- (void)setOperationCount:(NSNumber *)operationCount
{
    objc_setAssociatedObject(self, kOperationCountKey, operationCount, OBJC_ASSOCIATION_ASSIGN);
}

- (NSNumber*)operationCount
{
    // We depend on the fact that this returns nil if it is unset.
    return objc_getAssociatedObject(self, kOperationCountKey);
}

@end
