//
//  MDACMochiDevStyle.m
//  MDAboutControllerDemo
//
//  Created by Dimitri Bouniol on 12/26/11.
//  Copyright (c) 2012 Mochi Development Inc. All rights reserved.
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

#import "MDACMochiDevStyle.h"

@implementation MDACMochiDevStyle

- (UIColor *)backgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"MDACBackground.png"]];
}

- (BOOL)hasSimpleBackground
{
    return NO;
}

- (UIImage *)listCellBackgroundTop
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundTop.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundMiddle
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundMiddle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundBottom
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundBottom.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundSingle
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundSingle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundTopSelected
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundSelectedTop.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundMiddleSelected
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundSelectedMiddle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundBottomSelected
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundSelectedBottom.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIImage *)listCellBackgroundSingleSelected
{
    return [[UIImage imageNamed:@"MDACDarkCellBackgroundSelectedSingle.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:10];
}

- (UIColor *)listCellBackgroundColor
{
    return [UIColor colorWithWhite:(CGFloat)(94./255.) alpha:1];
}

- (UIColor *)listCellTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)listCellDetailTextColor
{
    return [UIColor colorWithWhite:1 alpha:(CGFloat)0.7];
}

- (UIColor *)listCellShadowColor
{
    return [UIColor colorWithWhite:0 alpha:(CGFloat)0.6];
}

- (CGSize)listCellShadowOffset
{
    return CGSizeMake(0, -1);
}

- (UIImage *)listCellLinkArrow
{
    return [UIImage imageNamed:@"MDACDarkLinkArrow.png"];
}

- (UIColor *)iconCellTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)iconCellShadowColor
{
    return [UIColor colorWithWhite:0 alpha:(CGFloat)0.8];
}

- (CGSize)iconCellShadowOffset
{
    return CGSizeMake(0, -1);
}

- (UIColor *)textCellTextColor
{
    return [UIColor colorWithWhite:0.75 alpha:1];
}

- (UIColor *)textCellHighlightedTextColor
{
    return [UIColor colorWithWhite:0.5 alpha:1];
}

- (UIColor *)textCellShadowColor
{
    return [UIColor colorWithWhite:0 alpha:(CGFloat)0.8];
}

- (CGSize)textCellShadowOffset
{
    return CGSizeMake(0, -1);
}


@end
