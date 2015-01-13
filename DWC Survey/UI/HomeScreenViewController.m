//
//  HomeScreenViewController.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/12/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "SuperQuestionViewController.h"
#import "RequestWrapper.h"
#import "AppDelegate.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

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
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	self.requestWrapper = [[RequestWrapper alloc] init];
	
	self.buttonLabelOne.text = NSLocalizedString(@"start_survey_button_line_one", nil);
	//self.buttonLabelOne.font = [UIFont fontWithName:@"DIN-Light" size:21];
	self.buttonLabelOne.font = [UIFont fontWithName:@"RopaSans-Regular" size:21];
	self.buttonLabelOne.textColor = [UIColor whiteColor];
	
	self.buttonLabelTwo.text = NSLocalizedString(@"start_survey_button_line_two", nil);
	//self.buttonLabelTwo.font = [UIFont fontWithName:@"DIN-BlackAlternate" size:25];
	self.buttonLabelTwo.font = [UIFont fontWithName:@"RopaSans-Regular" size:25];
	self.buttonLabelTwo.textColor = [UIColor whiteColor];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[self showCompanyPopover];
	//[self performSelector:@selector(showCompanyPopover) withObject:nil afterDelay:0.25];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCompanyPopover
{
	CGRect rect = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 1, 1);
	
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	CompanyDetailsPopupViewController *popupViewController = (CompanyDetailsPopupViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"SubmitPopupViewControllerID"];
	
	self.companyDetailsPopover = [[UIPopoverController alloc] initWithContentViewController:popupViewController];
	
	popupViewController.companyDetailsDelegate = self;
	
	self.companyDetailsPopover.delegate = self;
	
	[self.companyDetailsPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
}

- (IBAction)startSurveyClicked:(id)sender {
	
	if ([self.surveyId isEqualToString:@"-1"])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"survey_name_error_title", nil) message:NSLocalizedString(@"survey_name_error_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
		
		[alert show];
		return;
	}
	
	[self initializeAndStartActivityIndicatorSpinner];
	[HelperClass initSurveyQuestionsWithListener:self AndSurveyId:self.surveyId];
}

- (void)initializeAndStartActivityIndicatorSpinner
{
	[_spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_spinner.color = [UIColor blackColor];
	
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[_spinner startAnimating];
}

- (void)stopActivityIndicatorSpinner
{
	[_spinner stopAnimating];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (UIPopoverController *)companyDetailsPopover {
	
	if([_companyDetailsPopover isPopoverVisible])
		return _companyDetailsPopover;
	
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	CompanyDetailsPopupViewController *companyDetailsPopupViewController = (CompanyDetailsPopupViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"SubmitPopupViewControllerID"];
	
	companyDetailsPopupViewController.companyDetailsDelegate = self;
	
	_companyDetailsPopover = [[UIPopoverController alloc] initWithContentViewController:companyDetailsPopupViewController];
	
	_companyDetailsPopover.delegate = self;
	
	_companyDetailsPopover.backgroundColor = [UIColor clearColor];
	[[[_companyDetailsPopover contentViewController]  view] setBackgroundColor:[UIColor clearColor]];
	
	return _companyDetailsPopover;
}

#pragma CompanyDetailsPopoverDelegate
- (void)dismissPopover {
	[self.companyDetailsPopover dismissPopoverAnimated:YES];
}

- (void)donePopoverWithCompanyId:(NSString *)companyId CompanyName:(NSString *)companyName PersonName:(NSString *)personName Designation:(NSString *)designation SurveyId:(NSString *)surveyId{
	
	[self.companyDetailsPopover dismissPopoverAnimated:YES];
	[self.requestWrapper.surveyTaker setValue:companyId forKey:@"Registered_Company__c"];
	[self.requestWrapper.surveyTaker setValue:companyName forKey:@"Non_Registered_Company__c"];
	[self.requestWrapper.surveyTaker setValue:personName forKey:@"Person_Name__c"];
	[self.requestWrapper.surveyTaker setValue:designation forKey:@"Designation__c"];
	[self.requestWrapper.surveyTaker setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).counterNumber forKey:@"Counter_Number__c"];
	
	self.surveyId = surveyId;
}

#pragma mark SurveyQuestionReadyProtocol
- (void)surveyQuestionsReady
{
	[self stopActivityIndicatorSpinner];
	
	if ([[HelperClass getSurveyQuestions] count] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"no_questions_error_title", nil) message:NSLocalizedString(@"no_questions_error_msg", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
		
		[alert show];
		return;
	}
	
	SuperQuestionViewController *nextView = [SuperQuestionViewController getViewContollerForQuestionWithIndex:0];
	
	nextView.currentQuestionIndex =  0;
	nextView.requestWrapper = [[RequestWrapper alloc] initWithRequestWrapper:self.requestWrapper];
	
	[self.navigationController pushViewController:nextView animated:YES];
}

- (void) surveyQuestionsSyncNoInternetFound {
	[self stopActivityIndicatorSpinner];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't update list of companies. Error contacting server, please check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alert show];
}

#pragma UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return NO;
}

@end
