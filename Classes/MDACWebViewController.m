//
//  MDACWebViewController.m
//  MDAboutController
//
//  Created by Doron Katz 5/23/11.
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

#import "MDACWebViewController.h"


@implementation MDACWebViewController

@synthesize webURL, activity, webView, alert;

- (id)initWithURL:(NSURL*)url
{
    if ((self = [super init])) {
        self.webURL = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    [webView loadRequest:[NSURLRequest requestWithURL:webURL]];
    [self.view addSubview:webView];
    [webView release];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *loadButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
    self.navigationItem.rightBarButtonItem = loadButton;
    self.navigationItem.title = @"Loading…";
    [loadButton release];
    [activity release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGFloat toolbarHeight = 0;
    if (!self.navigationController.navigationBarHidden && self.navigationController.navigationBar.translucent) {
        toolbarHeight = self.navigationController.navigationBar.frame.size.height;
    }
    
    webView.frame = CGRectMake(0, toolbarHeight, self.view.bounds.size.width, self.view.bounds.size.height-toolbarHeight);
}

#pragma mark UIWebViewDelegate

//TODO: Implement refresh/reload activity button in toolbar via delegates
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    activity.hidden = NO;
    [activity startAnimating];
    self.navigationItem.title = @"Loading…";
}

- (void)webViewDidFinishLoad:(UIWebView *)view
{
    [activity stopAnimating];
    activity.hidden = YES;
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activity stopAnimating];
    activity.hidden = YES;
    
    alert = [[UIAlertView alloc] initWithTitle:@"An error accessing the internet"
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
	[alert show];
    [alert autorelease];
}

#pragma mark UI Alert delegate to pop back
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
        }      
    }
    [alertView autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [webURL release];
    [super dealloc];
}

@end
