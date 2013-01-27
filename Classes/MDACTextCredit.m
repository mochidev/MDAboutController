//
//  MDACTextCredit.m
//  MDAboutController
//
//  Created by Dimitri Bouniol on 5/23/11.
//  Copyright 2013 Mochi Development Inc. All rights reserved.
//  
//  Copyright (c) 2013 Dimitri Bouniol, Mochi Development, Inc.
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

#import "MDACTextCredit.h"

@implementation MDACTextCredit

@synthesize text, font, link, textAlignment;

- (id)initWithText:(NSString *)aTitle font:(UIFont *)aFont alignment:(UITextAlignment)textAlign linkURL:(NSURL *)anURL
{
    if ((self = [super initWithType:@"Text"])) {
        self.text = aTitle;
        if (!aFont) {
            aFont = [UIFont boldSystemFontOfSize:12];
        }
        self.font = aFont;
        self.textAlignment = textAlign;
        self.link = anURL;
    }
    return self;
}

- (id)initWithText:(NSString *)aTitle font:(UIFont *)aFont alignment:(UITextAlignment)textAlign viewController:(NSString *)aViewController
{
    if ((self = [self initWithText:aTitle font:aFont alignment:textAlign linkURL:nil])) {
        self.viewController = aViewController;
    }
    return self;
}

- (id)initWithType:(NSString *)aType
{
    return [self initWithText:nil font:nil alignment:NSTextAlignmentCenter linkURL:nil];
}

+ (id)creditWithType:(NSString *)aType
{
    return [self textCreditWithText:nil font:nil alignment:NSTextAlignmentCenter linkURL:nil];
}

+ (id)textCreditWithText:(NSString *)aTitle font:(UIFont *)aFont alignment:(UITextAlignment)textAlign linkURL:(NSURL *)anURL
{
    return [[self alloc] initWithText:aTitle font:aFont alignment:textAlign linkURL:anURL];
}

+ (id)textCreditWithText:(NSString *)aTitle font:(UIFont *)aFont alignment:(UITextAlignment)textAlign viewController:(NSString *)aViewController
{
    return [[self alloc] initWithText:aTitle font:aFont alignment:textAlign viewController:aViewController];
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    CGFloat fontSize = 12;
    if ([aDict objectForKey:@"Size"])
        fontSize = [[aDict objectForKey:@"Size"] floatValue];
    
    UITextAlignment alignment = NSTextAlignmentCenter;
    
    if ([[aDict objectForKey:@"Alignment"] isEqualToString:@"Left"]) {
        alignment = NSTextAlignmentLeft;
    } else if ([[aDict objectForKey:@"Alignment"] isEqualToString:@"Right"]) {
        alignment = NSTextAlignmentRight;
    }
    
    if ([aDict objectForKey:@"Controller"]) {
        self = [self initWithText:[aDict objectForKey:@"Text"]
                             font:[UIFont boldSystemFontOfSize:fontSize]
                        alignment:alignment
                   viewController:[aDict objectForKey:@"Controller"]];
    } else {
        NSString *linkString = [aDict objectForKey:@"Link"];
        if (!linkString && [aDict objectForKey:@"Email"]) {
            linkString = [NSString stringWithFormat:@"mailto:%@", [aDict objectForKey:@"Email"]];
        }
        
        self = [self initWithText:[aDict objectForKey:@"Text"]
                             font:[UIFont boldSystemFontOfSize:fontSize]
                        alignment:alignment
                          linkURL:[NSURL URLWithString:linkString]];
    }
    
    if (self) {
        self.identifier = [aDict objectForKey:@"Identifier"];
        NSMutableDictionary *newDict = [aDict mutableCopy];
        [newDict removeObjectsForKeys:[NSArray arrayWithObjects:@"Link", @"Email", @"Text", @"Size", @"Alignment", @"Controller", @"Identifier", nil]];
        self.userAssociations = newDict;
    }
    
    return self;
}

+ (id)textCreditWithDictionary:(NSDictionary *)aDict
{
    return [[self alloc] initWithDictionary:aDict];
}


@end