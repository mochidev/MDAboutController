//
//  MDAboutController.m
//  MDAboutController
//
//  Created by Dimitri Bouniol on 4/18/11.
//  Copyright 2013 Mochi Development Inc. All rights reserved.
//
//  Copyright (c) 2010 Dimitri Bouniol, Mochi Development, Inc.
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

#import "MDAboutController.h"
#import "UIImage+DBMaskedImageAdditions.h"
#import "MDACTitleBar.h"
#import "MDACCredit.h"
#import "MDACCreditItem.h"
#import "MDACListCredit.h"
#import "MDACTextCredit.h"
#import "MDACImageCredit.h"
#import "MDACIconCredit.h"
#import "MDACWebViewController.h"
#import "MDACStyle.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark Constants

static NSString *MDACIconCellID         = @"MDACIconCell";
static NSString *MDACSpacerCellID       = @"MDACSpacerCell";
static NSString *MDACListTitleCellID    = @"MDACListTitleCellID";
static NSString *MDACTopListCellID      = @"MDACTopListCell";
static NSString *MDACMiddleListCellID   = @"MDACMiddleListCell";
static NSString *MDACBottomListCellID   = @"MDACBottomListCell";
static NSString *MDACSingleListCellID   = @"MDACSingleListCell";
static NSString *MDACTextCellID         = @"MDACTextCell";
static NSString *MDACImageCellID        = @"MDACImageCell";

@interface MDAboutController ()

- (void)generateCachedCells; // internal
- (void)generateCachedCellsIfNeeded; // internal

- (void)generateIconIfNeeded;

- (void)openMailToRecipient:(NSString *)recipient subject:(NSString *)subject;

@property (nonatomic, strong, readwrite) MDACStyle *style;
@property (nonatomic, strong, readwrite) NSString *creditsName;

- (void)_reloadCreditsNow;
- (NSString *)_localizedAboutString;
- (NSString *)_shortLocalizedVersionFormatString;
- (NSString *)_longLocalizedVersionFormatString;

@end

@interface NSObject ()
+ (BOOL)canSendMail;
@end

@implementation MDAboutController

@synthesize showsTitleBar, titleBar, backgroundColor, hasSimpleBackground, credits, style, delegate;

- (id)initWithCreditsName:(NSString *)aName style:(MDACStyle *)aStyle
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.style = aStyle;
        self.creditsName = aName;
        
        self.showsAttributions = YES;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        self.backgroundColor = [self.style backgroundColor];
        self.hasSimpleBackground = [self.style hasSimpleBackground];
        
        self.navigationItem.title = [self _localizedAboutString];
        
        credits = [[NSMutableArray alloc] init];
        
        [self reloadCredits];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        self.style = [decoder decodeObjectForKey:@"MDACStyle"];
        self.creditsName = [decoder decodeObjectForKey:@"MDACCreditsName"];
        self.showsAttributions = [decoder decodeBoolForKey:@"MDACShowsAttributions"];
        
        self.backgroundColor = [self.style backgroundColor];
        self.hasSimpleBackground = [self.style hasSimpleBackground];
        
        self.navigationItem.title = [self _localizedAboutString];
        
        credits = [[NSMutableArray alloc] init];
        
        [self reloadCredits];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:self.style forKey:@"MDACStyle"];
    [coder encodeObject:self.creditsName forKey:@"MDACCreditsName"];
    [coder encodeBool:self.showsAttributions forKey:@"MDACShowsAttributions"];
}

- (id)initWithCreditsName:(NSString *)aName
{
    return [self initWithCreditsName:aName style:nil];
}

- (id)initWithStyle:(MDACStyle *)aStyle
{
    return [self initWithCreditsName:nil style:aStyle];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:nil];
}

- (void)setBackgroundColor:(UIColor *)aColor
{
    if (backgroundColor != aColor) {
        backgroundColor = aColor;
        
        tableView.backgroundColor = backgroundColor;
        if ([self isViewLoaded])
            self.view.backgroundColor = backgroundColor;
    }
    
    self.hasSimpleBackground = !CGColorGetPattern(backgroundColor.CGColor);
}

- (MDACStyle *)style
{
    if (!style) {
        self.style = [MDACStyle style];
    }
    return style;
}

- (NSString *)creditsName
{
    if (!_creditsName) {
        _creditsName = @"Credits";
    }
    return _creditsName;
}

- (void)setDelegate:(id<MDAboutControllerDelegate>)aDelegate
{
    delegate = aDelegate;
    
    [self reloadCredits];
}

