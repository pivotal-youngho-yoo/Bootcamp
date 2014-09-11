//
//  ScheduleListTableViewController.m
//  FootballSchedule
//
//  Created by Youngho Yoo on 2014-08-27.
//
//

#import "ScheduleListTableViewController.h"
#import "ScheduledGame.h"
#import "Team.h"
#import "GameInfoViewController.h"
#import "TopTeamService.h"
#import "ScheduleService.h"
#import "AllTeamNamesService.h"

@interface ScheduleListTableViewController ()

@property NSDictionary *displayedTeams;        // top 25 ranked teams
@property NSMutableArray *displayedGames;      // list of games the top 25 rankd teams are playing
@property NSDictionary *allTeams;              // list of all NCAA teams

@end

@implementation ScheduleListTableViewController

#pragma mark - initialize

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _topTeamService = [[TopTeamService alloc] init];
        _scheduleService = [[ScheduleService alloc] init];
        _allTeamNamesService = [[AllTeamNamesService alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.displayedTeams = [[NSDictionary alloc] init];
    self.displayedGames = [[NSMutableArray alloc] init];
    self.allTeams = [[NSMutableDictionary alloc] init];
    
    // Create Request to get the top 25 ranked teams
    [self requestTopTeams];
}

#pragma mark - HTTP Requests

- (void)requestTopTeams {
    [self.topTeamService requestTopTeamsWithSuccessBlock:^(NSDictionary *teamDictionary) {
        self.displayedTeams = teamDictionary;
        [self requestSchedule];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get top teams.");
    }];
}

- (void)requestSchedule {
    [self.scheduleService requestScheduleWithSuccessBlock:^(NSArray *schedule) {
        for(ScheduledGame *game in schedule) {
            NSString *home = game.homeTeam.teamId;
            NSString *away = game.awayTeam.teamId;
            
            if([self.displayedTeams objectForKey:home] || [self.displayedTeams objectForKey:away]) {
                [self.displayedGames addObject:game];
                [self.tableView reloadData];
            }
        }
        // Request for list of all teams
        [self requestTeamNames];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get the weekly schedule.");
    }];
}

- (void)requestTeamNames {
    [self.allTeamNamesService requestAllTeamNamesWithSuccessBlock:^(NSDictionary *AllTeamNames) {
        self.allTeams = AllTeamNames;
        [self completeDisplayedGames];
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get the weekly schedule.");
    }];
}

#pragma mark -

- (void) completeDisplayedGames
{
    for(ScheduledGame *game in self.displayedGames) {
        Team *newHome = [self.allTeams valueForKey:game.homeTeam.teamId];
        Team *newAway = [self.allTeams valueForKey:game.awayTeam.teamId];
        
        game.homeTeam.teamMarket = newHome.teamMarket;
        game.awayTeam.teamMarket= newAway.teamMarket;
        [self.tableView reloadData];
    }
}

#pragma mark - Setup UI for table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.displayedGames count];
}

// Input the data into the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
    
    NSString *displayedString;
    ScheduledGame *scheduledGame = [self.displayedGames objectAtIndex:indexPath.row];
    
    displayedString = [[NSString alloc] initWithFormat:@"%@ vs %@ on %@", scheduledGame.homeTeam.teamMarket, scheduledGame.awayTeam.teamMarket, scheduledGame.date];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    NSString *home_identifier = scheduledGame.homeTeam.teamMarket;
    if(home_identifier == nil)
        home_identifier = scheduledGame.homeTeam.teamId;
    label.text = home_identifier;
    
    label = (UILabel *)[cell viewWithTag:2];
    NSString *away_identifier = scheduledGame.awayTeam.teamMarket;
    if(away_identifier == nil)
        away_identifier = scheduledGame.awayTeam.teamId;
    label.text = away_identifier;
    
    label = (UILabel *)[cell viewWithTag:3];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy '@' hh:mm"];
    label.text = [formatter stringFromDate:scheduledGame.date];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueToGameInfo"]) {
        GameInfoViewController *controller = (GameInfoViewController *)[segue destinationViewController];
        UITableViewCell *cell = sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ScheduledGame *game = [self.displayedGames objectAtIndex:indexPath.row];
        
        controller.awayTeamMarketName = [(UILabel *)[cell viewWithTag:1] text];
        controller.homeTeamMarketName = [(UILabel *)[cell viewWithTag:2] text];
        controller.network = game.network;
        controller.city = game.city;
        controller.state = game.state;
    }
    

}


@end
