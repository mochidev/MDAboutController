//
//  MDAboutController.h
//  MDAboutController
//
//  Created by Dimitri Bouniol on 4/18/11.
//  Copyright 2011 Mochi Development Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDACTitleBar;

@interface MDAboutController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    MDACTitleBar *titleBar;
    UITableView *tableView;
}

- (IBAction)dismiss:(id)sender;

@end
