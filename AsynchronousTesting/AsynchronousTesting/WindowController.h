//
//  WindowController.h
//  AsynchronousTesting
//
//  Created by Stephen Lind on 3/16/13.
//  This software is provided under the MIT License
//  http://opensource.org/licenses/MIT

#import <Cocoa/Cocoa.h>

@interface WindowController : NSWindowController
@property IBOutlet NSProgressIndicator *progress;
@property IBOutlet NSTextField *finishedText;
@property IBOutlet NSButton *loadButton;

- (IBAction)loadAsync:(id)sender;
@end
