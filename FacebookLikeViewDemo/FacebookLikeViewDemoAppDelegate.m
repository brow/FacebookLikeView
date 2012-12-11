//
//  LikeButtonDemoAppDelegate.m
//  LikeButtonDemo
//
//  Created by Tom Brow on 6/27/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import "FacebookLikeViewDemoAppDelegate.h"
#import "FacebookLikeViewDemoViewController.h"

#define SavedHTTPCookiesKey @"SavedHTTPCookies"

@implementation FacebookLikeViewDemoAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Restore cookies
    NSData *cookiesData = [[NSUserDefaults standardUserDefaults] objectForKey:SavedHTTPCookiesKey];
    if (cookiesData) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
        for (NSHTTPCookie *cookie in cookies)
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Save cookies
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData
                                              forKey:SavedHTTPCookiesKey];
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
