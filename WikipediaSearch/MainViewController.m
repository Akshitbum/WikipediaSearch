//
//  Created by Akshit Bum
//

#import "MainViewController.h"
#import "ResultCell.h"
#import "DetailViewController.h"
#import "WikiResultModel.h"
#import "WikiSearchService.h"

@interface MainViewController () <UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>

@property WikiResultModel *resultModel;

@property NSUInteger queryRequestId;

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic,weak) UITableView *resultsTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *wikiSearchBar = [[UISearchBar alloc] init];
    [self.view addSubview:wikiSearchBar];
    self.searchBar = wikiSearchBar;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20],
                                [NSLayoutConstraint constraintWithItem:self.searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
                                ]];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    self.resultsTableView = tableView;
    self.resultsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.resultsTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.resultsTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.resultsTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.resultsTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                                ]];
    
    self.resultsTableView.dataSource = self;
    self.resultsTableView.delegate = self;
    [self.resultsTableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCell"];
    
    //initialize model
    self.resultModel = [[WikiResultModel alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    for(NSUInteger resultIndex = 0 ; resultIndex < [self.resultModel count] ; ++resultIndex)
    {
        WikiResult *aResult = [self.resultModel resultAtIndex:resultIndex];
        aResult.renditionImage = nil;
    }
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultModel count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *subtitleText = [self.resultModel resultAtIndex:indexPath.row].subtitle;
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin;
    
    CGRect rect = [subtitleText boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 55, 1000.0f) options:options attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    return rect.size.height + 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    
    //clean up the cell
    cell.renditionImage = nil;
    cell.title = nil;
    cell.subtitle = nil;
    
    WikiResult *result = [self.resultModel resultAtIndex:indexPath.row];
    cell.title = result.title;
    cell.subtitle = result.subtitle;
    
    if(result.renditionImage == nil)
    {
        [cell startActivity];
        [[WikiSearchService sharedInstance] callToDownloadImage:result.renditionURL completionHandler:^(id result, NSError *error) {
            if(!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.resultModel resultAtIndex:indexPath.row].renditionImage = result;
                    [self.resultsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ResultCell *blockCell = [tableView cellForRowAtIndexPath:indexPath];
                    [blockCell stopActivity];
                });
            }
        }];
    }
    else
    {
        cell.renditionImage = result.renditionImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
    return cell;
}

#pragma mark - Tableview delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.result = [self.resultModel resultAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *resultHeaderView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 50)];
    resultHeaderView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    
    UILabel *labelView = [[UILabel alloc] init];
    [labelView setText:@"Results"];
    labelView.translatesAutoresizingMaskIntoConstraints = NO;
    [labelView sizeToFit];
    
    [resultHeaderView addSubview:labelView];
    [resultHeaderView addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:labelView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:resultHeaderView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                       [NSLayoutConstraint constraintWithItem:labelView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:resultHeaderView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                       [NSLayoutConstraint constraintWithItem:resultHeaderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:50]]];
    
    return resultHeaderView;
}

#pragma mark - Searchbar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [[WikiSearchService sharedInstance] callToSearchWiki:searchBar.text completionHandler:^(id result, NSError *error) {
        if(!error) {
                    [self.resultModel reset];
                    [self.resultModel addResults:result];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.resultsTableView reloadData];
                    });

        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[WikiSearchService sharedInstance] callToSearchWiki:searchBar.text completionHandler:^(id result, NSError *error) {
        if(!error) {
            [self.resultModel reset];
            [self.resultModel addResults:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.resultsTableView reloadData];
            });
        }
    }];
    
}

@end
