//
//  SuperQuestionViewController.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/11/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "SuperQuestionViewController.h"
#import "ThankYouViewController.h"
#import "AppDelegate.h"
#import "RequestWrapper.h"
#import "HelperClass.h"
#import "SurveyQuestion.h"

@interface SuperQuestionViewController ()

@end

@implementation SuperQuestionViewController
@synthesize child;

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
	
	self.surveyQuestion = [[HelperClass getSurveyQuestions] objectAtIndex:self.currentQuestionIndex];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:[self.surveyQuestion surveyLanguageAbbreviation] ofType:@"lproj"];
	self.localeBundle = [NSBundle bundleWithPath:path];
	
	self.questionNumberTextView.text = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"question_number_header", nil, self.localeBundle, nil), (self.currentQuestionIndex + 1)];
	//self.questionTextView.font = [UIFont fontWithName:@"DIN-MediumAlternate" size:70];
	self.questionNumberTextView.font = [UIFont fontWithName:@"RopaSans-Regular" size:70];
	self.questionNumberTextView.textColor = [UIColor whiteColor];
	
	self.questionTextView.text = self.surveyQuestion.questionText;
	//self.questionTextView.font = [UIFont fontWithName:@"Titillium-Semibold" size:22];
	self.questionTextView.font = [UIFont fontWithName:@"RopaSans-Regular" size:22];
	self.questionTextView.textColor = [UIColor whiteColor];
	
	self.questionNumberRightTextView.text = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"question_number_header", nil, self.localeBundle, nil), (self.currentQuestionIndex + 1)];
	//self.questionNumberRightTextView.font = [UIFont fontWithName:@"DIN-MediumAlternate" size:70];
	self.questionNumberRightTextView.font = [UIFont fontWithName:@"RopaSans-Regular" size:70];
	self.questionNumberRightTextView.textColor = [UIColor whiteColor];
	
	self.questionRightTextView.text = self.surveyQuestion.questionText;
	//self.questionRightTextView.font = [UIFont fontWithName:@"Titillium-Semibold" size:22];
	self.questionRightTextView.font = [UIFont fontWithName:@"RopaSans-Regular" size:22];
	self.questionRightTextView.textColor = [UIColor whiteColor];
	self.questionRightTextView.textAlignment = NSTextAlignmentRight;
	
	if([self.surveyQuestion.surveyLanguage isEqualToString:@"Arabic"])
	{
		[self.questionTextBackground setImage:[UIImage imageNamed:@"QuestionTextBackgroundRight.png"]];
		self.questionNumberTextView.hidden = YES;
		self.questionTextView.hidden = YES;
		
		self.questionNumberRightTextView.hidden = NO;
		self.questionRightTextView.hidden = NO;
		
		self.footerTextLabel.textAlignment = NSTextAlignmentRight;
		
	}
	
	[self.submitButton setTitle:NSLocalizedStringFromTableInBundle(@"submit", nil, self.localeBundle, nil) forState:UIControlStateNormal];
	//self.submitButton.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:40];
	self.submitButton.titleLabel.font = [UIFont fontWithName:@"RopaSans-Regular" size:40];
	self.submitButton.titleLabel.textColor = [UIColor whiteColor];
	
	[self.nextButton setTitle:NSLocalizedStringFromTableInBundle(@"next", nil, self.localeBundle, nil) forState:UIControlStateNormal];
	//self.nextButton.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:40];
	self.nextButton.titleLabel.font = [UIFont fontWithName:@"RopaSans-Regular" size:40];
	self.nextButton.titleLabel.textColor = [UIColor whiteColor];
	
	[self.previousButton setTitle:NSLocalizedStringFromTableInBundle(@"back", nil, self.localeBundle, nil) forState:UIControlStateNormal];
	//self.previousButton.titleLabel.font = [UIFont fontWithName:@"BigNoodleTitling" size:40];
	self.previousButton.titleLabel.font = [UIFont fontWithName:@"RopaSans-Regular" size:40];
	[self.previousButton setTitleColor:[UIColor colorWithRed:0.76f green:0.77f blue:0.78f alpha:1] forState:UIControlStateNormal];
	
	self.footerTextLabel.text = NSLocalizedStringFromTableInBundle(@"questions_footer", nil, self.localeBundle, nil);
	//self.footerTextLabel.font = [UIFont fontWithName:@"Titillium-Light" size:15];
	self.footerTextLabel.font = [UIFont fontWithName:@"RopaSans-Regular" size:15];
	self.footerTextLabel.textColor = [UIColor whiteColor];
	
	
	/*switch (self.currentQuestionIndex) {
		case 0:
			[self.firstBullet setImage:[UIImage imageNamed:@"BlueTimeLineBullet.png"]];
			break;
		case 1:
			[self.bulletTwo setImage:[UIImage imageNamed:@"BlueTimeLineBullet.png"]];
			break;
		case 2:
			[self.bulletThree setImage:[UIImage imageNamed:@"BlueTimeLineBullet.png"]];
			break;
		case 3:
			[self.bulletFour setImage:[UIImage imageNamed:@"BlueTimeLineBullet.png"]];
			break;
		case 4:
			[self.bulletFive setImage:[UIImage imageNamed:@"BlueTimeLineBullet.png"]];
			break;
		case 5:
			[self.lastBullet setImage:[UIImage imageNamed:@"BlueTimeLineBullet.png"]];
			break;
	}*/
	
	[self displayTimeLineBullets];
	[self initChildControlsVisibility];
}

