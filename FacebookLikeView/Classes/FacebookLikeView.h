//
//  FacebookLikeView.h
//  Yardsellr
//
//  Created by Tom Brow on 5/9/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookLikeViewDelegate;


@interface FacebookLikeView : UIView {
    UIWebView *_webView;
}

// The URL to like
@property (retain) NSURL *href;

// The style of the like button and like count. Options: 'standard', 'button_count', and 'box_count'.
// You should size your FacebookLikeView to the dimensions the layout you choose; details here:
// https://developers.facebook.com/docs/reference/plugins/like/
@property (retain) NSString *layout;

// Specifies whether to display profile photos below the button (standard layout only)
@property (assign) BOOL showFaces;

// The verb to display on the button. Options: 'like', 'recommend' 
@property (retain) NSString *action;

// The font to display in the button. Options: 'arial', 'lucida grande', 'segoe ui', 'tahoma', 'trebuchet ms', 'verdana'
@property (retain) NSString *font;

// The color scheme for the like button. Options: 'light', 'dark'
@property (retain) NSString *colorScheme;

// A label for tracking referrals; details here:
// https://developers.facebook.com/docs/reference/plugins/like/
@property (retain) NSString *ref;

// A delegate
@property (assign) IBOutlet id<FacebookLikeViewDelegate> delegate;

// Load/reload the content of the web view. You should call this after changing any of the above parameters,
// and whenever the user signs in or out of Facebook.
- (void)load;

@end


@protocol FacebookLikeViewDelegate <NSObject>

// Called when user taps Like button or "sign in" link when not logged in. Your implementation should present 
// the user with a Facebook login dialog using either the Facebook iOS SDK or a separate web view. Once login 
// is complete, you should refresh this view using [aFacebookLikeView load].
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
