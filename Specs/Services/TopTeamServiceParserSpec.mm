#import <Cedar/Cedar.h>
#import "TopTeamServiceParser.h"
#import "Team.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(TopTeamServiceParserSpec)

describe(@"TopTeamServiceParser", ^{
    __block TopTeamServiceParser *subject;
    
    beforeEach(^{
        subject = [[TopTeamServiceParser alloc] init];
    });
    
    describe(@"parsing top team response", ^{
        __block NSDictionary *results;
        
        beforeEach(^{
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TopTeamsJSON" ofType:@"json"];
            NSData *testResponse = [NSData dataWithContentsOfFile:filePath];
            results = [subject parseTopTeamsResponse:testResponse];
        });
        
        it(@"should create a dictionary with the correct model objects from the response", ^{
            [results count] should equal(1);
            Team *topTeam = [results objectForKey:@"BAMA"];
            topTeam.teamId should equal(@"BAMA");
            topTeam.teamName should equal(@"Crimson Tide");
            topTeam.teamMarket should equal(@"Alabama");
            topTeam.rank should equal(1);
        });
    });
});

SPEC_END