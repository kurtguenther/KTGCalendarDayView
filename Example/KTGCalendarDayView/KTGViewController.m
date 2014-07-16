//
//  KTGViewController.m
//  KTGCalendarDayView
//
//  Created by Kurt Guenther on 07/15/2014.
//  Copyright (c) 2014 Kurt Guenther. All rights reserved.
//

#import "KTGViewController.h"
#import <KTGCalendarDayView/KTGCalendarDayView.h>

@interface KTGViewController ()

@property (nonatomic, strong) KTGCalendarDayView* dayView;
@property (nonatomic, strong) NSDate* currentDate;

@end

@implementation KTGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentDate = [NSDate date];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"EEEE MMMM dd, YYYY";
    self.title = [df stringFromDate:self.currentDate];
    
    self.dayView = [[KTGCalendarDayView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.dayView];
}

@end
