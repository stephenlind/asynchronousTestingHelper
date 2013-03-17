//
//  WindowController.m
//  AsynchronousTesting
//
//  Created by Stephen Lind on 3/16/13.
//  This software is provided under the MIT License
//  http://opensource.org/licenses/MIT

#import "WindowController.h"
#import "NSObject+BackgroundOperation.h"

@interface WindowController ()

@end

@implementation WindowController

- (id)init {
    if (self = [super initWithWindowNibName:@"WindowController"]) {
        srand((unsigned)time(0));
    }
    return self;
}


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self loadAsync:nil];
}

- (void)refreshUi {
    //This also "takes time"
    [self performBackgroundOperation:^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress stopAnimation:nil];
            [self.finishedText setHidden:NO];
            [self.loadButton setEnabled:YES];
        });
    }];
}

- (IBAction)loadAsync:(id)sender {
    // "Load" for an indeterminate amount of time
    int secs = rand() % 5;
    
    [self.finishedText setHidden:YES];
    [self.loadButton setEnabled:NO];
    [self.progress startAnimation:nil];
    [self performBackgroundOperation:^{
        sleep(secs);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshUi];
        });
    }];
}

@end
