//
//  KTGSchedulerViewController.h
//  Pods
//
//  Created by Kurt Guenther on 9/29/14.
//
//

#import <UIKit/UIKit.h>

@interface KTGSchedulerViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView* weekdayPageViewControllerContainer;

@end
