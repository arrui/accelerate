//
//  ViewController.m
//  accelerate
//
//  Created by yanrui on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize desText;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	desText = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 280, 260)];
    desText.editable = NO;
    desText.showsVerticalScrollIndicator = NO;
    desText.showsHorizontalScrollIndicator = NO;
    desText.text = @"Tips:\n\n This app is to remove useless daemons,decrease your using memory.Accelerate your iDevice boot speed,running speed,improve memory status.\n\n1.Click \"install\" to speed up your device immediately(This don't need to reboot your device)\n2.Click \"uninstall\" to recovery your default status immediately(This don't need to reboot your device)\n3.Click \"backup\" to bakcup your useless daemons in a safety directory\n4.Click \"recovery\" to recovery your default status & recovery your backup daemons(This may need to reboot your device)\n\nAny question please contact:\narrui.c@gmail.com,Best Regards!";
    desText.backgroundColor = [UIColor clearColor];
	[self.view addSubview:desText];
    offset = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
//    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:2.0f];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(42, 295, 72, 37);
    [btn addTarget:self action:@selector(unload:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"install", nil) forState:UIControlStateNormal];
    [self.view addSubview:btn];

    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(205, 295, 72, 37);
    [btn addTarget:self action:@selector(load:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"uninstall", nil) forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(42, 371, 72, 37);
    [btn addTarget:self action:@selector(backup:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"backup", nil) forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(205, 371, 72, 37);
    [btn addTarget:self action:@selector(recovery:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"recovery", nil) forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 416, 280, 24)];
    label.text = @"Copyright (c) 2013 Arrui. All rights reserved.";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.adjustsFontSizeToFitWidth = true;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label release];
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
}

- (void)viewDidUnload
{
    [self setDesText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)autoScroll{
    if(offset<80) [desText setContentOffset:CGPointMake(0, offset++) animated:YES];
    else {[timer invalidate];timer = nil;}
}

- (IBAction)unload:(id)sender {
    system("/Applications/accelerate.app/AccelerateHelper unload");
}

- (IBAction)load:(id)sender {
    system("/Applications/accelerate.app/AccelerateHelper load");
}

- (IBAction)backup:(id)sender {
    system("/Applications/accelerate.app/AccelerateHelper backup");
}

- (IBAction)recovery:(id)sender {
    system("/Applications/accelerate.app/AccelerateHelper recovery");
}
- (void)dealloc {
    [desText release];
    [super dealloc];
}
@end
