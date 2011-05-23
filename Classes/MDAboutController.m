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

#pragma mark - Utilities

// git://gist.github.com/938107.git

@interface UIImage (DBMaskedImageAdditions)

- (UIImage *)maskedImageWithMask:(UIImage *)maskImage;

@end

@implementation UIImage (DBMaskedImageAdditions)

- (UIImage *)maskedImageWithMask:(UIImage *)maskImage
{
    CGImageRef maskImageRef = maskImage.CGImage; 
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
                                        CGImageGetHeight(maskImageRef),
                                        CGImageGetBitsPerComponent(maskImageRef),
                                        CGImageGetBitsPerPixel(maskImageRef),
                                        CGImageGetBytesPerRow(maskImageRef),
                                        CGImageGetDataProvider(maskImageRef), NULL, false);
    
    CGImageRef sourceImage = self.CGImage;
    CGImageRef maskedImage;
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(sourceImage);
    
    if (alpha != kCGImageAlphaFirst && alpha != kCGImageAlphaLast && alpha != kCGImageAlphaPremultipliedFirst && alpha != kCGImageAlphaPremultipliedLast) {
        size_t width = CGImageGetWidth(sourceImage);
        size_t height = CGImageGetHeight(sourceImage);
        
        CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                              8, 0, CGImageGetColorSpace(sourceImage),
                                                              kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
        
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
        maskedImage = CGImageCreateWithMask(imageRefWithAlpha, mask);
        CGImageRelease(imageRefWithAlpha);
        
        CGContextRelease(offscreenContext);
    } else {
        maskedImage = CGImageCreateWithMask(sourceImage, mask);
    }
    
    UIImage *returnImage = [UIImage imageWithCGImage:maskedImage];
    
    CGImageRelease(maskedImage);
    CGImageRelease(mask);
    
    return returnImage;
}

@end

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

@interface MDACTextCredit : MDACCredit {
    NSString *text;
    UIFont *font;
    UITextAlignment textAlignment;
    NSURL *link;
}

@property(nonatomic, copy) NSString *text;
@property(nonatomic, retain) UIFont *font;
@property(nonatomic) UITextAlignment textAlignment;
@property(nonatomic, retain) NSURL *link;
- (id)initWithText:(NSString *)aTitle font:(UIFont *)aFont alignment:(UITextAlignment)textAlign linkURL:(NSURL *)anURL;
+ (id)textCreditWithText:(NSString *)aTitle font:(UIFont *)aFont alignment:(UITextAlignment)textAlign linkURL:(NSURL *)anURL;
- (id)initWithDictionary:(NSDictionary *)aDict;
+ (id)textCreditWithDictionary:(NSDictionary *)aDict;

@end

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

- (id)initWithType:(NSString *)aType
{
    return [self initWithText:nil font:nil alignment:UITextAlignmentCenter linkURL:nil];
}

+ (id)creditWithType:(NSString *)aType
{
    return [self textCreditWithText:nil font:nil alignment:UITextAlignmentCenter linkURL:nil];
}

