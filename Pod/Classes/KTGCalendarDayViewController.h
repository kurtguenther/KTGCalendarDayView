//
//  KTGCalendarDayViewController.h
//  Pods
//
//  Created by Kurt Guenther on 9/30/14.
//
//

#import <UIKit/UIKit.h>

@interface KTGCalendarDayViewController : UIViewController

@property (nonatomic, strong) NSDate* date;

- (instancetype)initWithDate:(NSDate*)date;

@end
