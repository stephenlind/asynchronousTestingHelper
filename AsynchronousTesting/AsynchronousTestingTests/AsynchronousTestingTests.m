//
//  AsynchronousTestingTests.m
//
//  Created by Stephen Lind on 3/16/13.
//  Copyright (c) 2013 Stephen Lind.
//
// This software is provided under the MIT License
// http://opensource.org/licenses/MIT

#import "AsynchronousTestingTests.h"
#import "NSObject+BackgroundOperation.h"
#import "WindowController.h"

@implementation AsynchronousTestingTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSingleOperation
{
    __block BOOL returned = NO;
    [self performBackgroundOperation:^{
        sleep(1);
        returned = YES;
    }];
    
    STAssertFalse(returned, @"before the block, the operation should not have executed, returned should be false.");
    [self waitForBackgroundOperationsToFinish];
    STAssertTrue(returned, @"After the wait, the operation should have completed");
}

- (void)testNestedOperation {
    __block BOOL returned = NO;
    [self performBackgroundOperation:^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performBackgroundOperation:^{
                sleep(1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    returned = YES;
                });
            }];
        });
    }];
    
    STAssertFalse(returned, @"before the block, this test should fail");
    [self waitForBackgroundOperationsToFinish];
    STAssertTrue(returned, @"should have returned yes, otherwise we didn't wait");
}

- (void)testWindowController {
    WindowController *wc = [[WindowController alloc] init];
    [wc showWindow:nil];
    
    //Calling showWindow should auto-execute the load.
    STAssertTrue([wc.finishedText isHidden], @"We just started loading, the text should be hidden");
    
    [wc waitForBackgroundOperationsToFinish];
    STAssertFalse([wc.finishedText isHidden], @"After waiting for the load, the finished text should no longer be hidden");
    STAssertFalse([wc.loadButton isHidden], @"After waiting for the load, the load button should no longer be hidden");
    
    //Test the ui action
    [wc.loadButton performClick:nil];
     STAssertTrue([wc.finishedText isHidden], @"We just started loading, the text should be hidden");
    STAssertFalse([wc.loadButton isEnabled], @"During the load, the load button should be disabled");
     
     [wc waitForBackgroundOperationsToFinish];
     STAssertFalse([wc.finishedText isHidden], @"After waiting for the load, the finished text should no longer be hidden");
     STAssertTrue([wc.loadButton isEnabled], @"Load is finished, the load button should be enabled");
}

@end
