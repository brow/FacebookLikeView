#FacebookLikeView

FacebookLikeView is a Facebook Like button for native iOS apps.

It integrates with the Facebook iOS SDK so that authenticated users can Like
with a single tap, and unauthenticated users are prompted with the standard
authentication dialog.

FacebookLikeView is not officially supported by Facebook, and it requires your
application to use the in-app authentication dialog rather than single sign-on
via Safari or the Facebook app. 

To see FacebookLikeView in action, build the included `FacebookLikeViewDemo`
project.

##Getting started

1. If you haven't already installed the Facebook iOS SDK, add the files in the
   `FBConnect` directory to your Xcode project.
2. Add the files in the `FacebookLikeView` directory to your Xcode project.
3. Instantiate a FacebookLikeView programmatically or in a nib.
4. Set the URL to be liked, plus any [Like button attributes] you'd like to
   customize. Make sure the `layout` you choose fits within the view's bounds.
    
        _facebookLikeView.href = [NSURL URLWithString:@"http://www.yardsellr.com"];
        _facebookLikeView.layout = @"button_count";
        _facebookLikeView.showFaces = NO;
    
5. Set a delegate that implements `facebookLikeViewRequiresLogin:`. Your
   implementation should call `-[Facebook authorize:delegate:]`, and then
   `-[FacebookLikeView load]` once login is complete.

        _facebookLikeView.delegate = self;

        ...

        - (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
            [_facebook authorize:[NSArray array] delegate:self];
        }

        - (void)fbDidLogin {
            [_facebookLikeView load];
        }
        
6. Finally, call `-[FacebookLikeView load]` before you display the view. You
   should also call this method any time the user signs in or out of Facebook,
   and after modifying any of the FacebookLikeView's properties.

##More delegate methods

You may want to be notified when the Like button is used. In that case,
implement these optional FacebookLikeViewDelegate methods:

    - (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView;
    - (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView;
    
To avoid showing the Like button before it's completely rendered, you can hide
the FacebookLikeView until this delegate method is called:

    - (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView;
    
##How it works

FacebookLikeView uses a web view to host the same Like button XFBML as would be
used on a web page. 

Since the web view shares cookies with all other web views in your app, a user
that authenticates through Facebook's in-app dialog is also authenticated to use
the Like button. The web view does _not_ share cookies with Safari or the
Facebook app, so FacebookLikeView monkeypatches FBConnect to never use those
apps for authentication.

Unlike a plain web view, FacebookLikeView does not follow redirects.  If
redirected to the Facebook login page, it ignores the redirect and calls the
delegate method `facebookLikeViewRequiresLogin:` so that you may present a
dialog instead.

FacebookLikeView monitors Like/Unlike events using [FB.Event.subscribe].  When
one of those events fires, a bit of JavaScript running inside the web view
encodes the event into a URL request that is intercepted by native code, which
then calls the appropriate delegate method.

##Caveats

FacebookLikeView is not supported by Facebook and is subject to break when
changes are made in the Like button's implementation.

FacebookLikeView is also not necessarily compatible with future versions of the
Facebook iOS SDK. To ensure compatibility, use the SDK snapshot contained in the
`FBConnect` directory.

[FB.Event.subscribe]: https://developers.facebook.com/docs/reference/javascript/FB.Event.subscribe
[Like button attributes]: https://developers.facebook.com/docs/reference/plugins/like
