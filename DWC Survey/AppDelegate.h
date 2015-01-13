//
//  AppDelegate.h
//  DWCSurveyTest
//
//  Created by Mina Zaklama on 1/30/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL isReachable;
@property (nonatomic, strong) NSString *counterNumber;
@property (nonatomic) BOOL synchronizeSurvey;
@property (nonatomic) BOOL synchronizeSurveysNames;

@end
