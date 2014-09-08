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

#define SCHEDULE_URL_REQUEST "http://api.sportsdatallc.org/ncaafb-t1/2014/REG/"
#define SCHEDULE_SEARCH "/schedule.json?api_key=jmtzp6kchp9n9vka5s7e6hje"
#define TEAM_URL_REQUEST "http://api.sportsdatallc.org/ncaafb-t1/polls/AP25/2013/"
#define TEAM_SEARCH "/rankings.json?api_key=jmtzp6kchp9n9vka5s7e6hje"
#define TEAMLIST_URL_REQUEST "http://api.sportsdatallc.org/ncaafb-t1/teams/FBS/hierarchy.json?api_key=jmtzp6kchp9n9vka5s7e6hje"
#define TAG_GAME "games"
#define TAG_RANKINGS "rankings"
#define TAG_CONFERENCES "conferences"
#define TAG_SUBDIVISIONS "subdivisions"
#define TAG_TEAMS "teams"

@interface ScheduleListTableViewController ()

@property NSMutableDictionary *displayedTeams; // top 25 ranked teams
@property NSMutableArray *displayedGames;      // list of games the top 25 rankd teams are playing
@property NSMutableDictionary *allTeams;       // list of all NCAA teams

@property NSURLConnection *getTeamList;
@property NSURLConnection *getScheduleList;
@property NSURLConnection *getTeamNames;
@property NSMutableData *receivedData;

@end

@implementation ScheduleListTableViewController


- (void)loadInitialData
{
    // Create Request to get the top 25 ranked teams.
    [self requestTopTeams];
}

// This method uses the "getTeamListConnection" to request for the top 25 ranked NCAA football teams
- (void)requestTopTeams
{
    NSInteger week = [self getThisWeek];
    NSNumber *numberOfWeeks = [[NSNumber alloc] initWithInt:week];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", @TEAM_URL_REQUEST, numberOfWeeks, @TEAM_SEARCH ];
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.receivedData = [[NSMutableData alloc] init];
    
    // create the connection with the request and start loading the data
    self.getTeamList = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)requestSchedule
{
    NSNumber *weekOfSeason = [[NSNumber alloc] initWithInt:[self getThisWeek]];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", @SCHEDULE_URL_REQUEST, weekOfSeason, @SCHEDULE_SEARCH ];
    NSURLRequest *connectionRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.receivedData = [[NSMutableData alloc] init];
    
    self.getScheduleList = [[NSURLConnection alloc] initWithRequest:connectionRequest delegate:self startImmediately:YES];
}

- (void)requestTeamNames
{
    NSURLRequest *connectionRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@TEAMLIST_URL_REQUEST]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:60.0];
    
    self.receivedData = [[NSMutableData alloc] init];
    
    self.getTeamNames = [[NSURLConnection alloc] initWithRequest:connectionRequest delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSNumber *code1 = [[NSNumber alloc] initWithInt:code];
    NSLog(@"%@",code1);
}

// Parse the data that is recieved from the HTTP request
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

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

// Make next HTTP Request once connection is done
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == self.getTeamList) {
        [self parseTopTeams];
        [self requestSchedule];
    } else if(connection == self.getScheduleList) {
        [self parseSchedule];
        [self requestTeamNames];
    } else if(connection == self.getTeamNames) {
        [self parseTeamNames];
    }
}

- (void)parseTopTeams
{
    NSError *error = nil;
    NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *jsonTeams = [parsedResponse valueForKey:@"rankings"];
    for(NSDictionary *teamdict in jsonTeams) {
        NSString *name = [teamdict valueForKey:@"name"];
        NSString *market = [teamdict valueForKey:@"market"];
        NSString *teamid = [teamdict valueForKey:@"id"];
        NSNumber *rank = [teamdict valueForKey:@"rank"];
        
        Team *teamInList = [[Team alloc] initWithTeamId:teamid teamName:name teamMarket:market rank:rank];
        
        [self.displayedTeams setObject:teamInList forKey:teamid];
    }
    NSLog(@"Successfull Received Top 25 Teams");
}

- (void)parseSchedule
{
    NSError *error = nil;
    NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"Failed getting weekly schedule");
    } else {
        NSMutableArray *jsonGames = [parsedResponse valueForKey:@TAG_GAME];
        for(NSDictionary *gamedict in jsonGames) {
            NSString *home = [gamedict valueForKey:@"home"];
            NSString *away = [gamedict valueForKey:@"away"];
            NSString *dateString = [gamedict valueForKey:@"scheduled"];
            
            NSDictionary *venue = [gamedict valueForKey:@"venue"];
            NSString *city = [venue valueForKey:@"city"];
            NSString *state = [venue valueForKey:@"state"];
            
            NSDictionary *broadcast = [gamedict valueForKey:@"broadcast"];
            NSString *network = [broadcast valueForKey:@"network"];
            
            if([self.displayedTeams objectForKey:home] || [self.displayedTeams objectForKey:away]) {
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss+hh:mm"];
                date = [dateFormat dateFromString:dateString];
                
                Team *homeTeam = [[Team alloc] initWithJustId:home];
                Team *awayTeam = [[Team alloc] initWithJustId:away];
                
                ScheduledGame *game = [[ScheduledGame alloc]initWithHomeTeam:homeTeam AwayTeam:awayTeam Date:date Network:network City:city State:state];
                [self.displayedGames addObject:game];
                [self.tableView reloadData];
            }
        }
        NSLog(@"Successfully Received Scheduled Games");
    }
}

- (void)parseTeamNames
{
    NSError *error = nil;
    
    NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"Failed: Getting team names");
    } else {
        NSMutableArray *jsonConferences = [parsedResponse valueForKey:@TAG_CONFERENCES];
        for(NSDictionary *conference in jsonConferences) {
            NSMutableArray *jsonSubdivisions = [conference valueForKey:@TAG_SUBDIVISIONS];
            for(NSDictionary *subdivision in jsonSubdivisions)
            {
                //NSLog(@"subdivison");
                NSMutableArray *jsonteams = [subdivision valueForKey:@TAG_TEAMS];
                for(NSDictionary *teamdict in jsonteams) {
                    NSString *name = [teamdict valueForKey:@"name"];
                    NSString *market = [teamdict valueForKey:@"market"];
                    NSString *teamid = [teamdict valueForKey:@"id"];
                    NSNumber *rank = [teamdict valueForKey:@"rank"];
                    
                    Team *teamInList = [[Team alloc] initWithTeamId:teamid teamName:name teamMarket:market rank:rank];
                    [self.allTeams setObject:teamInList forKey:teamid];
                }
            }
        }
        [self completeDisplayedGames];
        NSLog(@"Got Team List");
    }
}

// Return the week of the Football season
-(NSInteger)getThisWeek
{
    // Calculate the difference between today's date and the date of the first game of the season.
    NSDate *today = [NSDate date];
    NSString *weekOneString = @"2014-08-24T19:30:00+00:00"; //Date of the first week of the season
    NSDate *weekOnedate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss+hh:mm"];
    weekOnedate = [dateFormat dateFromString:weekOneString];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSWeekCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:weekOnedate toDate:today options:0];
    NSInteger numberOfWeeks = [components week];
    return numberOfWeeks + 1;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.displayedTeams = [[NSMutableDictionary alloc] init];
    self.displayedGames = [[NSMutableArray alloc] init];
    self.allTeams = [[NSMutableDictionary alloc] init];
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
