//
//  HelperClass.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/10/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "HelperClass.h"
#import "SurveyQuestion.h"
#import "RequestWrapper.h"
#import "Reachability.h"
#import "AppDelegate.h"

static NSMutableArray *_surveyQuestionsArray;
static NSMutableData *_responseData;
static id<SurveyQuestionReadyProtocol> _listener;

@implementation HelperClass

+ (NSArray*) getSurveyQuestions
{
	return  _surveyQuestionsArray;
}

+ (void)initSurveyQuestionsWithListener:(id<SurveyQuestionReadyProtocol>)listener AndSurveyId:(NSString*)surveyId {
	
	_listener = listener;
	_responseData = [[NSMutableData alloc] init];
	
	[self getSurveyQuestionsList:surveyId];
}

+ (void) updateSurveysList:(NSString*)surveyId {
	NSString *urlString = [NSString stringWithFormat:@"%@?SurveyId=%@", kSurveysWebService, surveyId] ;
	
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	//Create GET HTTP Method Request
	[request setHTTPMethod:@"GET"];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

+ (void)getSurveyQuestionsList:(NSString*)surveyId {
	NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	[HelperClass copyFileToDocuments:@"SurveyQuestionsList.plist"];
	[HelperClass copyFileToDocuments:@"Utilities.plist"];
	
	NSString *surveyQuestionsPlistPath = [homeDir stringByAppendingPathComponent:@"SurveyQuestionsList.plist"];
	
	NSString *utilitiesPlistPath = [homeDir stringByAppendingPathComponent:@"Utilities.plist"];
	NSDictionary *utilitiesDictionary = [NSDictionary dictionaryWithContentsOfFile: utilitiesPlistPath];
	
	NSMutableData *surveysData = [NSMutableData dataWithContentsOfFile:surveyQuestionsPlistPath];
	NSString *syncedSurveyId = [utilitiesDictionary objectForKey:@"Synced_Survey_Id"];
	
	/*
	NSDate *lastSyncDate = [utilitiesDictionary objectForKey:@"Survey_Last_Sync_Date"];
	NSInteger syncAfterTimeInterval = [lastSyncDate timeIntervalSinceNow] / (3600 * 24); // Get interval by days
	syncAfterTimeInterval *= -1; //This is because the lastSyncDate will always be in the past.
	*/
	
	BOOL forceSyncSurvey = ((AppDelegate*)[UIApplication sharedApplication].delegate).synchronizeSurvey;
	
	if(surveysData.length < 50 || forceSyncSurvey || ![syncedSurveyId isEqualToString:surveyId])
	{
		[self updateSurveysList:surveyId];
	}
	else
	{
		//[self performSelector:@selector(updateSurveysList) withObject:nil afterDelay:(24 * 7 - syncAfterTimeInterval) * 3600 * 24];
		
		_responseData = surveysData;
		[self connectionDidFinishLoading:nil];
	}
	
}

+ (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

+ (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSError *error = nil;
	NSArray *_jsonArray = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
	
	NSString *surveyId = @"-1";
	
	_surveyQuestionsArray = [[NSMutableArray alloc] init];
	
	if (error != nil) {
		NSLog(@"Error parsing JSON.");
	}
	else {
		NSLog(@"Array: %@", _jsonArray);
		
		for (NSDictionary *questionDict in _jsonArray) {
			NSString *questionId = [questionDict objectForKey:@"Id"];
			NSString *questionText = [questionDict objectForKey:@"Question__c"];
			NSString *choicesString = [questionDict objectForKey:@"Choices__c"];
			NSString *questionTypeString = [questionDict objectForKey:@"Type__c"];
			BOOL isRequired = (BOOL)[[questionDict objectForKey:@"Required__c"] integerValue];
			NSString *questionSurveyId = [questionDict objectForKey:@"Survey__c"];
			surveyId = questionSurveyId;
			
			NSDictionary *survey__r = [questionDict objectForKey:@"Survey__r"];
			NSString *surveyLanguage = [survey__r objectForKey:@"Language_Preference__c"];
			
			NSArray *questionOptions = [choicesString componentsSeparatedByString:@"\r\n"];
			
			QuestionType questionType = SingleSelect;
			if ([questionTypeString rangeOfString:@"Single Select"].location != NSNotFound)
				questionType = SingleSelect;
			else if ([questionTypeString rangeOfString:@"Free Text"].location != NSNotFound)
				questionType = Text;
			
			SurveyQuestion *tempQuestion = [[SurveyQuestion alloc] initWithId:questionId AndQuestionText:questionText andType:questionType AndOptions:questionOptions AndRequired:isRequired  AndSurveyId:questionSurveyId AndSurveyLanguage:surveyLanguage];
			
			[_surveyQuestionsArray addObject:tempQuestion];
		}
	}
	
	if(connection != nil)
	{
		NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		
		NSString *surveyQuestionsPlistPath = [homeDir stringByAppendingPathComponent:@"SurveyQuestionsList.plist"];
		
		NSString *utilitiesPlistPath = [homeDir stringByAppendingPathComponent:@"Utilities.plist"];
		NSDictionary *utilitiesDictionary = [NSDictionary dictionaryWithContentsOfFile: utilitiesPlistPath];
		
		[utilitiesDictionary setValue:[NSDate date] forKey:@"Survey_Last_Sync_Date"];
		[utilitiesDictionary setValue:surveyId forKeyPath:@"Synced_Survey_Id"];
		[utilitiesDictionary writeToFile:utilitiesPlistPath atomically:YES];
		
		[_responseData writeToFile:surveyQuestionsPlistPath atomically:YES];
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEEE, MMMM dd yyyy, hh:mm a"];//Sunday, April 6 2014, 1:50 PM
		NSString *str_date = [dateFormat stringFromDate:[NSDate date]];
		
		[[NSUserDefaults standardUserDefaults] setObject:str_date forKey:@"survey_last_sync_date_preference"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	[_listener surveyQuestionsReady];
	
}

+ (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"error - read error object for details");
	
	_surveyQuestionsArray = [[NSMutableArray alloc] init];
	
	[_listener surveyQuestionsSyncNoInternetFound];
}

+ (void)submitSurvey:(RequestWrapper*) requestWrapper
{
	NSURL *url = [NSURL URLWithString:kSurveysWebService];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
	//Create POST HTTP Method Request
	[request setHTTPMethod:@"POST"];
	
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:[requestWrapper getWrapperToConvertToJSON] forKey:@"requestWrapper"]	options:0 error:&error];
	
	[request setHTTPBody:jsonData];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	if (((AppDelegate*)[[UIApplication sharedApplication] delegate]).isReachable)
		[[NSURLConnection alloc] initWithRequest:request delegate:nil];
	else
	{
		NSString *surveysPlistPath = [[NSBundle mainBundle] pathForResource: @"UnsubmittedSurveys" ofType: @"plist"];
		
		NSMutableArray *surveysDataArray = [NSMutableArray arrayWithContentsOfFile:surveysPlistPath];
		
		[surveysDataArray addObject:jsonData];
		[surveysDataArray writeToFile:surveysPlistPath atomically:YES];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"No internet connection detected. Survey will be submitted when connected." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[alert show];
		
		//Save survey for later to submit
	}
}

+ (void)submitUnsubmittedSurveys
{
	NSString *surveysPlistPath = [[NSBundle mainBundle] pathForResource: @"UnsubmittedSurveys" ofType: @"plist"];
	
	NSMutableArray *surveysDataArray = [NSMutableArray arrayWithContentsOfFile:surveysPlistPath];
	
	for (NSData *surveyData in surveysDataArray) {
		NSURL *url = [NSURL URLWithString:kSurveysWebService];
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
		
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:surveyData];
		[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		[[NSURLConnection alloc] initWithRequest:request delegate:nil];
	}
	
	surveysDataArray = [[NSMutableArray alloc] init];
	[surveysDataArray writeToFile:surveysPlistPath atomically:YES];
}

+ (void)copyFileToDocuments:(NSString*) fileName
{
	BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:fileName];
    
	success = [fileManager fileExistsAtPath:databasePath];
    
	if(success) {
        NSLog(@"file found in Documents folder");
        return;
	}
    else {
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
		[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		NSLog(@"file not found in Documents folder.\nCopied to documents folder.");
	}
}

@end