- (void)setShowsAttributions:(BOOL)yn
{
    _showsAttributions = yn;
    
    [self reloadCredits];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)generateCachedCells
{
    
    cachedCellCredits = [[NSMutableArray alloc] init];
    cachedCellHeights = [[NSMutableArray alloc] init];
    cachedCellIDs = [[NSMutableArray alloc] init];
    cachedCellIndices = [[NSMutableArray alloc] init];
    
    NSString *cellID;
    NSUInteger index, count;
    
    int i = 1;
    int j;
    
    [cachedCellCredits addObject:[NSNull null]];
    [cachedCellHeights addObject:[NSNumber numberWithFloat:[self.style spacerHeight]]];
    [cachedCellIDs addObject:MDACSpacerCellID];
    [cachedCellIndices addObject:[NSNull null]];
    
    for (MDACCredit *tempCredit in credits) {
        if ([tempCredit isMemberOfClass:[MDACListCredit class]]) {
            count = [(MDACListCredit *)tempCredit count];
            j = i;
            i += count;
            
            if ([(MDACListCredit *)tempCredit title] && ![[(MDACListCredit *)tempCredit title] isEqualToString:@""]) {
                [cachedCellCredits addObject:tempCredit];
                [cachedCellHeights addObject:[NSNumber numberWithFloat:[self.style listTitleHeight]]];
                [cachedCellIDs addObject:MDACListTitleCellID];
                [cachedCellIndices addObject:[NSNull null]];
            }
            
            for (; j < i; j++) {
                index = j - (i - count);
                if (index == count-1) {
                    if (index == 0) {
                        cellID = MDACSingleListCellID;
                    } else {
                        cellID = MDACBottomListCellID;
                    }
                } else if (index == 0) {
                    cellID = MDACTopListCellID;
                } else {
                    cellID = MDACMiddleListCellID;
                }
                
                [cachedCellCredits addObject:tempCredit];
                [cachedCellHeights addObject:[NSNumber numberWithFloat:[self.style listHeight]]];
                [cachedCellIDs addObject:cellID];
                [cachedCellIndices addObject:[NSNumber numberWithInteger:index]];
            }
        } else if ([tempCredit isMemberOfClass:[MDACIconCredit class]]) {
            i += 1;
            
            float iconHeight = 57;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                iconHeight = 72;
            
            if (NSClassFromString(@"UIMotionEffect")) {
                iconHeight = 60;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    iconHeight = 76;
            }
            
            iconHeight += [self.style iconAdditionalHeight];
            
            [cachedCellCredits addObject:tempCredit];
            [cachedCellHeights addObject:[NSNumber numberWithFloat:iconHeight]];
            [cachedCellIDs addObject:MDACIconCellID];
            [cachedCellIndices addObject:[NSNull null]];
        } else if ([tempCredit isMemberOfClass:[MDACTextCredit class]]) {
            i += 1;
            
            CGSize textSize = CGSizeMake(300, 30);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                textSize = [[(MDACTextCredit *)tempCredit text] sizeWithFont:[(MDACTextCredit *)tempCredit font]
                                                           constrainedToSize:CGSizeMake(450, 1000)
                                                               lineBreakMode:NSLineBreakByWordWrapping];
            } else {
                textSize = [[(MDACTextCredit *)tempCredit text] sizeWithFont:[(MDACTextCredit *)tempCredit font]
                                                           constrainedToSize:CGSizeMake(300, 1000)
                                                               lineBreakMode:NSLineBreakByWordWrapping];
            }
            
            [cachedCellCredits addObject:tempCredit];
            [cachedCellHeights addObject:[NSNumber numberWithFloat:textSize.height+2]];
            [cachedCellIDs addObject:MDACTextCellID];
            [cachedCellIndices addObject:[NSNull null]];
        } else if ([tempCredit isMemberOfClass:[MDACImageCredit class]]) {
            i += 1;
            
            [cachedCellCredits addObject:tempCredit];
            [cachedCellHeights addObject:[NSNumber numberWithFloat:[(MDACImageCredit *)tempCredit image].size.height]];
            [cachedCellIDs addObject:MDACImageCellID];
            [cachedCellIndices addObject:[NSNull null]];
        } else {
            i += 1;
            
            [cachedCellCredits addObject:tempCredit];
            [cachedCellHeights addObject:[NSNumber numberWithFloat:[self.style spacerHeight]]];
            [cachedCellIDs addObject:MDACSpacerCellID];
            [cachedCellIndices addObject:[NSNull null]];
        }
        
        i += 1;
        
        [cachedCellCredits addObject:[NSNull null]];
        [cachedCellHeights addObject:[NSNumber numberWithFloat:[self.style spacerHeight]]];
        [cachedCellIDs addObject:MDACSpacerCellID];
        [cachedCellIndices addObject:[NSNull null]];
    }
}

