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
#import "NSDate+KTG.h"

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

    
    [self addChildViewController:self.dayPageViewController];
    self.dayPageViewController.view.frame = self.dayViewPageViewControllerContainer.bounds;
    [self.dayViewPageViewControllerContainer addSubview:self.dayPageViewController.view];
    [self.dayPageViewController didMoveToParentViewController:self];
    
    [self.todayButton addTarget:self action:@selector(todayClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateUpdate:) name:KTGSchedulerViewControllerDateChanged object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KTGSchedulerViewControllerDateChanged object:nil userInfo:@{KTGSchedulerViewControllerNewDateKey : [NSDate date]}];
    
}

- (void) dateUpdate:(NSNotification*)notification {
    if(notification.object != self){
        NSDate* newDate = notification.userInfo[KTGSchedulerViewControllerNewDateKey];
        
        if([newDate ktg_isSameDay:self.currentDate]) {
            return;
        }
        
        self.currentDate = newDate;
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"EEEE  MMMM dd, YYYY";

        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.type = kCATransitionFade;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.currentDateLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
        
        // Change the text
        self.currentDateLabel.text = [df stringFromDate:self.currentDate];
        
        NSLog(@"Updated master date from source:%@", notification.object);
        
        //TODO update the pagers
        if(notification.object != self.weekdayPageViewController && ![notification.object isKindOfClass:[KTGWeekdayHeaderViewController class]]){
            //update the weekday pager
            //update the pager
            KTGWeekdayHeaderViewController* currentWeekDay = self.weekdayPageViewController.viewControllers[0];
            if([self.currentDate earlierDate:currentWeekDay.startDay] == self.currentDate){
                KTGWeekdayHeaderViewController* newWeekVC = (KTGWeekdayHeaderViewController*) [self pageViewController:self.weekdayPageViewController viewControllerBeforeViewController:currentWeekDay];
                [self.weekdayPageViewController setViewControllers:@[newWeekVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                newWeekVC.selectedIndex = 6;
            } else if([self.currentDate laterDate:[NSDate dateWithTimeInterval:7*24*60*60 sinceDate:currentWeekDay.startDay]] == self.currentDate){
                KTGWeekdayHeaderViewController* newWeekVC = (KTGWeekdayHeaderViewController*)[self pageViewController:self.weekdayPageViewController viewControllerAfterViewController:currentWeekDay];
                [self.weekdayPageViewController setViewControllers:@[newWeekVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
                newWeekVC.selectedIndex = 0;
            } else {
                
            }
        }
        
        if(notification.object != self.dayPageViewController){
            //update the pager
            KTGCalendarDayViewController* currentDayVC = self.dayPageViewController.viewControllers[0];
            //Check for initial condition
            if(![currentDayVC.date ktg_isSameDay:self.currentDate]){
                UIPageViewControllerNavigationDirection direction = [currentDayVC.date earlierDate:self.currentDate] == currentDayVC.date ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
                
                KTGCalendarDayViewController* newDayVC = [[KTGCalendarDayViewController alloc] initWithDate:self.currentDate];
                [self.dayPageViewController setViewControllers:@[newDayVC] direction:direction animated:YES completion:nil];
            }
        }
    }
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(completed){
        if(pageViewController == self.weekdayPageViewController){
            KTGWeekdayHeaderViewController* currentWeek = pageViewController.viewControllers[0];
            KTGWeekdayHeaderViewController* prevWeek = previousViewControllers[0];
            
            NSDate* dateSelected = [NSDate dateWithTimeInterval:24*60*60*prevWeek.selectedIndex sinceDate:currentWeek.startDay];
            [[NSNotificationCenter defaultCenter] postNotificationName:KTGSchedulerViewControllerDateChanged object:self.weekdayPageViewController userInfo:@{KTGSchedulerViewControllerNewDateKey : dateSelected}];
        } else {
            KTGCalendarDayViewController* currentDay = pageViewController.viewControllers[0];
            
            NSDate* dateSelected = currentDay.date;
            [[NSNotificationCenter defaultCenter] postNotificationName:KTGSchedulerViewControllerDateChanged object:self.dayPageViewController userInfo:@{KTGSchedulerViewControllerNewDateKey : dateSelected}];
        }
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Today
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)todayClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:KTGSchedulerViewControllerDateChanged object:self userInfo:@{KTGSchedulerViewControllerNewDateKey : [NSDate date]}];
}


@end
