//
//  LikeButtonDemoViewController.m
//  LikeButtonDemo
//
//  Created by Tom Brow on 6/27/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import "FacebookLikeViewDemoViewController.h"
#import "FBConnect.h"
#import "FacebookLikeView.h"

@interface FacebookLikeViewDemoViewController () <FacebookLikeViewDelegate, FBSessionDelegate>

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) IBOutlet FacebookLikeView *facebookLikeView;

@end

@implementation FacebookLikeViewDemoViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.facebook = [[Facebook alloc] initWithAppId:@"158575400878173" andDelegate:self];
    }
    return self;
}


#pragma mark FBSessionDelegate

- (void)fbDidLogin {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

- (void)fbDidLogout {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

#pragma mark FacebookLikeViewDelegate

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
    [self.facebook authorize:[NSArray array]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked"
                                                     message:@"You liked Yardsellr. Thanks!"
                                                    delegate:self 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unliked"
                                                     message:@"You unliked Yardsellr. Where's the love?"
                                                    delegate:self 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.facebookLikeView.href = [NSURL URLWithString:@"http://www.yardsellr.com"];
    self.facebookLikeView.layout = @"button_count";
    self.facebookLikeView.showFaces = NO;
    self.facebookLikeView.alpha = 0;
    [self.facebookLikeView load];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.facebookLikeView = nil;
}

@end
