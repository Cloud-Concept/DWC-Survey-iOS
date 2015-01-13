//
//  QuestionTwoViewController.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 1/30/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperQuestionViewController.h"

@interface SingleSelectQuestion : SuperQuestionViewController <SurveyQuestionViewProtocol>

@property (nonatomic, strong) NSArray *optionsSourceArray;
@property (nonatomic) NSInteger selectedOptionIndex;

@property (strong, nonatomic) IBOutlet UIButton *optionOneButton;
@property (strong, nonatomic) IBOutlet UIButton *optionTwoButton;
@property (strong, nonatomic) IBOutlet UIButton *optionThreeButton;
@property (strong, nonatomic) IBOutlet UIButton *optionFourButton;
@property (strong, nonatomic) IBOutlet UIButton *optionFiveButton;

- (IBAction)optionSelected:(id)sender;
- (void)setButtonStyle:(UIButton*)button;

@end