- (void)generateCachedCellsIfNeeded
{
    if (!cachedCellCredits) {
        [self generateCachedCells];
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = nil;
    MDACCredit *credit = nil;
    NSUInteger index = 0;
    
    [self generateCachedCellsIfNeeded];
    
    if ((NSNull *)[cachedCellIDs objectAtIndex:indexPath.row] != [NSNull null])
        cellID = [cachedCellIDs objectAtIndex:indexPath.row];
    
    if ((NSNull *)[cachedCellCredits objectAtIndex:indexPath.row] != [NSNull null])
        credit = [cachedCellCredits objectAtIndex:indexPath.row];
    
    if ((NSNull *)[cachedCellIndices objectAtIndex:indexPath.row] != [NSNull null])
        index = [[cachedCellIndices objectAtIndex:indexPath.row] integerValue];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    UILabel *textLabel = nil, *detailTextLabel = nil;
    UIImageView *linkAvailableImageView = nil;
    
    UIImageView *iconView = nil;
    UIView *containerView = nil;
    
    UIImageView *imageView = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.contentView.superview.clipsToBounds = NO; // get that pesky scrollview...
        if (self.hasSimpleBackground)
            cell.backgroundColor = self.backgroundColor;
        
        if (cellID == MDACTopListCellID || cellID == MDACMiddleListCellID || cellID == MDACBottomListCellID || cellID == MDACSingleListCellID) {
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self.style listHeight])];
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self.style listHeight])];
            
            UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width-20, [self.style listHeight])];
            UIImageView *selectedBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0.5, tableView.bounds.size.width-20, [self.style listHeight])];
            
            if (cellID == MDACTopListCellID) {
                backgroundImage.frame = CGRectMake(10, -1, tableView.bounds.size.width-20, [self.style listHeight]+1);
                backgroundImage.image = [self.style listCellBackgroundTop];
                selectedBackgroundImage.frame = CGRectMake(10, -0.5, tableView.bounds.size.width-20, [self.style listHeight]+1);
                selectedBackgroundImage.image = [self.style listCellBackgroundTopSelected];
            } else if (cellID == MDACMiddleListCellID) {
                backgroundImage.image = [self.style listCellBackgroundMiddle];
                selectedBackgroundImage.image = [self.style listCellBackgroundMiddleSelected];
            } else if (cellID == MDACBottomListCellID) {
                backgroundImage.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, [self.style listHeight]+1);
                backgroundImage.image = [self.style listCellBackgroundBottom];
                selectedBackgroundImage.frame = CGRectMake(10, 0.5, tableView.bounds.size.width-20, [self.style listHeight]+1);
                selectedBackgroundImage.image = [self.style listCellBackgroundBottomSelected];
            } else {
                backgroundImage.frame = CGRectMake(10, -1, tableView.bounds.size.width-20, [self.style listHeight]+2);
                backgroundImage.image = [self.style listCellBackgroundSingle];
                selectedBackgroundImage.frame = CGRectMake(10, -0.5, tableView.bounds.size.width-20, [self.style listHeight]+2);
                selectedBackgroundImage.image = [self.style listCellBackgroundSingleSelected];
            }
            
            backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [backgroundView addSubview:backgroundImage];
            
            selectedBackgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [selectedBackgroundView addSubview:selectedBackgroundImage];
            
            cell.backgroundView = backgroundView;
            cell.selectedBackgroundView = selectedBackgroundView;
            
            textLabel = [[UILabel alloc] init];
            textLabel.font = [self.style listCellFont];
            textLabel.backgroundColor = [self.style listCellBackgroundColor];
            textLabel.textColor = [self.style listCellTextColor];
            textLabel.shadowColor = [self.style listCellShadowColor];
            textLabel.shadowOffset = [self.style listCellShadowOffset];
            textLabel.tag = 1;
            [cell.contentView addSubview:textLabel];
            
            detailTextLabel = [[UILabel alloc] init];
            detailTextLabel.font = [self.style listCellDetailFont];
            detailTextLabel.minimumScaleFactor = 0.8;
            detailTextLabel.adjustsFontSizeToFitWidth = YES;
            detailTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
            detailTextLabel.backgroundColor = [self.style listCellBackgroundColor];
            detailTextLabel.textColor = [self.style listCellDetailTextColor];
            detailTextLabel.shadowColor = [self.style listCellShadowColor];
            detailTextLabel.shadowOffset = [self.style listCellShadowOffset];
            detailTextLabel.textAlignment = NSTextAlignmentRight;
            detailTextLabel.tag = 2;
            [cell.contentView addSubview:detailTextLabel];
            
            linkAvailableImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width-39, 9, 24, 24)];
            linkAvailableImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            linkAvailableImageView.image = [self.style listCellLinkArrow];
            linkAvailableImageView.tag = 3;
            [cell.contentView addSubview:linkAvailableImageView];
        } else if (cellID == MDACIconCellID) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            containerView = [[UIView alloc] init];
            containerView.tag = 5;
            containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            iconView = [[UIImageView alloc] init];
            UIImageView *iconBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MDACIconShadow.png"]];
            
            float iconHeight = 57;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                iconHeight = 72;
            
            if (NSClassFromString(@"UIMotionEffect")) {
                iconHeight = 60;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    iconHeight = 76;
                
                iconBackground.image = nil;
            }
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                iconView.frame = CGRectMake(0, 0, iconHeight, iconHeight);
                containerView.frame = CGRectMake(roundf((cell.contentView.bounds.size.width-212)/2.), 0, 212, iconHeight + 20);
            } else {
                iconView.frame = CGRectMake(0, 0, iconHeight, iconHeight);
                containerView.frame = CGRectMake(roundf((cell.contentView.bounds.size.width-198)/2.), 0, 198, iconHeight + 20);
            }
            
            iconBackground.center = CGPointMake(10+iconView.bounds.size.width/2., containerView.bounds.size.height/2.+3);
            iconView.center = CGPointMake(iconBackground.center.x, iconBackground.center.y-3);
            iconView.tag = 4;
            
            [containerView addSubview:iconBackground];
            [containerView addSubview:iconView];
            
            
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.bounds.size.width + 25., floorf(10. + iconView.bounds.size.height/2. - 17.), 170., 22.)];
            textLabel.font = [self.style iconCellFont];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.opaque = NO;
            textLabel.textColor = [self.style iconCellTextColor];
            textLabel.shadowColor = [self.style iconCellShadowColor];
            textLabel.shadowOffset = [self.style iconCellShadowOffset];
            textLabel.tag = 1;
            [containerView addSubview:textLabel];
            
            detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.bounds.size.width + 25., floorf(10+iconView.bounds.size.height/2. + 3.), 170., 20.)];
            detailTextLabel.font = [self.style iconCellDetailFont];
            detailTextLabel.backgroundColor = [UIColor clearColor];
            detailTextLabel.opaque = NO;
            detailTextLabel.textColor = [self.style iconCellTextColor];
            detailTextLabel.shadowColor = [self.style iconCellShadowColor];
            detailTextLabel.shadowOffset = [self.style iconCellShadowOffset];
            detailTextLabel.tag = 2;
            [containerView addSubview:detailTextLabel];
            
            [cell.contentView addSubview:containerView];
        } else if (cellID == MDACListTitleCellID) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, -10, cell.contentView.bounds.size.width-40, cell.contentView.bounds.size.height)];
            textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            textLabel.numberOfLines = 0;
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.opaque = NO;
            textLabel.font = [self.style listCellTitleFont];
            textLabel.textColor = [self.style listCellTitleTextColor];
            textLabel.shadowColor = [self.style listCellTitleShadowColor];
            textLabel.shadowOffset = [self.style listCellTitleShadowOffset];
            textLabel.tag = 1;
            [cell.contentView addSubview:textLabel];
        } else if (cellID == MDACTextCellID) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.contentView.bounds.size.width-20, cell.contentView.bounds.size.height)];
            textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            textLabel.numberOfLines = 0;
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.opaque = NO;
            textLabel.textColor = [self.style textCellTextColor];
            textLabel.highlightedTextColor = [self.style textCellHighlightedTextColor];
            textLabel.shadowColor = [self.style textCellShadowColor];
            textLabel.shadowOffset = [self.style textCellShadowOffset];
            textLabel.tag = 1;
            [cell.contentView addSubview:textLabel];
        } else if (cellID == MDACImageCellID) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height)];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.opaque = NO;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = 6;
            [cell.contentView addSubview:imageView];
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        if (cellID == MDACTopListCellID || cellID == MDACMiddleListCellID || cellID == MDACBottomListCellID || cellID == MDACSingleListCellID) {
            textLabel = (UILabel *)[cell.contentView viewWithTag:1];
            detailTextLabel = (UILabel *)[cell.contentView viewWithTag:2];
            linkAvailableImageView = (UIImageView *)[cell.contentView viewWithTag:3];
        } else if (cellID == MDACIconCellID) {
            textLabel = (UILabel *)[cell.contentView viewWithTag:1];
            detailTextLabel = (UILabel *)[cell.contentView viewWithTag:2];
            iconView = (UIImageView *)[cell.contentView viewWithTag:4];
            containerView = (UIImageView *)[cell.contentView viewWithTag:5];
        } else if (cellID == MDACTextCellID) {
            textLabel = (UILabel *)[cell.contentView viewWithTag:1];
        } else if (cellID == MDACListTitleCellID) {
            textLabel = (UILabel *)[cell.contentView viewWithTag:1];
        } else if (cellID == MDACImageCellID) {
            imageView = (UIImageView *)[cell.contentView viewWithTag:6];
        }
    }
    
    if ([credit isMemberOfClass:[MDACListCredit class]]) {
        if (cellID == MDACListTitleCellID) {
            textLabel.text = [(MDACListCredit *)credit title];
        } else {
            textLabel.text = [(MDACListCredit *)credit itemAtIndex:index].name;
            detailTextLabel.text = [[(MDACListCredit *)credit itemAtIndex:index].role lowercaseString];
            
            [textLabel sizeToFit];
            [detailTextLabel sizeToFit];
            
            BOOL selectable = ([(MDACListCredit *)credit itemAtIndex:index].link || [(MDACListCredit *)credit itemAtIndex:index].viewController);
            
            if ([delegate respondsToSelector:@selector(aboutController:isItemSelectable:fromCredit:withIdentifier:)]) {
                selectable = [delegate aboutController:self isItemSelectable:[(MDACListCredit *)credit itemAtIndex:index] fromCredit:credit withIdentifier:[(MDACListCredit *)credit itemAtIndex:index].identifier];
            }
            
            if (selectable) {
                linkAvailableImageView.hidden = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            } else {
                linkAvailableImageView.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (detailTextLabel.text) {
                textLabel.frame = CGRectMake(114, floorf((cell.contentView.bounds.size.height-textLabel.bounds.size.height)/2.-2), textLabel.bounds.size.width, textLabel.bounds.size.height);
                detailTextLabel.frame = CGRectMake(24, floorf((cell.contentView.bounds.size.height-detailTextLabel.bounds.size.height)/2.-1), 80, detailTextLabel.bounds.size.height);
            } else {
                textLabel.frame = CGRectMake(24, roundf((cell.contentView.bounds.size.height-textLabel.bounds.size.height)/2.-2), textLabel.bounds.size.width, textLabel.bounds.size.height);
            }
        }
    } else if ([credit isMemberOfClass:[MDACIconCredit class]]) {
        textLabel.text = [(MDACIconCredit *)credit appName];
        detailTextLabel.text = [(MDACIconCredit *)credit versionString];
        iconView.image = [(MDACIconCredit *)credit icon];
        CGRect containerFrame = containerView.frame;
        containerFrame.size.width = iconView.bounds.size.width + 35 + MAX([textLabel sizeThatFits:CGSizeZero].width , [detailTextLabel sizeThatFits:CGSizeZero].width);
        if (containerFrame.size.width > 300) containerFrame.size.width = 300;
        containerFrame.origin.x = roundf((cell.contentView.bounds.size.width-containerFrame.size.width)/(CGFloat)2.);
        containerView.frame = containerFrame;
    } else if ([credit isMemberOfClass:[MDACTextCredit class]]) {
        textLabel.textAlignment = [(MDACTextCredit *)credit textAlignment];
        textLabel.font = [(MDACTextCredit *)credit font];
        textLabel.text = [(MDACTextCredit *)credit text];
        textLabel.highlighted = ([(MDACTextCredit *)credit link] || [(MDACTextCredit *)credit viewController]);
    } else if ([credit isMemberOfClass:[MDACImageCredit class]]) {
        imageView.image = [(MDACImageCredit *)credit image];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.hasSimpleBackground || [cell.reuseIdentifier isEqualToString:MDACSpacerCellID] || [cell.reuseIdentifier isEqualToString:MDACListTitleCellID])
        cell.backgroundColor = [UIColor clearColor];
}

