//
//  ScheduleListTableViewController.h
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-08-27.
//
//

#import <UIKit/UIKit.h>

@class TopTeamService;
@class ScheduleService;
@class AllTeamNamesService;

@interface ScheduleListTableViewController : UITableViewController

// Public properties used for Dependency Injection

@property (nonatomic, strong) TopTeamService *topTeamService;
@property (nonatomic, strong) ScheduleService *scheduleService;
@property (nonatomic, strong) AllTeamNamesService *allTeamNamesService;

@end
