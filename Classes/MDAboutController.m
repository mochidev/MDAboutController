//
//  MDAboutController.m
//  MDAboutController
//
//  Created by Dimitri Bouniol on 4/18/11.
//  Copyright 2011 Mochi Development Inc. All rights reserved.
//

#import "MDAboutController.h"

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

@implementation MDAboutController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
