//
//  LMNotiWindowController.m
//  IUEditor
//
//  Created by jd on 6/30/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMNotiManager.h"
#import "LMNotiDownloadWC.h"
#import "LMNotiMessageWC.h"

static NSString *downloadURL = @"http://server.iueditor.org/message.html";
static NSString *currentVersion = @"0.2";

@interface LMNotiManager ()

@end

@implementation LMNotiManager{
    LMNotiDownloadWC *downloadWC;
    NSMutableArray *messageWCs;
}

- (id)init{
    self = [super init];
    messageWCs  = [[NSMutableArray alloc] init];
    return self;
}

- (void)connectWithServer{
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // get json  fron server
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:downloadURL]];
    if (jsonData) {
        NSError *error;
        NSDictionary *message = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            JDErrorLog([error description],nil);
            return;
        }
        if (message) {
            NSArray *notis = message[@"Notis"];
            if (notis) {
                for (NSDictionary *noti in notis) {
                    NSString *notiID = noti[@"ID"];
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:notiID] == YES) {
                        continue;
                    }
                    else {
                        LMNotiMessageWC *wc = [[LMNotiMessageWC alloc] initWithWindowNibName:[LMNotiMessageWC class].className];
                        wc.idString = noti[@"ID"];
                        wc.date = noti[@"Date"];
                        wc.title = noti[@"Title"];
                        wc.content = noti[@"Content"];
                        [wc showWindow:self];
                        [messageWCs addObject:wc];
                        [[NSApp mainWindow] makeKeyAndOrderFront:wc.window];
                    }
                }
            }
            NSDictionary *newVersionDict = message[@"RecentVersion"];
            if (newVersionDict) {
                NSString *version = newVersionDict[@"Version"];
                if ([version isEqualToString:currentVersion] == NO) {
                    //new version
                    downloadWC = [[LMNotiDownloadWC alloc] initWithWindowNibName:[LMNotiDownloadWC class].className];
                    downloadWC.note = newVersionDict[@"Note"];
                    downloadWC.downloadURLString= newVersionDict[@"URL"];
                    [downloadWC showWindow:self];
                    [[NSApp mainWindow] makeKeyAndOrderFront:downloadWC.window];
                }
            }
        }
    }
}

@end
