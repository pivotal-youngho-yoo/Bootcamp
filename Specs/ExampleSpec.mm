using namespace Cedar::Matchers;
using namespace Cedar::Doubles;
#import "ScheduledGame.h"
#import "Team.h"
#import "ScheduleListTableViewController.h"
#import "TeamRequestManager.h"

SPEC_BEGIN(ExampleSpec)

/* This is not an exhaustive list of usages.
   For more information, please visit https://github.com/pivotal/cedar */

describe(@"Example specs on NSString", ^{

    it(@"lowercaseString returns a new string with everything in lower case", ^{
        [@"FOOBar" lowercaseString] should equal(@"foobar");
    });

    it(@"length returns the number of characters in the string", ^{
        [@"internationalization" length] should equal(20);
    });

    describe(@"isEqualToString:", ^{
        it(@"should return true if the strings are the same", ^{
            [@"someString" isEqualToString:@"someString"] should be_truthy;
        });

        it(@"should return false if the strings are not the same", ^{
            [@"someString" isEqualToString:@"anotherString"] should_not be_truthy;
        });
    });

    describe(@"NSMutableString", ^{
        it(@"should be a kind of NSString", ^{
            [NSMutableString string] should be_instance_of([NSString class]).or_any_subclass();
        });
    });
});

describe(@"test team object", ^{
    it(@"initalizes properly",
       ^{
           NSString *name = @"Warriors";
           NSString *teamid = @"WW";
           NSString *market = @"University of Waterloo";
           NSNumber *rank = @1;
           Team *exampleTeam = [[Team alloc] initWithTeamId:teamid teamName:name teamMarket:market rank:rank];
           exampleTeam should be_instance_of([Team class]);
           [exampleTeam.teamName isEqualToString:name] should be_truthy;
           [exampleTeam.teamId isEqualToString:teamid] should be_truthy;
           [exampleTeam.teamMarket isEqualToString:market] should be_truthy;
           [exampleTeam.rank isEqualToNumber:rank] should be_truthy;
           
           
       });
});

describe(@"test getTeamRequest", ^{
    it(@"gets httpRequest", ^{
       
        TeamRequestManager *manager = [[TeamRequestManager alloc]init];
        [manager makeRequest];
        
    });
    
});

SPEC_END

