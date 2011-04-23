//
//  MDAboutController.m
//  MDAboutController
//
//  Created by Dimitri Bouniol on 4/18/11.
//  Copyright 2011 Mochi Development Inc. All rights reserved.
//
//  Copyright (c) 2010 Dimitri Bouniol, Mochi Development, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Also, it'd be super awesome if you left in the credit line generated
//  automatically by the code that links back to this page :)
//

#import "MDAboutController.h"

#pragma mark Constants

static NSString *MDACIconCellID = @"MDACIconCell";
static NSString *MDACSpacerCellID = @"MDACSpacerCell";
static NSString *MDACTopListCellID = @"MDACTopListCell";
static NSString *MDACMiddleListCellID = @"MDACMiddleListCell";
static NSString *MDACBottomListCellID = @"MDACBottomListCell";
static NSString *MDACSingleListCellID = @"MDACSingleListCell";
static NSString *MDACTextCellID = @"MDACTextCell";
static NSString *MDACImageCellID = @"MDACImageCell";

#pragma mark - MDACTitleBar

@interface MDACTitleBar : UIView {
    UILabel *title;
    UIButton *doneButton;
    
    UIImageView *background;
}

- (id)initWithController:(MDAboutController *)controller;

@end

@implementation MDACTitleBar

- (id)initWithController:(MDAboutController *)controller
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, 44)])) {
        background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
        background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        background.image = [UIImage imageNamed:@"MDACTitleBar.png"];
        background.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:background];
        [background release];
        
        title = [[UILabel alloc] initWithFrame:self.bounds];
        title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        title.backgroundColor = nil;
        title.opaque = NO;
        title.textAlignment = UITextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        title.text = @"About";
        title.font = [UIFont boldSystemFontOfSize:20];
        title.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
        title.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:title];
        [title release];
        
        doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-55, 7, 50, 30)];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [doneButton setBackgroundImage:[UIImage imageNamed:@"MDACDoneButton.png"] forState:UIControlStateNormal];
        [doneButton setBackgroundImage:[UIImage imageNamed:@"MDACDoneButtonPressed.png"] forState:UIControlStateHighlighted];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        doneButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [doneButton addTarget:controller action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
        [doneButton release];
    }
    return self;
}

@end

#pragma mark - MDACCredit Classes

@interface MDACCredit : NSObject {
    NSString *type;
}

@property(nonatomic, copy) NSString *type;
- (id)initWithType:(NSString *)aType;
+ (id)credit;
+ (id)creditWithType:(NSString *)aType;

@end

@implementation MDACCredit

@synthesize type;

- (id)initWithType:(NSString *)aType
{
    if ((self = [super init])) {
        self.type = aType;
    }
    return self;
}

- (id)init
{
    return [self initWithType:nil];
}

+ (id)creditWithType:(NSString *)aType
{
    return [[[self alloc] initWithType:aType] autorelease];
}

+ (id)credit
{
    return [self creditWithType:nil];
}

- (void)dealloc {
    [type release];
    [super dealloc];
}

@end

@interface MDACCreditItem : NSObject {
    NSString *name;
    NSString *role;
    NSURL *link;
}

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *role;
@property(nonatomic, retain) NSURL *link;
- (id)initWithName:(NSString *)aName role:(NSString *)aRole linkURL:(NSURL *)anURL;
- (id)initWithName:(NSString *)aName role:(NSString *)aRole linkString:(NSString *)aLink;
+ (id)itemWithName:(NSString *)aName role:(NSString *)aRole linkURL:(NSURL *)anURL;
+ (id)itemWithName:(NSString *)aName role:(NSString *)aRole linkString:(NSString *)aLink;
+ (id)item;
- (id)initWithDictionary:(NSDictionary *)aDict;
+ (id)itemWithDictionary:(NSDictionary *)aDict;

@end

@implementation MDACCreditItem

@synthesize name, role, link;

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
    return [self itemWithName:aName role:aRole linkURL:[NSURL URLWithString:aLink]];
}

+ (id)item
{
    return [self itemWithName:nil role:nil linkURL:nil];
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    return [self initWithName:[aDict objectForKey:@"Name"]
                         role:[aDict objectForKey:@"Role"]
                   linkString:[aDict objectForKey:@"Link"]];
}

+ (id)itemWithDictionary:(NSDictionary *)aDict
{
    return [[[self alloc] initWithDictionary:aDict] autorelease];
}