- (void)openMailToRecipient:(NSString *)recipient subject:(NSString *)subject
{
    UIViewController *mailer = [[NSClassFromString(@"MFMailComposeViewController") alloc] init];
    [mailer performSelector:@selector(setMailComposeDelegate:) withObject:self];
    [mailer performSelector:@selector(setToRecipients:) withObject:[NSArray arrayWithObject:recipient]];
    [mailer performSelector:@selector(setSubject:) withObject:subject];
    
    UIViewController *parent = self;
    
//    if ([self isViewLoaded] && self.view.window.rootViewController != nil) {
//        parent = self.view.window.rootViewController;
//    }
    
    if ([delegate respondsToSelector:@selector(viewControllerToPresentMailController:)]) {
        parent = [delegate viewControllerToPresentMailController:self];
    }
    
    if ([delegate respondsToSelector:@selector(aboutControllerWillPresentMailController:)]) {
        [delegate aboutControllerWillPresentMailController:self];
    }
    
    // dear compiler warning... shut up
    // the following should be fully backwards compatible.
    if ([parent respondsToSelector:@selector(presentViewController:animated:completion:)]) {
//        objc_msgSend(parent, @selector(presentViewController:animated:completion:), mailer, YES, NULL);
        [self presentViewController:mailer animated:YES completion:NULL];
    } else {
        typedef void (*presentViewController_type)(UIViewController *, SEL, UIViewController *, BOOL);
        presentViewController_type presentViewController = (presentViewController_type)objc_msgSend;
        
        presentViewController(parent, @selector(presentModalViewController:animated:), mailer, YES);
//        [self presentModalViewController:mailer animated:YES];
    }
}

