//
//  HelperClass.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/10/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <Foundation/Foundation.h>
//* Production
#define kSurveysWebService @"http://dwcsite.force.com/DWCSurveysServices/services/apexrest/surveys_webservice"
#define kSurveyAccountsWebservice @"http://dwcsite.force.com/DWCSurveysServices/services/apexrest/survey_accounts_webservice"
#define kSurveysNamesWebservice @"http://dwcsite.force.com/DWCSurveysServices/services/apexrest/surveys_names_webservice"
//*/

/* Sandbox
#define kSurveysWebService @"https://test-dwcsite.cs8.force.com/DWCSurveysServices/services/apexrest/surveys_webservice"
#define kSurveyAccountsWebservice @"https://test-dwcsite.cs8.force.com/DWCSurveysServices/services/apexrest/survey_accounts_webservice"
 #define kSurveysNamesWebservice @"https://test-dwcsite.cs8.force.com/DWCSurveysServices/services/apexrest/surveys_names_webservice"
//*/
@class RequestWrapper;

@protocol SurveyQuestionReadyProtocol <NSObject>
- (void) surveyQuestionsReady;
- (void) surveyQuestionsSyncNoInternetFound;
@end

@interface HelperClass : NSObject

+ (NSArray*) getSurveyQuestions;
+ (void)initSurveyQuestionsWithListener:(id<SurveyQuestionReadyProtocol>)listener AndSurveyId:(NSString*)surveyId;
+ (void)submitSurvey:(RequestWrapper*) requestWrapper;
+ (void)submitUnsubmittedSurveys;
+ (void)copyFileToDocuments:(NSString*) fileName;

@end