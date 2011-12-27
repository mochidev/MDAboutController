//
//  MDAboutNavigationController.m
//  MDAboutControllerDemo
//
//  Created by Dimitri Bouniol on 12/26/11.
//  Copyright (c) 2011 Mochi Development Inc. All rights reserved.
//

#import "MDAboutNavigationController.h"
#import "MDAboutController.h"

@implementation MDAboutNavigationController

- (id)initWithStyle:(id)style
{
    if (self = [super init]) {
        MDAboutController *aboutController = [[MDAboutController alloc] initWithStyle:style];
        [self pushViewController:aboutController animated:NO];
        [aboutController release];
    }
    return self;
}

- (id)init
{
    return [self initWithStyle:nil];
}

- (MDAboutController *)aboutController
{
    return [[self viewControllers] objectAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.parentViewController.class != [UITabBarController class]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideAbout:)];
        self.aboutController.navigationItem.rightBarButtonItem = doneButton;
        [doneButton release];
    }
}

- (void)hideAbout:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
