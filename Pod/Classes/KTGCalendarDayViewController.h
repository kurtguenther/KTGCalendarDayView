//
//  KTGCalendarDayViewController.h
//  Pods
//
//  Created by Kurt Guenther on 9/30/14.
//
//

#import <UIKit/UIKit.h>
#import "KTGCalendarDayView.h"

@interface KTGCalendarDayViewController : UIViewController

@property (nonatomic,strong) KTGCalendarDayView* dayView;
@property (nonatomic, strong) id<KTGCalendarDayViewDataSource> dataSource;
@property (nonatomic) CGPoint initOffset;

@property (nonatomic, strong) NSDate* date;

- (instancetype)initWithDate:(NSDate*)date;

@end
