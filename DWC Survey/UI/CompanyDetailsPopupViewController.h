//
//  SubmitPopupViewController.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 2/19/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverPickerViewController.h"

@class CompanyDetailsPopupViewController;

@protocol CompanyDetailsPopoverDelegate <NSObject>
- (void)dismissPopover;
- (void)donePopoverWithCompanyId:(NSString*)companyId CompanyName:(NSString*)companyName PersonName:(NSString*)personName Designation:(NSString*)designation SurveyId:(NSString*)surveyId;
@end

typedef enum  {
	RegisteredCompany = 0,
	NonRegisteredCompany = 1
} CompanyType;

@interface CompanyDetailsPopupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate, PopoverPickerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameLabelField;
@property (strong, nonatomic) IBOutlet UITextField *personNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *personNameLabelField;
@property (strong, nonatomic) IBOutlet UITextField *designationTextField;
@property (strong, nonatomic) IBOutlet UILabel *designationLabelField;

@property (strong, nonatomic) IBOutlet UILabel *surveyNameLabelField;

@property (strong, nonatomic) IBOutlet UITableView *suggestionTableView;
@property (strong, nonatomic) IBOutlet UIButton *registeredButton;
@property (strong, nonatomic) IBOutlet UIButton *nonRegisteredButton;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *selectSurveyButton;

@property (strong, nonatomic) UIPopoverController *pickerPopover;

@property (nonatomic) BOOL finishLoadAccounts;
@property (nonatomic) BOOL finishLoadSurveysNames;
@property (nonatomic, strong) NSArray *accountsJsonArray;
@property (nonatomic, strong) NSMutableData *accountsResponseData;
@property (nonatomic, strong) NSArray *surveysNamesJsonArray;
@property (nonatomic, strong) NSMutableData *surveysNamesResponseData;
@property (nonatomic, strong) NSMutableArray *filteredAccountArray;
@property (nonatomic, weak) id <CompanyDetailsPopoverDelegate> companyDetailsDelegate;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *designation;
@property (nonatomic, strong) NSString* selectedSurveyId;
@property (nonatomic) CompanyType currentCompanyType;
@property (nonatomic, strong) NSString* accountsPlistPath;
@property (nonatomic, strong) NSString* surveysNamesPlistPath;
@property (nonatomic, strong) NSString* utilitiesPlistPath;

- (IBAction)designationEmailTextChanged:(id)sender;
- (IBAction)personNameTextChanged:(id)sender;
- (IBAction)companyNameTextChanged:(id)sender;
- (IBAction)doneClicked:(id)sender;
- (IBAction)sectionButtonClicked:(id)sender;
- (IBAction)selectSurveyClicked:(id)sender;

@end
