//
//  MDACStyle.m
//  MDAboutControllerDemo
//
//  Created by Dimitri Bouniol on 12/26/11.
//  Copyright (c) 2011 Mochi Development Inc. All rights reserved.
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

#import "MDACStyle.h"

@implementation MDACStyle

+ (id)style
{
    return [[[self alloc] init] autorelease];
}

- (UIColor *)backgroundColor
{
    return [UIColor groupTableViewBackgroundColor];
}

- (BOOL)hasSimpleBackground
{
    return YES;
}

- (CGFloat)spacerHeight
{
    return 25;
}

- (CGFloat)listHeight
{
    return 44;
}

- (CGFloat)iconAdditionalHeight
{
    return 20;
}

- (CGFloat)listTitleHeight
{
    return 23;
}

- (UIImage *)listCellBackgroundTop
{
    return [[UIImage imageNamed:@"MDACCellBackgroundTop.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundMiddle
{
    return [[UIImage imageNamed:@"MDACCellBackgroundMiddle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundBottom
{
    return [[UIImage imageNamed:@"MDACCellBackgroundBottom.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundSingle
{
    return [[UIImage imageNamed:@"MDACCellBackgroundSingle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundTopSelected
{
    return [[UIImage imageNamed:@"MDACCellBackgroundSelectedTop.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundMiddleSelected
{
    return [[UIImage imageNamed:@"MDACCellBackgroundSelectedMiddle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundBottomSelected
{
    return [[UIImage imageNamed:@"MDACCellBackgroundSelectedBottom.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundSingleSelected
{
    return [[UIImage imageNamed:@"MDACCellBackgroundSelectedSingle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIFont *)listCellFont
{
    return [UIFont boldSystemFontOfSize:17];
}

- (UIFont *)listCellDetailFont
{
    return [UIFont boldSystemFontOfSize:15];
}

- (UIColor *)listCellBackgroundColor
{
    return [UIColor colorWithWhite:247./255. alpha:1];
}

- (UIColor *)listCellTextColor
{
    return [UIColor blackColor];
}

- (UIColor *)listCellDetailTextColor
{
    return [UIColor colorWithWhite:0 alpha:0.6];
}

- (UIColor *)listCellShadowColor
{
    return [UIColor colorWithWhite:253./255. alpha:0.6];
}

- (CGSize)listCellShadowOffset
{
    return CGSizeMake(0, 1);
}

- (UIImage *)listCellLinkArrow
{
    return [UIImage imageNamed:@"MDACLinkArrow.png"];
}

- (UIFont *)listCellTitleFont
{
    return [UIFont boldSystemFontOfSize:17];
}

- (UIColor *)listCellTitleTextColor
{
    return [self iconCellTextColor];
}

- (UIColor *)listCellTitleShadowColor
{
    return [self iconCellShadowColor];
}

- (CGSize)listCellTitleShadowOffset
{
    return [self iconCellShadowOffset];
}

- (UIFont *)iconCellFont
{
    return [UIFont boldSystemFontOfSize:18];
}

- (UIFont *)iconCellDetailFont
{
    return [UIFont boldSystemFontOfSize:14];
}

- (UIColor *)iconCellTextColor
{
    return [UIColor colorWithRed:75./255. green:85./255. blue:109./255. alpha:1];
}

- (UIColor *)iconCellShadowColor
{
    return [UIColor whiteColor];
}

- (CGSize)iconCellShadowOffset
{
    return CGSizeMake(0, 1);
}

- (UIColor *)textCellTextColor
{
    return [UIColor colorWithRed:75./255. green:85./255. blue:109./255. alpha:1];
}

- (UIColor *)textCellHighlightedTextColor
{
    return [UIColor darkGrayColor];
}

- (UIColor *)textCellShadowColor
{
    return [UIColor whiteColor];
}

- (CGSize)textCellShadowOffset
{
    return CGSizeMake(0, 1);
}


@end
