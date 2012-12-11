//
//  NSData+Extras.m
//  FacebookLikeViewDemo
//
//  Created by Tom Brow on 12/7/12.
//  Copyright (c) 2012 Tom Brow. All rights reserved.
//

#import "NSData+Extras.h"

@implementation NSData (Extras)

- (NSString*)UTF8String {
    return [[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding] autorelease];
}

@end
