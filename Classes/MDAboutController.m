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

#pragma mark - MDAboutController

@implementation MDAboutController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        credits = [[NSMutableArray alloc] init];
        
        
        
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

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iconCellID = @"IconCell";
    static NSString *spacerCellID = @"SpacerCell";
    static NSString *topListCellID = @"TopListCell";
    static NSString *middleListCellID = @"MiddleListCell";
    static NSString *bottomListCellID = @"BottomListCell";
    static NSString *singleListCellID = @"SingleListCell";
    static NSString *textCellID = @"TextCell";
    static NSString *imageCellID = @"ImageCell";
    
    NSString *cellID;
    MDACCredit *credit;
    NSUInteger index, count;
    
    int i = 0;
    
    for (MDACCredit *tempCredit in credits) {
        if ([tempCredit isMemberOfClass:[MDACListCredit class]]) {
            count = [(MDACListCredit *)tempCredit count];
            i += count;
            
            if (i > indexPath.row) {
                credit = tempCredit;
                index = indexPath.row - (i - count);
                if (index >= count) {
                    if (index == 0) {
                        cellID = singleListCellID;
                    } else {
                        cellID = bottomListCellID;
                    }
                } else if (index == 0) {
                    cellID = topListCellID;
                } else {
                    cellID = middleListCellID;
                }
                break;
            }
        } else {
            i += 1;
            
            if (i > indexPath.row) {
                credit = tempCredit;
                break;
            }
        }
        
        i += 1;
        
        if (i > indexPath.row) {
            credit = nil;
            cellID = spacerCellID;
            break;
        }
    }
    
    //NSLog(@"%d: %@, %@, %d", indexPath.row, cellID, credit, index);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID] autorelease];
        
        if ([cellID isEqualToString:topListCellID]) {
            
        }
        // .. setup all of them here
    }
    
    if ([credit isMemberOfClass:[MDACListCredit class]]) {
        cell.detailTextLabel.text = [(MDACListCredit *)credit itemAtIndex:index].name;
        cell.textLabel.text = [(MDACListCredit *)credit itemAtIndex:index].role;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count;
    
    int i = 0;
    
    for (MDACCredit *tempCredit in credits) {
        if ([tempCredit isMemberOfClass:[MDACListCredit class]]) {
            count = [(MDACListCredit *)tempCredit count];
            i += count;
        } else {
            i += 1;
        }
        
        i += 1;
    }
    
    i -= 1;
    
    return i;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
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

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
