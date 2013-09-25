//
//  FacebookLikeView.h
//  Yardsellr
//
//  Created by Tom Brow on 5/9/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookLikeViewDelegate;

@interface FacebookLikeView : UIView

// A delegate
@property (unsafe_unretained) IBOutlet id<FacebookLikeViewDelegate> delegate;

// The URL to like. This and the following properties map directly to XFBML attributes
// described here: https://developers.facebook.com/docs/reference/plugins/like/
@property (strong, nonatomic) NSURL *href;

// The style of the Like button and like count. Options: 'standard', 'button_count', and 'box_count'.
// You are responsible for sizing your FacebookLikeView appropriately for the layout you choose.
@property (strong, nonatomic) NSString *layout;

// Specifies whether to display profile photos below the button ('standard' layout only)
@property (assign, nonatomic) BOOL showFaces;

// The verb to display on the button. Options: 'like', 'recommend' 
@property (strong, nonatomic) NSString *action;

// The font to display in the button. Options: 'arial', 'lucida grande', 'segoe ui', 'tahoma', 'trebuchet ms', 'verdana'
@property (strong, nonatomic) NSString *font;

// The color scheme for the like button. Options: 'light', 'dark'
@property (strong, nonatomic) NSString *colorScheme;

// A label for tracking referrals.
@property (strong, nonatomic) NSString *ref;

// Load/reload the content of the web view. You should call this after changing any of the above parameters,
// and whenever the user signs in or out of Facebook.
- (void)load;

@end

@protocol FacebookLikeViewDelegate <NSObject>

// Called when user taps Like button or "sign in" link when not logged in. Your implementation should present 
// the user with a Facebook login dialog using either the Facebook iOS SDK or a separate web view. Once login 
// is complete, you should refresh FacebookLikeView using -[FacebookLikeView load].
- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView;

@optional

// Called when the web view finishes rendering its XFBML content 
- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView;

// Called when the web view made a failed request or is redirected away from facebook.com
- (void)facebookLikeView:(FacebookLikeView *)aFacebookLikeView didFailLoadWithError:(NSError *)error;

// Called when the user likes a URL via this view
- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView;

// Called when the user unlikes a URL via this view
- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView;

@end
