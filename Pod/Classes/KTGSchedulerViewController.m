//
//  KTGSchedulerViewController.m
//  Pods
//
//  Created by Kurt Guenther on 9/29/14.
//
//

#import "KTGSchedulerViewController.h"
#import "KTGWeekdayHeaderViewController.h"

@interface KTGSchedulerViewController ()

@property (nonatomic, strong) UIPageViewController* weekdayPageViewController;

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
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIPageViewControllerDatasource
///////////////////////////////////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(KTGWeekdayHeaderViewController *)viewController {
    NSDate* oldDay = viewController.startDay;
    NSDate* newDay = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:oldDay];
    KTGWeekdayHeaderViewController* header = [[KTGWeekdayHeaderViewController alloc] initWithStartDay:newDay];
    return header;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(KTGWeekdayHeaderViewController *)viewController {
    NSDate* oldDay = viewController.startDay;
    NSDate* newDay = [NSDate dateWithTimeInterval:+7*24*60*60 sinceDate:oldDay];
    KTGWeekdayHeaderViewController* header = [[KTGWeekdayHeaderViewController alloc] initWithStartDay:newDay];
    return header;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    KTGWeekdayHeaderViewController* currentWeek = pageViewController.viewControllers[0];
    KTGWeekdayHeaderViewController* nextWeek = pendingViewControllers[0];
    nextWeek.selectedIndex = currentWeek.selectedIndex;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIPageViewControllerDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIPageViewControllerDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    UIViewController *currentViewController = self.weekdayPageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.weekdayPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.weekdayPageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
    
}


@end
