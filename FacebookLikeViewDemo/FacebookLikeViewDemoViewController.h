//
//  LikeButtonDemoViewController.h
//  LikeButtonDemo
//
//  Created by Tom Brow on 6/27/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FacebookLikeView.h"

@interface FacebookLikeViewDemoViewController : UIViewController {
    Facebook *_facebook;
}

@property (nonatomic, retain) IBOutlet FacebookLikeView *facebookLikeView;

@end
