//
//  GameInfoViewController.m
//  FootballSchedule
//
//  Created by DX088-XL on 2014-09-05.
//
//

#import "GameInfoViewController.h"

@interface GameInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *awayTeamMarketLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamMarketLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation GameInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.awayTeamMarketLabel.text = self.awayTeamMarketName;
    self.homeTeamMarketLabel.text = self.homeTeamMarketName;
    self.networkLabel.text = self.network;
    NSMutableString *location = [[NSMutableString alloc] init];
    [location appendString:self.city];
    [location appendString:@", "];
    [location appendString:self.state];
    self.locationLabel.text = location;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
