//
//  RequestWrapper.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 1/30/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestWrapper : NSObject

@property (strong, atomic) NSDictionary *surveyTaker;
@property (strong, atomic) NSMutableArray *surveyQuestionResponseList;

- (id) initWithRequestWrapper:(RequestWrapper *) request;

- (NSDictionary *) getWrapperToConvertToJSON;

@end
