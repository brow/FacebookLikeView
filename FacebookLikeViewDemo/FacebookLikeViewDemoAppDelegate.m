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
    
    // This hack makes UIWebView send a user-agent string that looks like desktop Safari rather than Mobile Safari.
    // We need this because Facebook now renders a differently-sized Like button in mobile browsers, breaking 
    // FacebookLikeView's appearance. This hack may cause problems if you also use UIWebView for something else.
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_1) AppleWebKit/534.48.3 (KHTML, like Gecko) Version/5.1 Safari/534.48.3", 
                                @"UserAgent",
                                nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
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
