#import "AllTeamNamesServiceParser.h"
#import "Team.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AllTeamNamesServiceParserSpec)

describe(@"AllTeamNamesServiceParser", ^{
    __block AllTeamNamesServiceParser *subject;
    
    beforeEach(^{
        subject = [[AllTeamNamesServiceParser alloc] init];
    });
    
    describe(@"parsing top team response", ^{
        __block NSDictionary *results;
        
        beforeEach(^{
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AllTeamNamesJSON" ofType:@"json"];
            NSLog(@"FILE PATH: %@",filePath);
            NSData *testResponse = [NSData dataWithContentsOfFile:filePath];
            results = [subject parseAllTeamNamesResponse:testResponse];
        });
        
        it(@"should create a dictionary with the correct model objects from the response", ^{
            [results count] should equal(3);
            Team *team1 = [results objectForKey:@"LOU"];
            team1.teamMarket should equal(@"Louisville");
            team1.teamName should equal(@"Cardinals");
            
            Team *team2 = [results objectForKey:@"WF"];
            team2.teamMarket should equal(@"Wake Forest");
            team2.teamName should equal(@"Demon Deacons");
            
            Team *team3 = [results objectForKey:@"BC"];
            team3.teamMarket should equal(@"Boston College");
            team3.teamName should equal(@"Eagles");
            
        });
    });
});

SPEC_END
