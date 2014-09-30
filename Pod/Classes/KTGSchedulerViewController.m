//
//  KTGSchedulerViewController.m
//  Pods
//
//  Created by Kurt Guenther on 9/29/14.
//
//

#import "KTGSchedulerViewController.h"
#import "KTGWeekdayHeaderViewController.h"
#import "KTGCalendarDayViewController.h"

@interface KTGSchedulerViewController ()

@property (nonatomic, strong) UIPageViewController* weekdayPageViewController;
@property (nonatomic, strong) UIPageViewController* dayPageViewController;

@end

@implementation KTGSchedulerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weekdayPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{}];
    self.weekdayPageViewController.delegate = self;
    self.weekdayPageViewController.dataSource = self;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit| NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSInteger subDate = comps.weekday-1;
    NSDate* firstDayOfThisWeek = [NSDate dateWithTimeIntervalSinceNow:-subDate * 24 * 60 * 60];
    
    KTGWeekdayHeaderViewController* header = [[KTGWeekdayHeaderViewController alloc] initWithStartDay:firstDayOfThisWeek];
    [self.weekdayPageViewController setViewControllers:@[header] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.weekdayPageViewController];
    self.weekdayPageViewController.view.frame = self.weekdayPageViewControllerContainer.bounds;
    [self.weekdayPageViewControllerContainer addSubview:self.weekdayPageViewController.view];
    [self.weekdayPageViewController didMoveToParentViewController:self];
    

    
    self.dayPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{}];
    self.dayPageViewController.delegate = self;
    self.dayPageViewController.dataSource = self;
    

    KTGCalendarDayViewController* todayAgenda = [[KTGCalendarDayViewController alloc] initWithDate:[NSDate date]];
    [self.dayPageViewController setViewControllers:@[todayAgenda] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    todayAgenda.view.backgroundColor = [UIColor greenColor];

    
    [self addChildViewController:self.dayPageViewController];
    self.dayPageViewController.view.frame = self.dayViewPageViewControllerContainer.bounds;
    [self.dayViewPageViewControllerContainer addSubview:self.dayPageViewController.view];
    [self.dayPageViewController didMoveToParentViewController:self];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIPageViewControllerDatasource
///////////////////////////////////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if(pageViewController == self.weekdayPageViewController){
        
        NSDate* oldDay = ((KTGWeekdayHeaderViewController*)viewController).startDay;
        NSDate* newDay = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:oldDay];
        KTGWeekdayHeaderViewController* header = [[KTGWeekdayHeaderViewController alloc] initWithStartDay:newDay];
        return header;
    } else {
        NSDate* oldDay = ((KTGCalendarDayViewController*)viewController).date;
        NSDate* newDay = [NSDate dateWithTimeInterval:-1*24*60*60 sinceDate:oldDay];
        KTGCalendarDayViewController* header = [[KTGCalendarDayViewController alloc] initWithDate:newDay];
        header.view.backgroundColor = [UIColor blueColor];
        return header;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(KTGWeekdayHeaderViewController *)viewController {
    if(pageViewController == self.weekdayPageViewController){
        
        NSDate* oldDay = ((KTGWeekdayHeaderViewController*)viewController).startDay;
        NSDate* newDay = [NSDate dateWithTimeInterval:7*24*60*60 sinceDate:oldDay];
        KTGWeekdayHeaderViewController* header = [[KTGWeekdayHeaderViewController alloc] initWithStartDay:newDay];
        return header;
    } else {
        NSDate* oldDay = ((KTGCalendarDayViewController*)viewController).date;
        NSDate* newDay = [NSDate dateWithTimeInterval:1*24*60*60 sinceDate:oldDay];
        KTGCalendarDayViewController* header = [[KTGCalendarDayViewController alloc] initWithDate:newDay];
        header.view.backgroundColor = [UIColor whiteColor];
        return header;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    if(pageViewController == self.weekdayPageViewController){
        KTGWeekdayHeaderViewController* currentWeek = pageViewController.viewControllers[0];
        KTGWeekdayHeaderViewController* nextWeek = pendingViewControllers[0];
        nextWeek.selectedIndex = currentWeek.selectedIndex;
        
        NSDate* dateSelected = [NSDate dateWithTimeInterval:24*60*60*nextWeek.selectedIndex sinceDate:nextWeek.startDay];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"EEEE MMMM dd, YYYY";
        self.currentDateLabel.text = [df stringFromDate:dateSelected];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIPageViewControllerDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    UIViewController *currentViewController = pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.weekdayPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.weekdayPageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
    
}


@end
