//
//  MDAboutController.h
//  MDAboutController
//
//  Created by Dimitri Bouniol on 4/18/11.
//  Forked by Doron Katz 5/23/11.
//  Copyright 2012 Mochi Development Inc. All rights reserved.
//  
//  Copyright (c) 2012 Dimitri Bouniol, Mochi Development, Inc.
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

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
@class MDACCredit, MDACStyle, MDAboutController;

@protocol MDAboutControllerDelegate <NSObject>

@optional

- (BOOL)aboutControllerShouldDisplayDoneButton:(MDAboutController *)aController;
- (UIViewController *)viewControllerToPresentMailController:(MDAboutController *)aController;
- (void)aboutControllerWillPresentMailController:(MDAboutController *)aController;
- (void)aboutControllerDidDismissMailController:(MDAboutController *)aController;

@end

@interface MDAboutController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  @private
    UIView *titleBar;
    UITableView *tableView;
    
    NSMutableArray *credits;
    
    NSMutableArray *cachedCellCredits;
    NSMutableArray *cachedCellIDs;
    NSMutableArray *cachedCellIndices;
    NSMutableArray *cachedCellHeights;
    
    BOOL showsTitleBar;
    
    UIColor *backgroundColor;
    BOOL hasSimpleBackground;
    
    MDACStyle *style;
    
    id<MDAboutControllerDelegate> __weak delegate;
}

- (id)initWithStyle:(MDACStyle *)style;

- (IBAction)dismiss:(id)sender; // hide if modal

@property (nonatomic, readonly, strong) MDACStyle *style;
@property (nonatomic, strong) UIView *titleBar;

@property (nonatomic) BOOL showsTitleBar; // set to NO automatically when in navcontroller. 
- (void)setShowsTitleBar:(BOOL)yn animated:(BOOL)animated;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic) BOOL hasSimpleBackground; // set automatically to YES for non patterend background. Set to YES for better performance, at the cost of a patterned background looking weird.

@property (nonatomic, readonly) NSArray *credits; // for fast enumeration
@property (nonatomic, readonly) NSUInteger creditCount;

@property (nonatomic, weak) id<MDAboutControllerDelegate> delegate;

- (void)addCredit:(MDACCredit *)aCredit;
- (void)insertCredit:(MDACCredit *)aCredit atIndex:(NSUInteger)index;
- (void)replaceCreditAtIndex:(NSUInteger)index withCredit:(MDACCredit *)aCredit;
- (void)removeLastCredit;
- (void)removeCredit:(MDACCredit *)aCredit;
- (void)removeCreditAtIndex:(NSUInteger)index;

@end
