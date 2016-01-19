//
//  RestaurantInfoTableViewCell.m
//  Hinton
//
//  Created by Brandon Roberts on 5/19/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "RestaurantInfoTableViewCell.h"
#import "Restaurant.h"
#import "Address.h"
#import "Hours.h"


@interface RestaurantInfoTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantGenreLabel;

@property (strong, nonatomic) IBOutlet UILabel *price1;
@property (strong, nonatomic) IBOutlet UILabel *price2;
@property (strong, nonatomic) IBOutlet UILabel *price3;
@property (strong, nonatomic) IBOutlet UILabel *price4;

@property (strong, nonatomic) IBOutlet UIButton *mainWebsiteButton;
@property (strong, nonatomic) IBOutlet UILabel *mainMenuSeparator;
@property (strong, nonatomic) IBOutlet UIButton *menuWebsiteButton;
@property (strong, nonatomic) IBOutlet UILabel *menuBlogSeparator;
@property (strong, nonatomic) IBOutlet UIButton *blogWebsiteButton;

@property (strong, nonatomic) IBOutlet UIButton *restaurantPhoneButton;
@property (strong, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (strong, nonatomic) IBOutlet UIButton *restaurantHoursButton;
@property (strong, nonatomic) IBOutlet UILabel *recommendedItemLabel;

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *restaurantPrice;
@property (strong, nonatomic) NSArray *restaurantGenre;
@property (strong, nonatomic) NSURL *mainWebsiteURL;
@property (strong, nonatomic) NSURL *menuWebsiteURL;
@property (strong, nonatomic) NSURL *blogWebsiteURL;
@property (strong, nonatomic) NSString *restaurantPhone;
@property (strong, nonatomic) Address *restaurantAddress;
@property (strong, nonatomic) Hours *restaurantHours;

@property (strong, nonatomic) UIColor * grayColor;
@property (strong, nonatomic) UIColor * greenColor;

@property bool hoursExpanded;

@end


@implementation RestaurantInfoTableViewCell

- (void)awakeFromNib {
  self.hoursExpanded = false;

  self.greenColor = [UIColor colorWithRed: 0.0 green: 0.5 blue: 0.0 alpha: 1.0];
  self.grayColor = [UIColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0];

  self.restaurantNameLabel.text = nil;
  self.restaurantGenreLabel.text = nil;
  [self.restaurantPhoneButton setTitle: nil forState:UIControlStateNormal];
  self.restaurantAddressLabel.text = nil;
  [self.restaurantHoursButton setTitle: nil forState: UIControlStateNormal];
  self.restaurantHoursButton.titleLabel.numberOfLines = 0;
  self.recommendedItemLabel.text = nil;

  // Initialize the price indicators to gray.
  self.price1.textColor = self.grayColor;
  self.price2.textColor = self.grayColor;
  self.price3.textColor = self.grayColor;
  self.price4.textColor = self.grayColor;

  // Initialize the price indicators with the local currency symbol.
  // This code isn't correct - we should use the location of the restaurant, not the locale of the phone.
  // (i.e. if a British user is looking at a restaurant in France, he should see € not £)
  //      NSLocale * myLocale = [NSLocale currentLocale];
  //      NSString * currencySymbol = [myLocale objectForKey: NSLocaleCurrencySymbol];
  // Since we don't have a country field in the Address object, just use $ for now.
  NSString * currencySymbol = @"$";
  self.price1.text = currencySymbol;
  self.price2.text = currencySymbol;
  self.price3.text = currencySymbol;
  self.price4.text = currencySymbol;

  // We have just changed the size of our views, so recalculate layout.
  [self layoutSubviews];
  [self layoutIfNeeded];
}


- (void)setRestaurantToDisplay:(Restaurant *)restaurantToDisplay {
  _restaurantToDisplay = restaurantToDisplay;
  
  self.restaurantName = restaurantToDisplay.name;
  self.restaurantPrice = restaurantToDisplay.pricePoint;
  self.restaurantGenre = restaurantToDisplay.genres;
  self.mainWebsiteURL = restaurantToDisplay.mainURL;
  self.menuWebsiteURL = restaurantToDisplay.menuURL;
  self.blogWebsiteURL = restaurantToDisplay.blogURL;
  self.restaurantPhone = restaurantToDisplay.phone;
  self.restaurantAddress = restaurantToDisplay.address;
  self.restaurantHours = restaurantToDisplay.hours;
  
  self.recommendedItemLabel.text = [self constructRecommendedItemsLabelForItems:restaurantToDisplay.recipes];
  
  [self setupWebsiteButtons];
}


- (void)setRestaurantName:(NSString *)restaurantName {
  _restaurantName = restaurantName;
  self.restaurantNameLabel.text = restaurantName;
}


- (void)setRestaurantPrice:(NSString *)restaurantPrice {
  _restaurantPrice = restaurantPrice;
  NSInteger price = restaurantPrice.integerValue;

  if (price >= 1) { self.price1.textColor = self.greenColor; } else { self.price1.textColor = self.grayColor; }
  if (price >= 2) { self.price2.textColor = self.greenColor; } else { self.price2.textColor = self.grayColor; }
  if (price >= 3) { self.price3.textColor = self.greenColor; } else { self.price3.textColor = self.grayColor; }
  if (price >= 4) { self.price4.textColor = self.greenColor; } else { self.price4.textColor = self.grayColor; }
}


- (void)setRestaurantGenre:(NSArray *)restaurantGenre {
  _restaurantGenre = restaurantGenre;
  self.restaurantGenreLabel.text = [self constructGenreLabelForGenres:self.restaurantGenre];
}


- (void)setMainWebsiteURL:(NSURL *)mainWebsiteURL {
  _mainWebsiteURL = mainWebsiteURL;
}


- (void)setMenuWebsiteURL:(NSURL *)menuWebsiteURL {
  _menuWebsiteURL = menuWebsiteURL;
}


- (void)setBlogWebsiteURL:(NSURL *)blogWebsiteURL {
  _blogWebsiteURL = blogWebsiteURL;
}


- (void)setRestaurantPhone:(NSString *)restaurantPhone {
  _restaurantPhone = restaurantPhone;
  [self.restaurantPhoneButton setTitle: restaurantPhone forState:UIControlStateNormal];
}


- (void)setRestaurantAddress:(Address *)restaurantAddress {
  _restaurantAddress = restaurantAddress;
  
  NSString *addressString = @"";
  
  addressString = [addressString stringByAppendingString:restaurantAddress.streetNumber];
  addressString = [addressString stringByAppendingString:@" "];
  addressString = [addressString stringByAppendingString:restaurantAddress.streetName];
  addressString = [addressString stringByAppendingString:@", "];
  addressString = [addressString stringByAppendingString:restaurantAddress.city];
  addressString = [addressString stringByAppendingString:@", "];
  addressString = [addressString stringByAppendingString:restaurantAddress.state];
  addressString = [addressString stringByAppendingString:@" "];
  addressString = [addressString stringByAppendingString:restaurantAddress.zip];
  
  self.restaurantAddressLabel.text = addressString;
}


- (void)setRestaurantHours:(Hours *)restaurantHours {
  _restaurantHours = restaurantHours;
  [self setupHoursLabel];
}


- (void)hoursButtonPressed {
  // If we are expanded to show hours for all days of the week, then collapse to show only today's hours.
  // If we are collapsed, then expand.
  self.hoursExpanded = ! self.hoursExpanded;

  [self setupHoursLabel];
}


- (NSString *)constructGenreLabelForGenres:(NSArray *)genres {
  NSString *genreLabel;
  
  for (NSString *genre in genres) {
    if (!genreLabel || [genre isEqualToString:@""]) {
      genreLabel = genre;
    } else {
      genreLabel = [genreLabel stringByAppendingString:[NSString stringWithFormat:@", %@", genre]];
    }
  }
  
  if (!genreLabel) {
    return @"Unknown Genre";
  } else {
    return genreLabel;
  }
}


- (NSString *)constructRecommendedItemsLabelForItems:(NSArray *)menuItems {
  NSString *itemsLabel;
  
  for (NSString *item in menuItems) {
    if (!itemsLabel) {
      if (![item isEqualToString:@""]) {
        itemsLabel = item;
      }
    } else {
      itemsLabel = [itemsLabel stringByAppendingString:[NSString stringWithFormat:@", %@", item]];
    }
  }
  
  if (!itemsLabel) {
    return @"Recommended menu items coming soon!";
  } else {
    return itemsLabel;
  }
}


- (void)setupWebsiteButtons {
  bool hasWebsite = (self.mainWebsiteURL && self.mainWebsiteURL.absoluteString.length > 0);
  bool hasMenu = (self.menuWebsiteURL && self.menuWebsiteURL.absoluteString.length > 0);
  bool hasBlog = (self.blogWebsiteURL && self.blogWebsiteURL.absoluteString.length > 0);

  UIView * buttonContainer = self.mainWebsiteButton.superview;

  if (!hasWebsite) {
    [self.mainWebsiteButton removeFromSuperview];
    [self.mainMenuSeparator removeFromSuperview];
  }

  if (!hasMenu) {
    [self.menuWebsiteButton removeFromSuperview];
    [self.menuBlogSeparator removeFromSuperview];
    if (!hasBlog) { [self.mainMenuSeparator removeFromSuperview]; }
  }
  
  if (!hasBlog) {
    [self.blogWebsiteButton removeFromSuperview];
    [self.menuBlogSeparator removeFromSuperview];
  }

  [buttonContainer sizeToFit];
}


- (void)setupHoursLabel {
  // Get the user's current calendar.
  NSCalendar * calendar = [NSCalendar currentCalendar];

  // Get the localized "standalone" weekday names that are appropriate for headings and labels,
  // which may be different from the weekday names used in a specific date: "Среда" versus "среды, 25 октября 1917"
  NSArray<NSString *> * weekdays = [calendar shortStandaloneWeekdaySymbols];

  // Apple's calendar API always returns weekdays using the convention that 1 == Sunday, 7 == Saturday.
  // It is up to you to adjust the order to the local calendar, and to deal with off-by-one issues.
  NSUInteger firstWeekday = [calendar firstWeekday] - 1;
  NSInteger currentWeekday = [calendar component: NSCalendarUnitWeekday fromDate: [NSDate date]] - 1;

  // Build an array of restaurant hours, always starting with Sunday to match Apple's ordering.
  NSMutableArray<NSString *> * hours = [[NSMutableArray alloc] init];
  [hours addObject: self.restaurantHours.sundayHours];
  [hours addObject: self.restaurantHours.mondayHours];
  [hours addObject: self.restaurantHours.tuesdayHours];
  [hours addObject: self.restaurantHours.wednesdayHours];
  [hours addObject: self.restaurantHours.thursdayHours];
  [hours addObject: self.restaurantHours.fridayHours];
  [hours addObject: self.restaurantHours.saturdayHours];

  NSString * hoursLabel;

  if (self.hoursExpanded) {

    // Build the rows of the label, but start with the local calendar's first day of the week and wrap as needed.
    NSUInteger dayIndex = firstWeekday;
    NSMutableString * tempHoursLabel = [[NSMutableString alloc] init];
    NSString * newline = @"";

    for (NSUInteger i = 0; i < [hours count]; i++) {
      dayIndex = (i + firstWeekday) % [hours count];
      [tempHoursLabel appendFormat: @"%@%@: %@", newline, [weekdays objectAtIndex: dayIndex], [hours objectAtIndex: dayIndex]];
      newline = @"\n";
    }

    hoursLabel = tempHoursLabel;
  } else {

    // Only show today's hours.
    hoursLabel = [NSString stringWithFormat: @"%@ ▼", [hours objectAtIndex: currentWeekday]];

  }

  [self.restaurantHoursButton setTitle: hoursLabel forState: UIControlStateNormal];
}

@end