- (void)mailComposeController:(id)controller didFinishWithResult:(int)result error:(NSError *)error
{
//    UIViewController *parent = self;
//    
//    if ([self isViewLoaded] && self.view.window.rootViewController != nil) {
//        parent = self.view.window.rootViewController;
//    }
    
    [controller dismissModalViewControllerAnimated:YES];
    
    if ([delegate respondsToSelector:@selector(aboutControllerDidDismissMailController:)]) {
        [delegate aboutControllerDidDismissMailController:self];
    }
}

- (void)tableView:(UITableView *)aTableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDACCredit *credit = nil;
    id cellID = nil;
    NSUInteger index = 0;
    
    [self generateCachedCellsIfNeeded];
    
    if ((NSNull *)[cachedCellCredits objectAtIndex:indexPath.row] != [NSNull null])
        credit = [cachedCellCredits objectAtIndex:indexPath.row];
    
    if ((NSNull *)[cachedCellIndices objectAtIndex:indexPath.row] != [NSNull null])
        index = [[cachedCellIndices objectAtIndex:indexPath.row] integerValue];
    
    if ((NSNull *)[cachedCellIDs objectAtIndex:indexPath.row] != [NSNull null])
        cellID = [cachedCellIDs objectAtIndex:indexPath.row];
    
    if ([credit isMemberOfClass:[MDACTextCredit class]] && ([(MDACTextCredit *)credit link] || [(MDACTextCredit *)credit viewController])) {
        UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
        
        textLabel.highlighted = NO;
    }
}

