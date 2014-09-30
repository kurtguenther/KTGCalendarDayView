//
//  KTGWeekdayHeaderViewController.h
//  Pods
//
//  Created by Kurt Guenther on 9/29/14.
//
//

#import <UIKit/UIKit.h>

@interface KTGWeekdayHeaderViewController : UIViewController

@property (nonatomic, strong) NSDate* startDay;
@property (nonatomic) NSInteger selectedIndex;

- (instancetype)initWithStartDay:(NSDate*)day;

@end