+ (id)textCreditWithText:(NSString *)aTitle font:(UIFont *)aFont alignment:(UITextAlignment)textAlign linkURL:(NSURL *)anURL
{
    return [[[self alloc] initWithText:aTitle font:aFont alignment:textAlign linkURL:anURL] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    CGFloat fontSize = 12;
    if ([aDict objectForKey:@"Size"])
        fontSize = [[aDict objectForKey:@"Size"] floatValue];
    
    UITextAlignment alignment = UITextAlignmentCenter;
    
    if ([[aDict objectForKey:@"Alignment"] isEqualToString:@"Left"]) {
        alignment = UITextAlignmentLeft;
    } else if ([[aDict objectForKey:@"Alignment"] isEqualToString:@"Right"]) {
        alignment = UITextAlignmentRight;
    }
    
    return [self initWithText:[aDict objectForKey:@"Text"]
                         font:[UIFont boldSystemFontOfSize:fontSize]
                    alignment:alignment
                      linkURL:[NSURL URLWithString:[aDict objectForKey:@"Link"]]];
}

+ (id)textCreditWithDictionary:(NSDictionary *)aDict
{
    return [[[self alloc] initWithDictionary:aDict] autorelease];
}

- (void)dealloc {
    [text release];
    [font release];
    [link release];
    [super dealloc];
}

@end

@interface MDACImageCredit : MDACCredit {
    UIImage *image;
}

@property(nonatomic, retain) UIImage *image;
- (id)initWithImage:(UIImage *)anImage;
+ (id)imageCreditWithImage:(UIImage *)anImage;
- (id)initWithDictionary:(NSDictionary *)aDict;
+ (id)imageCreditWithDictionary:(NSDictionary *)aDict;

@end

@implementation MDACImageCredit

@synthesize image;

- (id)initWithImage:(UIImage *)anImage
{
    if ((self = [super initWithType:@"Image"])) {
        self.image = anImage;
    }
    return self;
}

- (id)initWithType:(NSString *)aType
{
    return [self initWithImage:nil];
}

+ (id)creditWithType:(NSString *)aType
{
    return [self imageCreditWithImage:nil];
}

+ (id)imageCreditWithImage:(UIImage *)anImage
{
    return [[[self alloc] initWithImage:anImage] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    return [self initWithImage:[UIImage imageNamed:[aDict objectForKey:@"Image"]]];
}

+ (id)imageCreditWithDictionary:(NSDictionary *)aDict
{
    return [[[self alloc] initWithDictionary:aDict] autorelease];
}

- (void)dealloc {
    [image release];
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
    if ((self = [super initWithType:@"Icon"])) {
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

@synthesize showsTitleBar, titleBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.navigationItem.title = @"About";
        
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
        
        if (icon) {
            UIImage *maskImage = [UIImage imageNamed:@"MDACIconMask.png"];
            //icon = maskImage;
            icon = [icon maskedImageWithMask:maskImage];
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
                        } else if ([[creditDict objectForKey:@"Type"] isEqualToString:@"Text"]) {
                            [credits addObject:[MDACTextCredit textCreditWithDictionary:creditDict]];
                        } if ([[creditDict objectForKey:@"Type"] isEqualToString:@"Image"]) {
                            [credits addObject:[MDACImageCredit imageCreditWithDictionary:creditDict]];
                        }
                    }
                }
            }
            [creditsFile release];
        }
        
        [credits addObject:[MDACTextCredit textCreditWithText:@"About screen powered by MDAboutViewController, available free on GitHub!"
                                                         font:[UIFont boldSystemFontOfSize:11]
                                                    alignment:UITextAlignmentCenter
                                                      linkURL:[NSURL URLWithString:@"https://github.com/mochidev/MDAboutControllerDemo"]]];
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