- (void)tableView:(UITableView *)aTableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleCells = [aTableView visibleCells];
    
    for (UITableViewCell *cell in visibleCells) {
        NSIndexPath *indexPath = [aTableView indexPathForCell:cell];
        
        MDACCredit *credit = nil;
        id cellID = nil;
        NSUInteger index = 0;
        
        [self generateCachedCellsIfNeeded];
        
        if ((NSNull *)[cachedCellCredits objectAtIndex:indexPath.row] != [NSNull null])
            credit = [cachedCellCredits objectAtIndex:indexPath.row];
        
        if ((NSNull *)[cachedCellIndices objectAtIndex:indexPath.row] != [NSNull null])
            index = [[cachedCellIndices objectAtIndex:indexPath.row] integerValue];
        
        if ((NSNull *)[cachedCellIDs objectAtIndex:indexPath.row] != [NSNull null])
            cellID = [cachedCellIDs objectAtIndex:indexPath.row];
        
        if ([credit isMemberOfClass:[MDACTextCredit class]] && ([(MDACTextCredit *)credit link] || [(MDACTextCredit *)credit viewController])) {
            UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
            UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
            
            textLabel.highlighted = YES;
        }
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MDACCredit *credit = nil;
    id cellID = nil;
    NSUInteger index = 0;
    
    [self generateCachedCellsIfNeeded];
    
    if (indexPath.row >= [cachedCellCredits count]) return;
    
    if ((NSNull *)[cachedCellCredits objectAtIndex:indexPath.row] != [NSNull null])
        credit = [cachedCellCredits objectAtIndex:indexPath.row];
    
    if ((NSNull *)[cachedCellIndices objectAtIndex:indexPath.row] != [NSNull null])
        index = [[cachedCellIndices objectAtIndex:indexPath.row] integerValue];
    
    if ((NSNull *)[cachedCellIDs objectAtIndex:indexPath.row] != [NSNull null])
        cellID = [cachedCellIDs objectAtIndex:indexPath.row];
    
    if ([credit isMemberOfClass:[MDACTextCredit class]] && ([(MDACTextCredit *)credit link] || [(MDACTextCredit *)credit viewController])) {
        UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
        
        textLabel.highlighted = YES;
    }
    
    NSURL *url = nil;
    MDACCreditItem *item = nil;
    NSString *identifier = credit.identifier;
    NSString *controllerName = credit.viewController;
    if ([credit isMemberOfClass:[MDACListCredit class]] && cellID != MDACListTitleCellID) {
        item = [(MDACListCredit *)credit itemAtIndex:index];
        url = item.link;
        identifier = item.identifier;
        controllerName = item.viewController;
    } else if ([credit isMemberOfClass:[MDACTextCredit class]]) {
        url = [(MDACTextCredit *)credit link];
    }
    
    Class ViewController = Nil;
    
    if (controllerName) {
        ViewController = NSClassFromString(controllerName);
        if (![ViewController isSubclassOfClass:[UIViewController class]]) {
            ViewController = Nil;
        }
    }
    
    if (ViewController) {
        UIViewController *viewController = [[ViewController alloc] init];
        if (![delegate respondsToSelector:@selector(aboutController:shouldPresentController:forItem:fromCredit:withIdentifier:)] || [delegate aboutController:self shouldPresentController:viewController forItem:item fromCredit:credit withIdentifier:identifier]) {
            UIViewController *parentController = nil;
            if ([delegate respondsToSelector:@selector(aboutController:viewControllerToPresentAuxiliaryController:forItem:fromCredit:withIdentifier:)]) {
                parentController = [delegate aboutController:self viewControllerToPresentAuxiliaryController:viewController forItem:item fromCredit:credit withIdentifier:identifier];
            }
            if (parentController || !self.navigationController) {
                if (!parentController) parentController = self;
                if ([delegate respondsToSelector:@selector(aboutController:willPresentAuxiliaryController:forItem:fromCredit:withIdentifier:)]) {
                    [delegate aboutController:self willPresentAuxiliaryController:viewController forItem:item fromCredit:credit withIdentifier:identifier];
                }
                [parentController presentViewController:viewController animated:YES completion:^{
                    if ([delegate respondsToSelector:@selector(aboutController:didPresentAuxiliaryController:forItem:fromCredit:withIdentifier:)]) {
                        [delegate aboutController:self didPresentAuxiliaryController:viewController forItem:item fromCredit:credit withIdentifier:identifier];
                    }
                }];
            } else if (self.navigationController) {
                UIViewController *viewController = [[ViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    } else if (url && (![delegate respondsToSelector:@selector(aboutController:shouldOpenURL:forItem:fromCredit:withIdentifier:)] || [delegate aboutController:self shouldOpenURL:url forItem:item fromCredit:credit withIdentifier:identifier])) {
        if ([url.scheme isEqualToString:@"mailto"]) {
            if (NSClassFromString(@"MFMailComposeViewController") && [NSClassFromString(@"MFMailComposeViewController") canSendMail]) {
                NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
                NSString *versionString = nil;
                NSString *bundleShortVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSString *bundleVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                
                if (bundleShortVersionString && bundleVersionString) {
                    versionString = [NSString stringWithFormat:@" %@ (%@)",
                                     bundleShortVersionString,
                                     bundleVersionString];
                } else if (bundleShortVersionString) {
                    versionString = [NSString stringWithFormat:@" %@", bundleShortVersionString];
                } else if (bundleVersionString) {
                    versionString = [NSString stringWithFormat:@" %@", bundleVersionString];
                }
                NSString *subject = [NSString stringWithFormat:@"%@%@ Support", appName, versionString];
                
                NSString *recipient = [url resourceSpecifier];
                if ([[(MDACListCredit *)credit itemAtIndex:index].userAssociations objectForKey:@"EmailName"]) {
                    recipient = [NSString stringWithFormat:@"%@ <%@>", [[(MDACListCredit *)credit itemAtIndex:index].userAssociations objectForKey:@"EmailName"], recipient];
                }
                
                if ([[(MDACListCredit *)credit itemAtIndex:index].userAssociations objectForKey:@"Subject"]) {
                    subject = [[(MDACListCredit *)credit itemAtIndex:index].userAssociations objectForKey:@"Subject"];
                }
                
                [self openMailToRecipient:recipient subject:subject];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else if (!self.navigationController || ([[url absoluteString] rangeOfString:@"itunes.apple.com"].location != NSNotFound)) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            MDACWebViewController *linkViewController = [[MDACWebViewController alloc] initWithURL:url];
            [[self navigationController] pushViewController:linkViewController animated:YES];
        }
    }
                   
    if ([delegate respondsToSelector:@selector(aboutController:didSelectItem:fromCredit:withIdentifier:)]) {
        [delegate aboutController:self didSelectItem:item fromCredit:credit withIdentifier:identifier];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self generateCachedCellsIfNeeded];
    return [[cachedCellHeights objectAtIndex:indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self generateCachedCellsIfNeeded];
    return [cachedCellCredits count];
}

- (void)loadView
{
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    self.view = rootView;
    rootView.backgroundColor = self.backgroundColor;
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, rootView.bounds.size.width, rootView.bounds.size.height-44) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.backgroundColor = self.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rootView addSubview:tableView];
    
    MDACTitleBar *aTitleBar = [[MDACTitleBar alloc] initWithController:self];
    aTitleBar.title = self.navigationItem.title;
    self.titleBar = aTitleBar;
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.showsTitleBar = !self.navigationController;
    if ([delegate respondsToSelector:@selector(aboutControllerShouldDisplayDoneButton:)]) {
        [(MDACTitleBar *)titleBar setButtonHidden:![delegate aboutControllerShouldDisplayDoneButton:self]];
    } else if ([titleBar isMemberOfClass:[MDACTitleBar class]]) {
        [(MDACTitleBar *)titleBar setButtonHidden:(self.parentViewController.class == [UITabBarController class])];
    }
    
    if (!self.navigationController.navigationBarHidden && self.navigationController.navigationBar.translucent && ![self respondsToSelector:@selector(topLayoutGuide)]) {
        tableView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height, 0, 0, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height, 0, 0, 0);
    }
}

- (void)setTitleBar:(UIView *)aTitleBar
{
    if (aTitleBar != titleBar) {
        [self.view addSubview:aTitleBar];
        [titleBar removeFromSuperview];
        
        titleBar = aTitleBar;
        
        titleBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        
        self.showsTitleBar = showsTitleBar;
    }
}

- (void)setShowsTitleBar:(BOOL)yn
{
    [self setShowsTitleBar:yn animated:NO];
}

- (void)setShowsTitleBar:(BOOL)yn animated:(BOOL)animated
{
    showsTitleBar = yn;
    
    if (showsTitleBar) {
        titleBar.hidden = NO;
        if (animated) {
            [UIView animateWithDuration:0.15 delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^(void) {
                                 titleBar.alpha = 1.;
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.25 delay:0
                                                     options:UIViewAnimationOptionBeginFromCurrentState
                                                  animations:^(void) {
                                                      titleBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, titleBar.bounds.size.height);
                                                      tableView.frame = CGRectMake(0, titleBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-titleBar.bounds.size.height);
                                                  }
                                                  completion:NULL];
                             }];
            
        } else {
            titleBar.alpha = 1.;
            titleBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, titleBar.bounds.size.height);
            tableView.frame = CGRectMake(0, titleBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-titleBar.bounds.size.height);
        }
    } else {
        if (animated) {
            [UIView animateWithDuration:0.25 delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^(void) {
                                 titleBar.frame = CGRectMake(0, -titleBar.bounds.size.height, self.view.bounds.size.width, titleBar.bounds.size.height);
                                 tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.15 delay:0
                                                     options:UIViewAnimationOptionBeginFromCurrentState
                                                  animations:^(void) {
                                                      titleBar.alpha = 0;
                                                  }
                                                  completion:^(BOOL finished) {
                                                      titleBar.hidden = YES;
                                                  }];
                             }];
            
        } else {
            titleBar.hidden = YES;
            titleBar.alpha = 0;
            titleBar.frame = CGRectMake(0, -titleBar.bounds.size.height, self.view.bounds.size.width, titleBar.bounds.size.height);
            tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        }
    }
}

