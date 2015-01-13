//
//  SurveyQuestion.m
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/11/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "SurveyQuestion.h"

@implementation SurveyQuestion

/*
- (id) initWithQuestion:(NSString*)text andType:(QuestionType)type andOptions:(NSArray*)options
{
	if (!(self = [super init]))
		return nil;
	
	self.questionText = text;
	self.questionOptionsArray = options;
	self.questionType = type;
	
	return self;
}
*/

- (id) initWithId:(NSString*)Id AndQuestionText:(NSString*)text andType:(QuestionType)type AndOptions:(NSArray*)options AndRequired:(BOOL)required AndSurveyId:(NSString*) surveyId AndSurveyLanguage:(NSString*)language
{
	if (!(self = [super init]))
		return nil;
	
	self.questionId = Id;
	self.questionText = text;
	
	NSMutableArray *optionsMutableArray = [[NSMutableArray alloc] init];
	NSMutableArray *optionsWeightMutableArray = [[NSMutableArray alloc] init];
	NSMutableArray *optionsColorMutableArray = [[NSMutableArray alloc] init];
	
	for (NSString *option in options) {
		NSArray *chunks = [option componentsSeparatedByString: @"|"];
		
		[optionsMutableArray addObject:[chunks objectAtIndex:0]];
		
		if([chunks count] > 1) {
			[optionsWeightMutableArray addObject:[chunks objectAtIndex:1]];
			[optionsColorMutableArray addObject:[chunks objectAtIndex:2]];
		}
	}
	self.questionOptionsArray = [[NSArray alloc] initWithArray:optionsMutableArray];// options;
	self.questionOptionsWeightArray = [[NSArray alloc] initWithArray:optionsWeightMutableArray];
	self.questionOptionsColorArray = [[NSArray alloc] initWithArray:optionsColorMutableArray];
	
	self.questionType = type;
	self.isRequired = required;
	self.questionSurveyId = surveyId;
	self.surveyLanguage = language;
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	SurveyQuestion *copy = [[[self class] allocWithZone:zone] init];
	copy.questionId = [_questionId copyWithZone:zone];
	copy.questionText = [_questionText copyWithZone:zone];
	copy.questionOptionsArray = [_questionOptionsArray copyWithZone:zone];
	copy.questionType = _questionType;
	copy.isRequired = _isRequired;
	copy.surveyLanguage = _surveyLanguage;
	
	return copy;
}

- (NSString*) surveyLanguageAbbreviation
{
	NSString* langAbb = @"en";
	
	if ([self.surveyLanguage isEqualToString:@"English"]) {
		langAbb = @"en";
	} else if ([self.surveyLanguage isEqualToString:@"Arabic"]){
		langAbb = @"ar";
	}
	
	return langAbb;
}

@end
