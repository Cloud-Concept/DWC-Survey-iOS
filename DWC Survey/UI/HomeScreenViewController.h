//
//  HomeScreenViewController.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/12/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetailsPopupViewController.h"
#import "HelperClass.h"

@class RequestWrapper;

@interface HomeScreenViewController : UIViewController <UIPopoverControllerDelegate, CompanyDetailsPopoverDelegate, SurveyQuestionReadyProtocol>

@property (strong, nonatomic) IBOutlet UILabel *buttonLabelOne;
@property (strong, nonatomic) IBOutlet UILabel *buttonLabelTwo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) NSString *surveyId;
@property (nonatomic, strong) RequestWrapper *requestWrapper;

@property (nonatomic) UIPopoverController *companyDetailsPopover;

- (IBAction)startSurveyClicked:(id)sender;
@end
