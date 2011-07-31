//
//  FacebookLikeView.m
//  Yardsellr
//
//  Created by Tom Brow on 5/9/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import "FacebookLikeView.h"

@interface FacebookLikeView () <UIWebViewDelegate>

- (void)initCommon;

@end


@implementation FacebookLikeView

@synthesize href=_href, layout=_layout, showFaces=_showFaces, action=_action, font=_font, 
    colorScheme=_colorScheme, ref=_ref, delegate=_delegate;

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
    [_href release];
    [_layout release];
    [_action release];
    [_font release];
    [_colorScheme release];
    [_ref release];
    
    [super dealloc];
    
    // UIWebView will cause a crash if dealloc'd on a non-main thread, so release
    // it after [super dealloc] and on the main thread
    [_webView performSelectorOnMainThread:@selector(release) 
                               withObject:nil 
                            waitUntilDone:YES];
}

- (void)initCommon {
    _webView = [[UIWebView alloc] init];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    [self addSubview:_webView];
    
    // Prevent web view from scrolling
    for (UIScrollView *subview in _webView.subviews)
        if ([subview isKindOfClass:[UIScrollView class]]) {
            subview.scrollEnabled = NO;
            subview.bounces = NO;
        }
    
    // Default settings
    self.href = nil;
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
                      self.href.absoluteString,
                      self.layout,
                      self.frame.size.width,
                      self.showFaces ? @"true" : @"false",
                      self.action,
                      self.colorScheme,
                      self.font,
                      self.frame.size.height];
    
    [_webView loadHTMLString:html baseURL:[NSURL URLWithString:@"file:///FacebookLikeView.html"]];
}

- (void)didFailLoadWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(facebookLikeView:didFailLoadWithError:)])
        [_delegate facebookLikeView:self didFailLoadWithError:error];
}

- (void)didObserveFacebookEvent:(NSString *)fbEvent {
    if ([fbEvent isEqualToString:@"edge.create"] && [_delegate respondsToSelector:@selector(facebookLikeViewDidLike:)])
        [_delegate facebookLikeViewDidLike:self];
    else if ([fbEvent isEqualToString:@"edge.remove"] && [_delegate respondsToSelector:@selector(facebookLikeViewDidUnlike:)])
        [_delegate facebookLikeViewDidUnlike:self];
    else if ([fbEvent isEqualToString:@"xfbml.render"] && [_delegate respondsToSelector:@selector(facebookLikeViewDidRender:)])
        [_delegate facebookLikeViewDidRender:self];
}

#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Allow loading Like button XFBML from file
    if ([request.URL.scheme isEqualToString:@"file"])
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
    else if ([request.URL.lastPathComponent isEqualToString:@"login.php"]) {
        [_delegate facebookLikeViewRequiresLogin:self];
        return NO;
    }
    
    else
        return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self didFailLoadWithError:error];
}

#pragma mark UIView methods

- (void)layoutSubviews {
    _webView.frame = self.bounds;
}

@end
