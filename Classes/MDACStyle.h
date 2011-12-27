//
//  MDACStyle.h
//  MDAboutControllerDemo
//
//  Created by Dimitri Bouniol on 12/26/11.
//  Copyright (c) 2011 Mochi Development Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDACStyle : NSObject

+ (id)style;

- (UIColor *)backgroundColor;
- (BOOL)hasSimpleBackground;

- (CGFloat)spacerHeight;
- (CGFloat)listHeight;
- (CGFloat)iconAdditionalHeight;

- (UIImage *)listCellBackgroundTop;
- (UIImage *)listCellBackgroundMiddle;
- (UIImage *)listCellBackgroundBottom;
- (UIImage *)listCellBackgroundSingle;

- (UIImage *)listCellBackgroundTopSelected;
- (UIImage *)listCellBackgroundMiddleSelected;
- (UIImage *)listCellBackgroundBottomSelected;
- (UIImage *)listCellBackgroundSingleSelected;

- (UIFont *)listCellFont;
- (UIFont *)listCellDetailFont;
- (UIColor *)listCellBackgroundColor;
- (UIColor *)listCellTextColor;
- (UIColor *)listCellShadowColor;
- (CGSize)listCellShadowOffset;
- (UIImage *)listCellLinkArrow;

- (UIFont *)iconCellFont;
- (UIFont *)iconCellDetailFont;
- (UIColor *)iconCellTextColor;
- (UIColor *)iconCellShadowColor;
- (CGSize)iconCellShadowOffset;

- (UIColor *)textCellTextColor;
- (UIColor *)textCellHighlightedTextColor;
- (UIColor *)textCellShadowColor;
- (CGSize)textCellShadowOffset;

@end
