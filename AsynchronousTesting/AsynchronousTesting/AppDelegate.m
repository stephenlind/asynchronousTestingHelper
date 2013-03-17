//
//  AppDelegate.m
//  AsynchronousTesting
//
//  Created by Stephen Lind on 3/16/13.

// This software is provided under the MIT License
// http://opensource.org/licenses/MIT

#import "AppDelegate.h"
#import "WindowController.h"

@interface AppDelegate()
@property (strong) WindowController *wc;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.wc = [[WindowController alloc] init];
    [self.wc showWindow:nil];
}

@end
