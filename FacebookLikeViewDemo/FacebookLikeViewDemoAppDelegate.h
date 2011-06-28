//
//  LikeButtonDemoAppDelegate.h
//  LikeButtonDemo
//
//  Created by Tom Brow on 6/27/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FacebookLikeViewDemoViewController;

@interface FacebookLikeViewDemoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FacebookLikeViewDemoViewController *viewController;

@end
