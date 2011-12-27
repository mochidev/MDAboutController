//
//  MDAboutNavigationController.h
//  MDAboutControllerDemo
//
//  Created by Dimitri Bouniol on 12/26/11.
//  Copyright (c) 2011 Mochi Development Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDAboutController, MDACStyle;

@interface MDAboutNavigationController : UINavigationController

- (id)initWithStyle:(MDACStyle *)style;

@property (nonatomic, readonly) MDAboutController *aboutController;

@end
