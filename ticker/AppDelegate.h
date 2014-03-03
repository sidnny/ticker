//
//  AppDelegate.h
//  ticker
//
//  Created by Soraya Dib on 3/3/14.
//  Copyright (c) 2014 sidnny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)fetch:(id)sender;

@property (weak) IBOutlet NSTextFieldCell *myLabel;
- (IBAction)displayBuyPrice:(id)sender;
@end
