//
//  Facebook+ForceDialog.m
//  Yardsellr
//
//  Created by Thomas Brow on 12/10/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "Facebook.h"

@implementation Facebook(ForceDialog)

- (void)authorize:(NSArray *)permissions
         delegate:(id<FBSessionDelegate>)delegate {
    // Hack to force Facebook SDK to always use in-app dialog for auth
    [_permissions release];
    _permissions = [permissions retain];
    
    _sessionDelegate = delegate;
    
    objc_msgSend(self, @selector(authorizeWithFBAppAuth:safariAuth:), NO, NO);    
}

@end

