//
//  SearchTableViewController.m
//  Hinton
//
//  Created by Brandon Roberts on 5/21/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "SearchTableViewController.h"
#import "AppDelegate.h"
#import "DataService.h"

@interface SearchTableViewController () 

//@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *allGenres;
@property (strong, nonatomic) NSArray *filteredGenres;

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchCell"];

  AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.restaurantDataService fetchGenresList: ^ (NSArray<Genre *> * genresList) {
    self.allGenres = genresList;
    self.filteredGenres = genresList;
  } failure: ^ (NSError * error) {
    NSLog(@"Error: %@", error.localizedDescription);
  }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.filteredGenres.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseID = @"SearchCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
  cell.textLabel.text = self.filteredGenres[indexPath.row];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(searchTableDidSelectGenre:)]) {
    [self.delegate searchTableDidSelectGenre:self.filteredGenres[indexPath.row]];
    
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - SearchController Delegate

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  
}

-(void)setFilteredGenres:(NSArray *)filteredGenres {
  _filteredGenres = filteredGenres;
  [self.tableView reloadData];
}


@end
