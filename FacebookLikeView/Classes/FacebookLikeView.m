//
//  FacebookLikeView.m
//  Yardsellr
//
//  Created by Tom Brow on 5/9/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import "FacebookLikeView.h"

@interface FacebookLikeView () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation NSData (UTF8String)

- (NSString*)UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end

@implementation FacebookLikeView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initCommon];
    }
    return  self;
}

- (void)dealloc
{
    // According to SDK doc, UIWebView's delegate must be set to nil before the view is released.
    self.webView.delegate = nil;

}

- (void)initCommon {
    self.webView = [[UIWebView alloc] init];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
    [self addSubview:self.webView];
    
    // Prevent web view from scrolling
    for (UIScrollView *subview in self.webView.subviews)
        if ([subview isKindOfClass:[UIScrollView class]]) {
            subview.scrollEnabled = NO;
            subview.bounces = NO;
        }
    
    // Default settings
    self.href = [NSURL URLWithString:@"http://example.com"];
    self.layout = @"standard";
    self.showFaces = YES;
    self.action = @"like";
    self.font = @"arial";
    self.colorScheme = @"light";
    self.ref = @"";
}

- (void)load {
    NSString *htmlFormat = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FacebookLikeView"
                                                                                              ofType:@"html"]
                                                     encoding:NSUTF8StringEncoding 
                                                        error:nil];
    NSString *html = [NSString stringWithFormat:htmlFormat,
                      self.frame.size.width,
                      self.href.absoluteString,
                      self.layout,
                      self.frame.size.width,
                      self.showFaces ? @"true" : @"false",
                      self.action,
                      self.colorScheme,
                      self.font,
                      self.frame.size.height];
    
    [self.webView loadHTMLString:html baseURL:self.href];
}

- (void)didFailLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(facebookLikeView:didFailLoadWithError:)])
        [self.delegate facebookLikeView:self didFailLoadWithError:error];
}

- (void)didObserveFacebookEvent:(NSString *)fbEvent {
    if ([fbEvent isEqualToString:@"edge.create"] && [self.delegate respondsToSelector:@selector(facebookLikeViewDidLike:)])
        [self.delegate facebookLikeViewDidLike:self];
    else if ([fbEvent isEqualToString:@"edge.remove"] && [self.delegate respondsToSelector:@selector(facebookLikeViewDidUnlike:)])
        [self.delegate facebookLikeViewDidUnlike:self];
    else if ([fbEvent isEqualToString:@"xfbml.render"] && [self.delegate respondsToSelector:@selector(facebookLikeViewDidRender:)])
        [self.delegate facebookLikeViewDidRender:self];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Allow loading Like button XFBML from file
    if ([request.URL.host isEqual:self.href.host])
        return YES;
    
    // Allow loading about:blank, etc.
    if ([request.URL.scheme isEqualToString:@"about"])
        return YES;
    
    // Block loading of 'event:*', our scheme for forwarding Facebook JS SDK events to native code
    else if ([request.URL.scheme isEqualToString:@"event"]) {
        [self didObserveFacebookEvent:request.URL.resourceSpecifier];
        return NO;
    }
    
    // Block redirects to non-Facebook URLs (e.g., by public wifi access points)
    else if (![request.URL.host hasSuffix:@"facebook.com"] && ![request.URL.host hasSuffix:@"fbcdn.net"]) {
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"FacebookLikeView was redirected to a non-Facebook URL.", NSLocalizedDescriptionKey,
                                   request.URL, NSURLErrorKey,
                                   nil];
        NSError *error = [NSError errorWithDomain:@"FacebookLikeViewErrorDomain" 
                                             code:0 
                                         userInfo:errorInfo];
        [self didFailLoadWithError:error];
        return NO;
    }
    
    // Block redirects to the Facebook login page and notify the delegate that we've done so
    else if ([request.URL.path isEqualToString:@"/dialog/plugin.optin"] ||
             ([request.URL.path isEqualToString:@"/plugins/like/connect"] && [request.HTTPBody.UTF8String hasPrefix:@"lsd"])) {
        [self.delegate facebookLikeViewRequiresLogin:self];
        return NO;
    }
    
    else
        return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self didFailLoadWithError:error];
}

#pragma mark UIView

- (void)layoutSubviews {
    // Due to an apparent iOS 4 bug, layoutSubviews is sometimes called outside the main thread.
    // See https://devforums.apple.com/message/575760#575760
    if ([NSThread isMainThread])
        self.webView.frame = self.bounds;
}

@end
