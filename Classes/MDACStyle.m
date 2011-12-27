//
//  MDACStyle.m
//  MDAboutControllerDemo
//
//  Created by Dimitri Bouniol on 12/26/11.
//  Copyright (c) 2011 Mochi Development Inc. All rights reserved.
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
