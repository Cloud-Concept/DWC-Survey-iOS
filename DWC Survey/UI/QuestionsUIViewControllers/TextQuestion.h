//
//  QuestionOneViewController.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 1/30/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperQuestionViewController.h"

@interface TextQuestion : SuperQuestionViewController <SurveyQuestionViewProtocol>

@property (nonatomic) CGPoint scrollViewOffset;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextView *answerTextView;

@end
