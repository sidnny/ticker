//
//  AppDelegate.m
//  ticker
//
//  Created by Soraya Dib on 3/3/14.
//  Copyright (c) 2014 sidnny. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define coinbaseBuyURL [NSURL URLWithString:@"https://coinbase.com/api/v1/prices/buy"]

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"applicationDidFinishLaunching");
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval: 60.0
                                                        target: self
                                                      selector: @selector(fetchDataTimer:)
                                                      userInfo: nil
                                                       repeats: YES];
    [myTimer fire];

}


- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ticker_icon" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ticker_icon_h" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    [statusItem setMenu:statusMenu];
//    [statusItem setToolTip:@"You do not need this..."];
    [statusItem setHighlightMode:YES];
    
}
- (void)fetchDataTimer:(NSTimer*) t {
    NSLog(@"fetchDataTimer");
    [self fetchData];
}

- (void)fetchData {
    dispatch_async(kBgQueue, ^{
        NSData* buyData = [NSData dataWithContentsOfURL:
                           coinbaseBuyURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:buyData waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    
    NSError *error;
    NSMutableDictionary *buyPrice = [NSJSONSerialization
                                     JSONObjectWithData:responseData
                                     options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                     error:&error];
    
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSString *title = [NSString stringWithFormat: @"Buy: %@ %@", buyPrice[@"total"][@"currency"], buyPrice[@"total"][@"amount"]];
        [statusItem setTitle:title];
        NSLog(@"----");
        NSLog(@"buyPrice subtotal: %@ %@", buyPrice[@"subtotal"][@"currency"], buyPrice[@"subtotal"][@"amount"] );
        NSLog(@"buyPrice total: %@ %@", buyPrice[@"total"][@"currency"], buyPrice[@"total"][@"amount"] );
        NSLog(@"----");
    }
}


- (IBAction)fetch:(id)sender {
    NSLog(@"received a fetch: request");

    [self fetchData];
}


@end