- (void)displayTimeLineBullets
{
	CGRect rect = self.firstBullet.frame;
	NSInteger questionsCount = [[HelperClass getSurveyQuestions] count];
	NSInteger bulletSpace = (self.lastBullet.frame.origin.x - self.firstBullet.frame.origin.x) / (questionsCount - 1);
	
	for (int i = 0; i < questionsCount; i++)
	{
		CGRect imageViewRect = CGRectMake(rect.origin.x + (bulletSpace * i), rect.origin.y, rect.size.width, rect.size.height);
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
		
		if (self.currentQuestionIndex == i)
			[imageView setImage:[UIImage imageNamed:@"BlueTimeLineBullet.png"]];
		else
			[imageView setImage:[UIImage imageNamed:@"GrayTimeLineBullet.png"]];
		
		imageView.contentMode = UIViewContentModeCenter;
		[self.timeLineView addSubview:imageView];
		[imageView bringSubviewToFront:self.timeLineView];
	}
	
	//[self.timeLineView layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initChildControlsVisibility
{
	if ([self isLastQuestion])
	{
		[self.nextButton setHidden:YES];
		
		[self.submitButton setHidden:NO];
	}
	else
	{
		[self.nextButton setHidden:NO];
		
		[self.submitButton setHidden:YES];
	}
}

- (void)showErrorMessgae
{
	NSString *message;
	
	if (self.surveyQuestion.questionType == Text)
	{
		if ([self isLastQuestion])
			message = NSLocalizedStringFromTableInBundle(@"text_error_message_last_question", nil, self.localeBundle, nil);
		else
			message = NSLocalizedStringFromTableInBundle(@"text_error_message", nil, self.localeBundle, nil);
	}
	else if (self.surveyQuestion.questionType == SingleSelect)
	{
		if ([self isLastQuestion])
			message = NSLocalizedStringFromTableInBundle(@"single_select_error_message_last_question", nil, self.localeBundle, nil);
		else
			message = NSLocalizedStringFromTableInBundle(@"single_select_error_message", nil, self.localeBundle, nil);
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"error", nil, self.localeBundle, nil) message:message delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"ok", nil, self.localeBundle, nil) otherButtonTitles: nil];
	[alert show];
}

- (IBAction)submitButtonClicked:(id)sender
{
	if (![child isQuestionAnswered] && self.surveyQuestion.isRequired)
	{
		[self showErrorMessgae];
		return;
	}
	
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		
	NSString *answer = [child getQuestionAnswer];
	NSString *answerColor = [child getQuestionAnswerColor];
	NSString *answerWeight = [child getQuestionAnswerWeight];
	
	NSDictionary *answerDict = [[NSDictionary alloc] initWithObjects:@[self.surveyQuestion.questionId, answer, answerColor, answerWeight] forKeys:@[@"Survey_Question__c", @"Response__c", @"Response_Color__c", @"Response_Weight__c"]];
	
	//Adding answer to temp request wrapper before submit.
	RequestWrapper *tempRequestWrapper = [[RequestWrapper alloc] initWithRequestWrapper:self.requestWrapper];
	[tempRequestWrapper.surveyQuestionResponseList addObject:answerDict];
	
	[tempRequestWrapper.surveyTaker setValue:self.surveyQuestion.questionSurveyId forKey:@"Survey__c"];
	
	[HelperClass submitSurvey:tempRequestWrapper];
	
	ThankYouViewController *thankYouView = [storyBoard instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
	
	[self.navigationController pushViewController:thankYouView animated:YES];
}

- (IBAction)nextButtonClicked:(id)sender
{
	if (![child isQuestionAnswered] && self.surveyQuestion.isRequired)
	{
		[self showErrorMessgae];
		return;
	}
	
	NSString *answer = [child getQuestionAnswer];
	NSString *answerColor = [child getQuestionAnswerColor];
	NSString *answerWeight = [child getQuestionAnswerWeight];
	
	NSDictionary *answerDict = [[NSDictionary alloc] initWithObjects:@[self.surveyQuestion.questionId, answer, answerColor, answerWeight] forKeys:@[@"Survey_Question__c", @"Response__c", @"Response_Color__c", @"Response_Weight__c"]];
	
	//Adding answer to temp request wrapper before submit.
	RequestWrapper *tempRequestWrapper = [[RequestWrapper alloc] initWithRequestWrapper:self.requestWrapper];
	[tempRequestWrapper.surveyQuestionResponseList addObject:answerDict];
	
	//Call super class to view next question
	SuperQuestionViewController *nextQuestionView = [SuperQuestionViewController getViewContollerForQuestionWithIndex:self.currentQuestionIndex + 1];
	
	nextQuestionView.currentQuestionIndex = self.currentQuestionIndex + 1;
	nextQuestionView.requestWrapper = tempRequestWrapper;
	
	[self.navigationController pushViewController:nextQuestionView animated:YES];
}

- (IBAction)previousButtonClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isLastQuestion
{
	return !(self.currentQuestionIndex < [[HelperClass getSurveyQuestions] count] - 1);
}

+ (id)getViewContollerForQuestionWithIndex:(NSInteger)questionIndex
{
	if(questionIndex >= [[HelperClass getSurveyQuestions] count])
		return nil;
	
	SurveyQuestion *question = [[HelperClass getSurveyQuestions] objectAtIndex:questionIndex];
	
	NSString *controllerStoryBoardId;
	
	switch (question.questionType) {
		case Text:
			controllerStoryBoardId = @"TextViewQuestionControllerID";
			break;
			
		case SingleSelect:
			if([question.questionOptionsArray count] > 3)
				controllerStoryBoardId = @"PickerViewQuestionControllerID";
			else
				controllerStoryBoardId = @"PickerViewQuestionThreeOptionsControllerID";
			break;
	}
	
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	SuperQuestionViewController *nextQuestionView = (SuperQuestionViewController*)[storyBoard instantiateViewControllerWithIdentifier:controllerStoryBoardId];
	
	return nextQuestionView;
}


@end
