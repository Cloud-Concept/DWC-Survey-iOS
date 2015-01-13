//
//  ThankYouViewController.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 1/30/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "ThankYouViewController.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self performSelector:@selector(returnToRootView) withObject:nil afterDelay:5.0];
	
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/chime.wav", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	self.audioPlayer.numberOfLoops = 0;
	
	if (self.audioPlayer == nil)
		NSLog([error description]);
	else
	{
		[self.audioPlayer play];
		NSLog(@"Play Audio");
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnToRootView
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.dwc.ae"]];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