#pragma mark View lifecycle

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
        } else if ([tempCredit isMemberOfClass:[MDACTextCredit class]]) {
            i += 1;
            
            CGSize textSize = CGSizeMake(300, 30);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                textSize = [[(MDACTextCredit *)tempCredit text] sizeWithFont:[(MDACTextCredit *)tempCredit font]
                                                           constrainedToSize:CGSizeMake(450, 600)
                                                               lineBreakMode:UILineBreakModeWordWrap];
            } else {
                textSize = [[(MDACTextCredit *)tempCredit text] sizeWithFont:[(MDACTextCredit *)tempCredit font]
                                                           constrainedToSize:CGSizeMake(300, 600)
                                                               lineBreakMode:UILineBreakModeWordWrap];
            }
            
            [cachedCellCredits addObject:tempCredit];
            [cachedCellHeights addObject:[NSNumber numberWithFloat:textSize.height]];
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
    
    UILabel *textLabel = nil, *detailTextLabel = nil;
    UIImageView *linkAvailableImageView = nil;
    
    UIImageView *iconView = nil;
    UIView *containerView = nil;
    
    UIImageView *imageView = nil;
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        
        if (cellID == MDACTopListCellID || cellID == MDACMiddleListCellID || cellID == MDACBottomListCellID || cellID == MDACSingleListCellID) {
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
            
            textLabel = [[UILabel alloc] init];
            textLabel.font = [UIFont boldSystemFontOfSize:17];
            textLabel.backgroundColor = [UIColor colorWithWhite:94./255. alpha:1];
            textLabel.textColor = [UIColor whiteColor];
            textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
            textLabel.shadowOffset = CGSizeMake(0, -1);
            textLabel.tag = 1;
            [cell.contentView addSubview:textLabel];
            [textLabel release];
            
            detailTextLabel = [[UILabel alloc] init];
            detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
            detailTextLabel.backgroundColor = [UIColor colorWithWhite:94./255. alpha:1];
            detailTextLabel.textColor = [UIColor whiteColor];
            detailTextLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
            detailTextLabel.shadowOffset = CGSizeMake(0, -1);
            detailTextLabel.textAlignment = UITextAlignmentRight;
            detailTextLabel.tag = 2;
            [cell.contentView addSubview:detailTextLabel];
            [detailTextLabel release];
            
            linkAvailableImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width-39, 9, 24, 24)];
            linkAvailableImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            linkAvailableImageView.image = [UIImage imageNamed:@"MDACLinkArrow.png"];
            linkAvailableImageView.tag = 3;
            [cell.contentView addSubview:linkAvailableImageView];
            [linkAvailableImageView release];
        } else if (cellID == MDACIconCellID) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            containerView = [[UIView alloc] init];
            containerView.tag = 5;
            containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            iconView = [[UIImageView alloc] init];
            UIImageView *iconBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MDACIconShadow.png"]];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                iconView.frame = CGRectMake(0, 0, 72, 72);
                containerView.frame = CGRectMake(floorf((cell.contentView.bounds.size.width-212)/2.), 0, 212, 92);
            } else {
                iconView.frame = CGRectMake(0, 0, 57, 57);
                containerView.frame = CGRectMake(floorf((cell.contentView.bounds.size.width-198)/2.), 0, 198, 77);
            }
            
            iconBackground.center = CGPointMake(10+iconView.bounds.size.width/2., containerView.bounds.size.height/2.+3);
            iconView.center = CGPointMake(iconBackground.center.x, iconBackground.center.y-3);
            iconView.tag = 4;
            
            [containerView addSubview:iconBackground];
            [containerView addSubview:iconView];
            
            [iconBackground release];
            [iconView release];
            
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.bounds.size.width+25, floorf(10+iconView.bounds.size.height/2.-17), 170, 22)];
            textLabel.font = [UIFont boldSystemFontOfSize:18];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.opaque = NO;
            textLabel.textColor = [UIColor whiteColor];
            textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
            textLabel.shadowOffset = CGSizeMake(0, -1);
            textLabel.tag = 1;
            [containerView addSubview:textLabel];
            [textLabel release];
            
            detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.bounds.size.width+25, floorf(10+iconView.bounds.size.height/2.+3), 170, 20)];
            detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            detailTextLabel.backgroundColor = [UIColor clearColor];
            detailTextLabel.opaque = NO;
            detailTextLabel.textColor = [UIColor whiteColor];
            detailTextLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
            detailTextLabel.shadowOffset = CGSizeMake(0, -1);
            detailTextLabel.tag = 2;
            [containerView addSubview:detailTextLabel];
            [detailTextLabel release];
            
            [cell.contentView addSubview:containerView];
            [containerView release];
        } else if (cellID == MDACTextCellID) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.contentView.bounds.size.width-20, cell.contentView.bounds.size.height)];
            textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            textLabel.lineBreakMode = UILineBreakModeWordWrap;
            textLabel.numberOfLines = 0;
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.opaque = NO;
            textLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            textLabel.highlightedTextColor = [UIColor colorWithWhite:0.5 alpha:1];
            textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
            textLabel.shadowOffset = CGSizeMake(0, -1);
            textLabel.tag = 1;
            [cell.contentView addSubview:textLabel];
            [textLabel release];
        } else if (cellID == MDACImageCellID) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height)];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.opaque = NO;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = 6;
            [cell.contentView addSubview:imageView];
            [imageView release];
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
        } else if (cellID == MDACImageCellID) {
            imageView = (UIImageView *)[cell.contentView viewWithTag:6];
        }
    }
    
    if ([credit isMemberOfClass:[MDACListCredit class]]) {
        textLabel.text = [(MDACListCredit *)credit itemAtIndex:index].name;
        detailTextLabel.text = [[(MDACListCredit *)credit itemAtIndex:index].role lowercaseString];
        
        [textLabel sizeToFit];
        [detailTextLabel sizeToFit];
        
        if ([(MDACListCredit *)credit itemAtIndex:index].link) {
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
            textLabel.frame = CGRectMake(24, floorf((cell.contentView.bounds.size.height-textLabel.bounds.size.height)/2.-2), textLabel.bounds.size.width, textLabel.bounds.size.height);
        }
    } else if ([credit isMemberOfClass:[MDACIconCredit class]]) {
        textLabel.text = [(MDACIconCredit *)credit appName];
        detailTextLabel.text = [(MDACIconCredit *)credit versionString];
        iconView.image = [(MDACIconCredit *)credit icon];
    } else if ([credit isMemberOfClass:[MDACTextCredit class]]) {
        textLabel.textAlignment = [(MDACTextCredit *)credit textAlignment];
        textLabel.font = [(MDACTextCredit *)credit font];
        textLabel.text = [(MDACTextCredit *)credit text];
        textLabel.highlighted = ([(MDACTextCredit *)credit link] != nil);
    } else if ([credit isMemberOfClass:[MDACImageCredit class]]) {
        imageView.image = [(MDACImageCredit *)credit image];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    } else if ([credit isMemberOfClass:[MDACTextCredit class]]) {
        if ([(MDACTextCredit *)credit link]) {
            [[UIApplication sharedApplication] openURL:[(MDACTextCredit *)credit link]];
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
    
    MDACTitleBar *aTitleBar = [[MDACTitleBar alloc] initWithController:self];
    self.titleBar = aTitleBar;
    [aTitleBar release];
}

- (void)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.showsTitleBar = !self.navigationController;
}

- (void)setTitleBar:(UIView *)aTitleBar
{
    if (aTitleBar != titleBar) {
        [self.view addSubview:aTitleBar];
        [titleBar removeFromSuperview];
        
        [titleBar release];
        titleBar = [aTitleBar retain];
        
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
    
    NSLog(@"    %@", self.titleBar.superview);
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
