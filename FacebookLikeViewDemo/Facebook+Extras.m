//
//  Facebook+Extras.m
//  Yardsellr
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "Facebook+Extras.h"

static Facebook *facebook = nil;

@implementation Facebook(Extras)

+ (Facebook *)sharedFacebook {
	if (!facebook)
		facebook = [[Facebook alloc] initWithAppId:@"158575400878173"];
	return facebook;
}

- (void)authorize:(NSArray *)permissions
         delegate:(id<FBSessionDelegate>)delegate {
    
    [_permissions release];
    _permissions = [permissions retain];
    
    _sessionDelegate = delegate;
    
    objc_msgSend(self, @selector(authorizeWithFBAppAuth:safariAuth:), NO, NO);    
}

@end

