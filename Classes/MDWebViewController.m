//
//  MDWebViewController.m
//  MDAboutController
//
//  Created by Doron Katz 5/23/11.
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

#import "MDWebViewController.h"


@implementation MDWebViewController

@synthesize webURL, activity, webV, alert;

- (id)initWithUrl:(NSURL*)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.webURL = url;
        webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        webV.delegate = self;

        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [webV loadRequest:[NSURLRequest requestWithURL:webURL]];
        [[self view] addSubview:webV];
        
        UIBarButtonItem* loadButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
        self.navigationItem.rightBarButtonItem = loadButton;
        [loadButton release];
    }
    return self;
}



#pragma mark UIWebViewDelegate

//TODO: Implement refresh/reload activity button in toolbar via delegates
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [activity startAnimating];
                            
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activity stopAnimating];
    activity = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activity stopAnimating];
    activity = nil;
    
    alert = [[[UIAlertView alloc] initWithTitle:@"An error accessing the internet"
													 message:[error localizedDescription]
													delegate:nil
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil] autorelease];
    
    alert.delegate = self;
	[alert show];

}

#pragma mark UI Alert delegate to pop back
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if (self.navigationController){
            [[self navigationController] popViewControllerAnimated:YES];
        }
        else{
            [[self modalViewController] dismissModalViewControllerAnimated:YES];
        }      
    }
}

- (void)dealloc
{
    [webURL release];
    alert = nil;
    [alert release];
    activity = nil;
    webV = nil;
    webV.delegate = nil;
    [webV release];
    [activity release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    webV = nil;
    webV.delegate = nil;
    activity = nil;
    alert.delegate = nil;
    alert = nil;
    webURL = nil;
}


@end
