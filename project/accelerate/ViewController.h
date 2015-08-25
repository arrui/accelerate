//
//  ViewController.h
//  accelerate
//
//  Created by yanrui on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UITextView* desText;
    NSInteger offset;
    NSTimer* timer;
}
@property (retain, nonatomic)UITextView *desText;
- (IBAction)unload:(id)sender;
- (IBAction)load:(id)sender;
- (IBAction)backup:(id)sender;
- (IBAction)recovery:(id)sender;

@end