- (void)dealloc {
    [name release];
    [role release];
    [link release];
    [super dealloc];
}

@end

@interface MDACListCredit : MDACCredit {
    NSString *title;
    NSMutableArray *items;
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic, readonly) NSUInteger count;
- (id)initWithTitle:(NSString *)aTitle;
+ (id)listCreditWithTitle:(NSString *)aTitle;
- (id)initWithDictionary:(NSDictionary *)aDict;
+ (id)listCreditWithDictionary:(NSDictionary *)aDict;

- (void)addItem:(MDACCreditItem *)anItem;
- (void)removeItem:(MDACCreditItem *)anItem;
- (MDACCreditItem *)itemAtIndex:(NSUInteger)index;

@end

@implementation MDACListCredit

@synthesize title;

- (id)initWithTitle:(NSString *)aTitle
{
    if ((self = [super initWithType:@"List"])) {
        self.title = aTitle;
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithType:(NSString *)aType
{
    return [self initWithTitle:nil];
}

+ (id)creditWithType:(NSString *)aType
{
    return [self listCreditWithTitle:nil];
}

+ (id)listCreditWithTitle:(NSString *)aTitle
{
    return [[[self alloc] initWithTitle:aTitle] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    if ((self = [self initWithTitle:[aDict objectForKey:@"Title"]])) {
        NSArray *itemsList = [aDict objectForKey:@"Items"];
        for (NSDictionary *item in itemsList) {
            [self addItem:[MDACCreditItem itemWithDictionary:item]];
        }
    }
    return self;
}

+ (id)listCreditWithDictionary:(NSDictionary *)aDict
{
    return [[[self alloc] initWithDictionary:aDict] autorelease];
}

- (NSUInteger)count
{
    return [items count];
}

- (void)addItem:(MDACCreditItem *)anItem
{
    [items addObject:anItem];
}

- (void)removeItem:(MDACCreditItem *)anItem
{
    [items removeObject:anItem];
}

- (MDACCreditItem *)itemAtIndex:(NSUInteger)index
{
    return [items objectAtIndex:index];
}

- (void)dealloc {
    [title release];
    [items release];
    [super dealloc];
}

@end

@interface MDACIconCredit : MDACCredit {
    NSString *appName;
    NSString *versionString;
    UIImage *icon;
}

@property(nonatomic, copy) NSString *appName;
@property(nonatomic, copy) NSString *versionString;
@property(nonatomic, retain) UIImage *icon;
- (id)initWithAppName:(NSString *)aName versionString:(NSString *)aVersionString icon:(UIImage *)anImage;
+ (id)iconCreditWithAppName:(NSString *)aName versionString:(NSString *)aVersionString icon:(UIImage *)anImage;

@end

@implementation MDACIconCredit

@synthesize appName, versionString, icon;

- (id)initWithAppName:(NSString *)aName versionString:(NSString *)aVersionString icon:(UIImage *)anImage
{
    if ((self = [super initWithType:@"List"])) {
        self.appName = aName;
        self.versionString = aVersionString;
        self.icon = anImage;
    }
    return self;
}

- (id)initWithType:(NSString *)aType
{
    return [self initWithAppName:nil versionString:nil icon:nil];
}

+ (id)creditWithType:(NSString *)aType
{
    return [self iconCreditWithAppName:nil versionString:nil icon:nil];
}

+ (id)iconCreditWithAppName:(NSString *)aName versionString:(NSString *)aVersionString icon:(UIImage *)anImage;
{
    return [[[self alloc] initWithAppName:aName versionString:aVersionString icon:anImage] autorelease];
}

- (void)dealloc {
    [appName release];
    [versionString release];
    [icon release];
    [super dealloc];
}

@end

#pragma mark - MDAboutController

@implementation MDAboutController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        credits = [[NSMutableArray alloc] init];
        
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        NSString *versionString = nil;
        
        if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] && [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]) {
            versionString = [NSString stringWithFormat:@"Version %@ (%@)",
                             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        } else if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]) {
            versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        } else if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]) {
            versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        }
		
        UIImage *icon = nil;
        
        if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFiles"]) {
            NSArray *iconRefs = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFiles"];
            
            float targetSize = 57.*[UIScreen mainScreen].scale;
            float lastSize = 0;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                targetSize = 72;
            }
            
            NSMutableArray *icons = [[NSMutableArray alloc] init];
            
            for (NSString *iconRef in iconRefs) {
                UIImage *imageA = [UIImage imageNamed:iconRef];
                
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
                    icon = testIcon;
                    
                    if (testIcon.size.width*testIcon.scale >= targetSize)
                        break;
                }
            }
        } else {
            icon = [UIImage imageNamed:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIconFile"]];
        }
        
        [credits addObject:[MDACIconCredit iconCreditWithAppName:appName versionString:versionString icon:icon]];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"plist"];
        if (path) {
            NSArray *creditsFile = [[NSArray alloc] initWithContentsOfFile:path];
            if (creditsFile) {
                for (NSDictionary *creditDict in creditsFile) {
                    if (creditDict) {
                        if ([[creditDict objectForKey:@"Type"] isEqualToString:@"List"]) {
                            [credits addObject:[MDACListCredit listCreditWithDictionary:creditDict]];
                        } else {
                            // more types here
                        }
                    }
                }
            }
            [creditsFile release];
        }
    }
    return self;
}

