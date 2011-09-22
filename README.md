#FacebookLikeView

FacebookLikeView is a Facebook Like button that fits nicely into your native iOS application. It integrates with the Facebook iOS SDK so that already-authenticated users can "like" with a single tap, and unauthenticated users can are prompted with the native login dialog.

It comes with some caveats; it's not officially supported by Facebook, and it requires your application to use the in-app auth dialog rather than single sign-on via Safari or the Facebook app. 

To see FacebookLikeView in action, build the included `FacebookLikeViewDemo` project.

#Getting Started

1. If haven't already installed the Facebook iOS SDK, add the files in the `FBConnect` directory to your project.
2. Add the files in the `FacebookLikeView` directory to your Xcode project.
3. Instantiate a FacebookLikeView programmatically or in a nib. Either way works!
4. Set the URL to be liked, plus any [other attributes](https://developers.facebook.com/docs/reference/plugins/like/) you'd like to customize. Make sure the `layout` you choose fits within the view's bounds.
    
        _facebookLikeView.href = [NSURL URLWithString:@"http://www.yardsellr.com"];
        _facebookLikeView.layout = @"button_count";
        _facebookLikeView.showFaces = NO;
    
5. Set a delegate that implements `facebookLikeViewRequiresLogin:`. It should call `-[Facebook authorize:delegate:]` and then reload the FacebookLikeView once login is complete.

        _facebookLikeView.delegate = self;
        ...
        - (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
            [_facebook authorize:[NSArray array] delegate:self];
        }
        - (void)fbDidLogin {
            [_facebookLikeView load];
        }
        
6. Finally, call `-[FacebookLikeView load]` before you display the view. You should also call this method any time the user signs in or out of Facebook, and after modifying any of the FacebookLikeView's properties.

#More Callbacks

You may want to be notified when a user likes or dislikes you. Just implement the following methods in FacebookLikeView's delegate:

    - (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView;
    - (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView;
    
To avoid showing the Like button before it's completely rendered, try hiding your FacebookLikeView until you receive this callback:

    - (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView;
    
#Staying Logged In
Since the shared cookie store in an iOS application [is not guaranteed to persist](http://stackoverflow.com/questions/5837702/nshttpcookiestorage-state-not-saved-on-app-exit-any-definitive-knowledge-documen) when the app terminates, FacebookLikeView is liable to prompt the user to log in multiple times over multiple uses of the app. If you'd rather have the user log in just once, you need to persist cookies between launches.

Here's one way to implement that in the application delegate:
    
    #define SavedHTTPCookiesKey @"SavedHTTPCookies"
    
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        NSData *cookiesData = [[NSUserDefaults standardUserDefaults]
                                objectForKey:SavedHTTPCookiesKey];
        if (cookiesData) {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesData];
            for (NSHTTPCookie *cookie in cookies)
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        ...
    }
    
    - (void)applicationDidEnterBackground:(UIApplication *)application {
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:
                               [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData
                                                  forKey:SavedHTTPCookiesKey];
    }
    
#How It Works

FacebookLikeView is just a UIWebView that contains the same XFMBL one would use to display a Like button in a web-based application. Since FacebookLikeView shares cookies with all other UIWebViews in your app, a user that has already signed in using Facebook's in-app auth dialog does not need to sign in again to use this Like button. FacebookLikeView does _not_ have access to cookies owned by Safari or the Facebook app, so it monkeypatches the Facebook iOS SDK to never use those apps for auth. 

Unlike a plain UIWebView, FacebookLikeView does not allow itself be redirected away from the Like button. If redirected to the Facebook login page, it ignores the redirect and calls the delegate method `facebookLikeViewRequiresLogin:` so that you may present the native login dialog instead.

FacebookLikeView monitors like/unlike events using [event.subscribe](https://developers.facebook.com/docs/reference/javascript/FB.Event.subscribe/). When one of those events fires, a bit of JavaScript running inside the web view encodes the event data into a URL request that is intercepted by native code, which then calls the appropriate delegate method.

#Caveats

FacebookLikeView is not supported by Facebook and will break if certain undocumented parameters change. In particular, FacebookLikeView assumes that the URL of the Facebook login redirect does not change and that only content from domains `facebook.com` and `fbcdn.net` should ever be loaded.

FacebookLikeView is also not guaranteed to work with future versions of the Facebook iOS SDK. To ensure compatibility, use the snapshot of the SDK contained in the `FBConnect` directory.





