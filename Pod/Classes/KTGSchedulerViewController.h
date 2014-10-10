//
//  KTGSchedulerViewController.h
//  Pods
//
//  Created by Kurt Guenther on 9/29/14.
//
//

#import <UIKit/UIKit.h>
#import "KTGCalendarDayView.h"

#define KTGSchedulerViewControllerDateChanged @"KTGSchedulerViewControllerDateChanged"
#define KTGSchedulerViewControllerNewDateKey @"KTGSchedulerViewControllerNewDateKey"

@interface KTGSchedulerViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView* weekdayPageViewControllerContainer;
@property (nonatomic, strong) IBOutlet UIView* dayViewPageViewControllerContainer;
@property (nonatomic, strong) IBOutlet UILabel* currentDateLabel;
@property (nonatomic, strong) IBOutlet UIButton* todayButton;

@property (nonatomic, strong) NSDate* currentDate;

@property (nonatomic, strong) id<KTGCalendarDayViewDataSource> datasource;

-(void)reloadCurrentDay;

@end
