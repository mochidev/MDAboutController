//
//  MDACCreditItem.m
//  MDAboutController
//
//  Created by Dimitri Bouniol on 5/23/11.
//  Copyright 2011 Mochi Development Inc. All rights reserved.
//  
//  Copyright (c) 2011 Dimitri Bouniol, Mochi Development, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software, associated artwork, and documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included in
//     all copies or substantial portions of the Software.
//  2. Neither the name of Mochi Development, Inc. nor the names of its
//     contributors or products may be used to endorse or promote products
//     derived from this software without specific prior written permission.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  
//  EleMints, the EleMints Icon, Mochi Dev, and the Mochi Development logo are
//  copyright Mochi Development, Inc.
//  
//  Also, it'd be super awesome if you left in the credit line generated
//  automatically by the code that links back to this page :)
//

#import "MDACCreditItem.h"

@implementation MDACCreditItem

@synthesize name, role, link, viewController, userAssociations;

- (id)initWithName:(NSString *)aName role:(NSString *)aRole linkURL:(NSURL *)anURL
{
    if ((self = [super init])) {
        self.name = aName;
        self.role = aRole;
        self.link = anURL;
    }
    return self;
}

- (id)initWithName:(NSString *)aName role:(NSString *)aRole linkString:(NSString *)aLink
{
    return [self initWithName:aName role:aRole linkURL:[NSURL URLWithString:aLink]];
}

- (id)initWithName:(NSString *)aName role:(NSString *)aRole viewController:(UIViewController *)aViewController
{
    if ((self = [self initWithName:aName role:aRole linkURL:nil])) {
        self.viewController = aViewController;
    }
    return self;
}

- (id)init
{
    return [self initWithName:nil role:nil linkURL:nil];
}

+ (id)itemWithName:(NSString *)aName role:(NSString *)aRole linkURL:(NSURL *)anURL
{
    return [[[self alloc] initWithName:aName role:aRole linkURL:anURL] autorelease];
}

+ (id)itemWithName:(NSString *)aName role:(NSString *)aRole linkString:(NSString *)aLink
{
    return [[[self alloc] initWithName:aName role:aRole linkURL:[NSURL URLWithString:aLink]] autorelease];
}

+ (id)itemWithName:(NSString *)aName role:(NSString *)aRole viewController:(UIViewController *)aViewController
{
    return [[[self alloc] initWithName:aName role:aRole viewController:aViewController] autorelease];
}

+ (id)item
{
    return [self itemWithName:nil role:nil linkURL:nil];
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    NSString *linkString = [aDict objectForKey:@"Link"];
    if (!linkString && [aDict objectForKey:@"Email"]) {
        linkString = [NSString stringWithFormat:@"mailto:%@", [aDict objectForKey:@"Email"]];;
    }
    if (!linkString && [aDict objectForKey:@"Controller"]) {
        linkString = [NSString stringWithFormat:@"x-controller:%@", [aDict objectForKey:@"Controller"]];;
    }
    if (self = [self initWithName:[aDict objectForKey:@"Name"]
                             role:[aDict objectForKey:@"Role"]
                       linkString:linkString]) {
        NSMutableDictionary *newDict = [aDict mutableCopy];
        [newDict removeObjectsForKeys:[NSArray arrayWithObjects:@"Link", @"Email", @"Name", @"Role", @"Controller", nil]];
        self.userAssociations = newDict;
        [newDict release];
    }
    return self;
}

+ (id)itemWithDictionary:(NSDictionary *)aDict
{
    return [[[self alloc] initWithDictionary:aDict] autorelease];
}

- (void)dealloc
{
    [userAssociations release];
    [viewController release];
    [name release];
    [role release];
    [link release];
    [super dealloc];
}

@end