- (void)viewDidUnload
{
    self.titleBar = nil;
    tableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)generateIconIfNeeded
{
    if (iconImage) return;
    
    NSMutableDictionary *infoDict = [[[NSBundle mainBundle] infoDictionary] mutableCopy];
    BOOL iconPrerendered = NO;
    
    NSArray *iconRefs = [infoDict objectForKey:@"CFBundleIconFiles"];
    iconPrerendered = [[infoDict objectForKey:@"UIPrerenderedIcon"] boolValue];
    
    if (!iconRefs) {
        iconRefs = [(NSDictionary *)[(NSDictionary *)[(NSDictionary *)infoDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"];
        iconPrerendered = [[(NSDictionary *)[(NSDictionary *)[(NSDictionary *)infoDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"UIPrerenderedIcon"] boolValue];
    }
    
    CGFloat targetSize = 57;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        targetSize = 72;
    }
    
    
    if (NSClassFromString(@"UIMotionEffect")) {
        iconPrerendered = YES;
        
        targetSize = 60;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            targetSize = 76;
        }
    }
    
    targetSize *= [UIScreen mainScreen].scale;
    
    if (iconRefs) {
        float lastSize = 0;
        
        NSMutableArray *icons = [[NSMutableArray alloc] init];
        
        for (NSString *iconRef in iconRefs) {
            UIImage *imageA = [UIImage imageNamed:iconRef];
            
            if (!imageA) {
                NSLog(@"%@: Warning: The icon `%@` was not found.", self, iconRef);
                return;
            }
            
            NSUInteger i = 0;
            
            for (i = 0; i < [icons count]; i++) {
                UIImage *imageB = [icons objectAtIndex:i];
                if (imageA.size.width*imageA.scale < imageB.size.width*imageB.scale)
                    break;
            }
            
            [icons insertObject:imageA atIndex:i];
        }
        
        for (UIImage *testIcon in icons) {
            if (testIcon.size.width*testIcon.scale > lastSize ) {
                lastSize = testIcon.size.width*testIcon.scale;
                iconImage = testIcon;
                
                if (testIcon.size.width*testIcon.scale >= targetSize)
                    break;
            }
        }
        
    } else {
        iconImage = [UIImage imageNamed:[infoDict objectForKey:@"CFBundleIconFile"]];
    }
    
    if (iconImage) {
        if (!iconPrerendered) {
            UIImage *overlay = [UIImage imageNamed:@"MDACIconOverlay.png"];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(iconImage.size.width*iconImage.scale, iconImage.size.height*iconImage.scale), NO, 1);
            [iconImage drawAtPoint:CGPointZero];
            [overlay drawInRect:CGRectMake(-1*overlay.scale, -1*overlay.scale, overlay.size.width*overlay.scale, overlay.size.height*overlay.scale)];
            iconImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        UIImage *maskImage = [UIImage imageNamed:@"MDACIconMask.png"];
        
        if (NSClassFromString(@"UIMotionEffect")) {
            maskImage = [UIImage imageNamed:@"MDACIconMask-ios7.png"];
            
            UIGraphicsBeginImageContextWithOptions(maskImage.size, YES, maskImage.scale);
            
            [[UIColor whiteColor] setFill];
            UIRectFill(CGRectMake(0, 0, maskImage.size.width, maskImage.size.height));
            [maskImage drawAtPoint:CGPointZero];
            
            maskImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        iconImage = [iconImage maskedImageWithMask:maskImage];
    }
}

#pragma mark - Manipulating Credits

- (void)reloadCredits
{
    if (!reloadingCredits) {
        reloadingCredits = YES;
        [self performSelector:@selector(_reloadCreditsNow) withObject:nil afterDelay:0];
    }
}

- (void)_reloadCreditsNow
{
    reloadingCredits = NO;
    
    [credits removeAllObjects];
    
    NSMutableDictionary *infoDict = [[[NSBundle mainBundle] infoDictionary] mutableCopy];
    NSDictionary *localizedInfoDict = [[NSBundle mainBundle] localizedInfoDictionary];
    
    [infoDict addEntriesFromDictionary:localizedInfoDict];
    
    NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
    NSString *versionString = nil;
    
    NSString *bundleShortVersionString = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleVersionString = [infoDict objectForKey:@"CFBundleVersion"];
    
    if (bundleShortVersionString && bundleVersionString) {
        versionString = [NSString stringWithFormat:[self _longLocalizedVersionFormatString],
                         bundleShortVersionString,
                         bundleVersionString];
    } else if (bundleShortVersionString) {
        versionString = [NSString stringWithFormat:[self _shortLocalizedVersionFormatString], bundleShortVersionString];
    } else if (bundleVersionString) {
        versionString = [NSString stringWithFormat:[self _shortLocalizedVersionFormatString], bundleVersionString];
    }
    
    [self generateIconIfNeeded];
    
    UIImage *icon = iconImage;
    
    [credits addObject:[MDACIconCredit iconCreditWithAppName:appName versionString:versionString icon:icon]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.creditsName ofType:@"plist"];
    if (path) {
        NSArray *creditsFile = [[NSArray alloc] initWithContentsOfFile:path];
        if (creditsFile) {
            for (NSDictionary *creditDict in creditsFile) {
                if (creditDict) {
                    if ([[creditDict objectForKey:@"Type"] isEqualToString:@"List"]) {
                        [credits addObject:[MDACListCredit listCreditWithDictionary:creditDict]];
                    } else if ([[creditDict objectForKey:@"Type"] isEqualToString:@"Text"]) {
                        [credits addObject:[MDACTextCredit textCreditWithDictionary:creditDict]];
                    } if ([[creditDict objectForKey:@"Type"] isEqualToString:@"Image"]) {
                        [credits addObject:[MDACImageCredit imageCreditWithDictionary:creditDict]];
                    }
                }
            }
        }
    }
    
    if (self.showsAttributions) {    
        int numClasses;
        Class *classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        
        if (numClasses > 0 ) {
            classes = (Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            
            for (int i = 0; i < numClasses; i++) {
                Class actualClass = object_getClass(classes[i]);
                if (actualClass && class_respondsToSelector(actualClass, @selector(respondsToSelector:))) {
                    unsigned int numMethods = 0;
                    Method *methods = class_copyMethodList(actualClass, &numMethods);
                    
                    for (int j = 0; j < numMethods; j++) {
                        if (method_getName(methods[j]) == @selector(MDAboutControllerTextCreditDictionary)) {
                            //                            NSLog(@"Class %@ is included", NSStringFromClass(classes[i]));
                            [credits addObject:[MDACTextCredit textCreditWithDictionary:[classes[i] performSelector:@selector(MDAboutControllerTextCreditDictionary)]]];
                        }
                    }
                    free(methods);
                }
            }
            free(classes);
        }
        
        [credits addObject:[MDACTextCredit textCreditWithText:@"About screen powered by MDAboutViewController, available free on GitHub!"
                                                         font:[UIFont boldSystemFontOfSize:11]
                                                    alignment:NSTextAlignmentCenter
                                                      linkURL:[NSURL URLWithString:@"https://github.com/mochidev/MDAboutControllerDemo"]]];
    }
    
    if ([delegate respondsToSelector:@selector(aboutControllerDidReloadCredits:)]) {
        [delegate aboutControllerDidReloadCredits:self];
    }
    
    cachedCellCredits = nil;
    [tableView reloadData];
}

- (void)addCredit:(MDACCredit *)aCredit
{
    [credits addObject:aCredit];
    
    cachedCellCredits = nil;
    
    [tableView reloadData];
}

- (void)insertCredit:(MDACCredit *)aCredit atIndex:(NSUInteger)index
{
    [credits insertObject:aCredit atIndex:index];
    
    cachedCellCredits = nil;
    
    [tableView reloadData];
}

- (void)replaceCreditAtIndex:(NSUInteger)index withCredit:(MDACCredit *)aCredit
{
    [credits replaceObjectAtIndex:index withObject:aCredit];
    
    cachedCellCredits = nil;
    
    [tableView reloadData];
}

- (void)removeLastCredit
{
    [credits removeLastObject];
    
    cachedCellCredits = nil;
    
    [tableView reloadData];
}

- (void)removeCredit:(MDACCredit *)aCredit
{
    [credits removeObject:aCredit];
    
    cachedCellCredits = nil;
    
    [tableView reloadData];
}

- (void)removeCreditAtIndex:(NSUInteger)index
{
    [credits removeObjectAtIndex:index];
    
    cachedCellCredits = nil;
    
    [tableView reloadData];
}

- (NSUInteger)creditCount
{
    return [credits count];
}

#pragma mark - Localization

- (NSString *)_localizedAboutString
{
    static NSDictionary *locales = nil;
    if (!locales) {
        locales = [@{
        @"en" : @"About",
        @"fr" : @"Informations",
        @"ja" : @"情報"} copy];
    }
    
    NSString *formatString = nil;
    
    NSMutableArray *preferedLanguages = [[NSLocale preferredLanguages] mutableCopy];
//    [preferedLanguages insertObject:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] atIndex:0];
    // That should have grabbed the current localization the app is in, but doesn't…
    
    for (NSString *languageCode in preferedLanguages) {
        if ((formatString = [locales objectForKey:languageCode])) {
            return formatString;
        }
    }
    
    return [locales objectForKey:@"en"];
}

- (NSString *)_shortLocalizedVersionFormatString
{
    static NSDictionary *locales = nil;
    if (!locales) {
        locales = [@{
        @"en" : @"Version %@",
        @"fr" : @"Version %@",
        @"ja" : @"バージョン %@",
        @"ar" : @"الإصدار %@"} copy]; // Check /System/Library/CoreServices/SystemVersion.bundle/ for more!
    }
    
    NSString *formatString = nil;
    
    NSMutableArray *preferedLanguages = [[NSLocale preferredLanguages] mutableCopy];
//    [preferedLanguages insertObject:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] atIndex:0];
    
    for (NSString *languageCode in preferedLanguages) {
        if ((formatString = [locales objectForKey:languageCode])) {
            return formatString;
        }
    }
    
    return [locales objectForKey:@"en"];
}

- (NSString *)_longLocalizedVersionFormatString
{
    static NSDictionary *locales = nil;
    if (!locales) {
        locales = [@{
                    @"en" : @"Version %@ (%@)",
                    @"fr" : @"Version %@ (%@)",
                    @"ja" : @"バージョン %@ (%@)",
                    @"ar" : @"الإصدار %@ (%@)"} copy]; // Check /System/Library/CoreServices/SystemVersion.bundle/ for more!
    }
    
    NSString *formatString = nil;
    
    NSMutableArray *preferedLanguages = [[NSLocale preferredLanguages] mutableCopy];
//    [preferedLanguages insertObject:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] atIndex:0];
    
    for (NSString *languageCode in preferedLanguages) {
        if ((formatString = [locales objectForKey:languageCode])) {
            return formatString;
        }
    }
    
    return [locales objectForKey:@"en"];
}

@end

