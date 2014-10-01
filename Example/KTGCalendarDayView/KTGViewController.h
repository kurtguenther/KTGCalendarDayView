//
//  KTGViewController.h
//  KTGCalendarDayView
//
//  Created by Kurt Guenther on 07/15/2014.
//  Copyright (c) 2014 Kurt Guenther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KTGCalendarDayView/KTGSchedulerViewController.h>
#import <KTGCalendarDayView/KTGCalendarDayView.h>

@interface KTGViewController : KTGSchedulerViewController <KTGCalendarDayViewDataSource>

-(void)fetchLocalEvents;

@end