- (void)dealloc
{
    [cachedCellCredits release];
    [cachedCellHeights release];
    [cachedCellIDs release];
    [cachedCellIndices release];
    [credits release];
    [super dealloc];
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
    [cachedCellCredits release];
    [cachedCellHeights release];
    [cachedCellIDs release];
    [cachedCellIndices release];
    
    cachedCellCredits = [[NSMutableArray alloc] init];
    cachedCellHeights = [[NSMutableArray alloc] init];
    cachedCellIDs = [[NSMutableArray alloc] init];
    cachedCellIndices = [[NSMutableArray alloc] init];
    
    NSString *cellID;
    NSUInteger index, count;
    
    int i = 1;
    int j;
    
    [cachedCellCredits addObject:[NSNull null]];
    [cachedCellHeights addObject:[NSNumber numberWithFloat:25]];
    [cachedCellIDs addObject:MDACSpacerCellID];
    [cachedCellIndices addObject:[NSNull null]];
    
    for (MDACCredit *tempCredit in credits) {
        if ([tempCredit isMemberOfClass:[MDACListCredit class]]) {
            count = [(MDACListCredit *)tempCredit count];
            j = i;
            i += count;
            
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
                [cachedCellHeights addObject:[NSNumber numberWithFloat:44]];
                [cachedCellIDs addObject:cellID];
                [cachedCellIndices addObject:[NSNumber numberWithInteger:index]];
            }
        } else if ([tempCredit isMemberOfClass:[MDACIconCredit class]]) {
            i += 1;
            
            float iconHeight = 57;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                iconHeight = 72;
            
            iconHeight += 20;
            
            [cachedCellCredits addObject:tempCredit];
            [cachedCellHeights addObject:[NSNumber numberWithFloat:iconHeight]];
            [cachedCellIDs addObject:MDACIconCellID];
            [cachedCellIndices addObject:[NSNull null]];
        } else {
            i += 1;
            
            [cachedCellCredits addObject:tempCredit];
            [cachedCellHeights addObject:[NSNumber numberWithFloat:25]];
            [cachedCellIDs addObject:MDACSpacerCellID];
            [cachedCellIndices addObject:[NSNull null]];
        }
        
        i += 1;
        
        [cachedCellCredits addObject:[NSNull null]];
        [cachedCellHeights addObject:[NSNumber numberWithFloat:25]];
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
    
    UILabel *nameLabel, *roleLabel;
    UIImageView *linkAvailableImageView;
    
    if (!cell) {
        if (cellID == MDACTopListCellID || cellID == MDACMiddleListCellID || cellID == MDACBottomListCellID || cellID == MDACSingleListCellID) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
            
            UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width-20, 44)];
            UIImageView *selectedBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width-20, 44)];
            
            if (cellID == MDACTopListCellID) {
                backgroundImage.frame = CGRectMake(10, -1, tableView.bounds.size.width-20, 45);
                backgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundTop.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
                selectedBackgroundImage.frame = CGRectMake(10, -1, tableView.bounds.size.width-20, 45);
                selectedBackgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundSelectedTop.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
            } else if (cellID == MDACMiddleListCellID) {
                backgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundMiddle.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:10];
                selectedBackgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundSelectedMiddle.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:10];
            } else if (cellID == MDACBottomListCellID) {
                backgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundBottom.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
                selectedBackgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundSelectedBottom.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
            } else {
                backgroundImage.frame = CGRectMake(10, -1, tableView.bounds.size.width-20, 45);
                backgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundSingle.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
                selectedBackgroundImage.image = [[UIImage imageNamed:@"MDACCellBackgroundSelectedSingle.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
            }
            
            backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [backgroundView addSubview:backgroundImage];
            [backgroundImage release];
            
            selectedBackgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [selectedBackgroundView addSubview:selectedBackgroundImage];
            [selectedBackgroundImage release];
            
            cell.backgroundView = backgroundView;
            [backgroundView release];
            
            cell.selectedBackgroundView = selectedBackgroundView;
            [selectedBackgroundView release];
            
            nameLabel = [[UILabel alloc] init];
            nameLabel.font = [UIFont boldSystemFontOfSize:17];
            nameLabel.backgroundColor = [UIColor colorWithWhite:94./255. alpha:1];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
            nameLabel.shadowOffset = CGSizeMake(0, -1);
            nameLabel.tag = 1;
            [cell.contentView addSubview:nameLabel];
            [nameLabel release];
            
            roleLabel = [[UILabel alloc] init];
            roleLabel.font = [UIFont boldSystemFontOfSize:15];
            roleLabel.backgroundColor = [UIColor colorWithWhite:94./255. alpha:1];
            roleLabel.textColor = [UIColor whiteColor];
            roleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
            roleLabel.shadowOffset = CGSizeMake(0, -1);
            roleLabel.textAlignment = UITextAlignmentRight;
            roleLabel.tag = 2;
            [cell.contentView addSubview:roleLabel];
            [roleLabel release];
            
            linkAvailableImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.bounds.size.width-39, 9, 24, 24)];
            linkAvailableImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            linkAvailableImageView.image = [UIImage imageNamed:@"MDACLinkArrow.png"];
            linkAvailableImageView.tag = 3;
            [cell.contentView addSubview:linkAvailableImageView];
            [linkAvailableImageView release];
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        if (cellID == MDACTopListCellID || cellID == MDACMiddleListCellID || cellID == MDACBottomListCellID || cellID == MDACSingleListCellID) {
            nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
            roleLabel = (UILabel *)[cell.contentView viewWithTag:2];
            linkAvailableImageView = (UIImageView *)[cell.contentView viewWithTag:3];
        }
    }
    
    if ([credit isMemberOfClass:[MDACListCredit class]]) {
        nameLabel.text = [(MDACListCredit *)credit itemAtIndex:index].name;
        roleLabel.text = [[(MDACListCredit *)credit itemAtIndex:index].role lowercaseString];
        
        [nameLabel sizeToFit];
        [roleLabel sizeToFit];
        
        if ([(MDACListCredit *)credit itemAtIndex:index].link) {
            linkAvailableImageView.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else {
            linkAvailableImageView.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (roleLabel.text) {
            nameLabel.frame = CGRectMake(114, floorf((cell.contentView.bounds.size.height-nameLabel.bounds.size.height)/2.-2), nameLabel.bounds.size.width, nameLabel.bounds.size.height);
            roleLabel.frame = CGRectMake(24, floorf((cell.contentView.bounds.size.height-roleLabel.bounds.size.height)/2.-1), 80, roleLabel.bounds.size.height);
        } else {
            nameLabel.frame = CGRectMake(24, floorf((cell.contentView.bounds.size.height-nameLabel.bounds.size.height)/2.-2), nameLabel.bounds.size.width, nameLabel.bounds.size.height);
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MDACCredit *credit = nil;
    NSUInteger index = 0;
    
    [self generateCachedCellsIfNeeded];
    
    if ((NSNull *)[cachedCellCredits objectAtIndex:indexPath.row] != [NSNull null])
        credit = [cachedCellCredits objectAtIndex:indexPath.row];
    
    if ((NSNull *)[cachedCellIndices objectAtIndex:indexPath.row] != [NSNull null])
        index = [[cachedCellIndices objectAtIndex:indexPath.row] integerValue];
    
    if ([credit isMemberOfClass:[MDACListCredit class]]) {
        if ([(MDACListCredit *)credit itemAtIndex:index].link) {
            [[UIApplication sharedApplication] openURL:[(MDACListCredit *)credit itemAtIndex:index].link];
        }
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
    [rootView release];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, rootView.bounds.size.width, rootView.bounds.size.height-44) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MDACBackground.png"]];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rootView addSubview:tableView];
    [tableView release];
    
    titleBar = [[MDACTitleBar alloc] initWithController:self];
    titleBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    [rootView addSubview:titleBar];
    [titleBar release];
}

- (void)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
