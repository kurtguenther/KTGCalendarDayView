//
//  KTGViewController.m
//  KTGCalendarDayView
//
//  Created by Kurt Guenther on 07/15/2014.
//  Copyright (c) 2014 Kurt Guenther. All rights reserved.
//

#import "KTGViewController.h"
#import "KTGExampleEvent.h"

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
    
    self.dayView.delegate = self;
    self.dayView.dataSource = self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KTGCalendarDayViewDataSource
///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)events {
    NSMutableArray* retVal = [NSMutableArray array];


    NSDate* today = [NSDate date];
    for (int i = 0; i < 10; i++){
        KTGExampleEvent* event = [[KTGExampleEvent alloc] init];
        event.eventName = [NSString stringWithFormat:@"Event #%d", i];

        NSDateComponents* comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
        comps.hour = 0;
        comps.minute = i * 60;
        event.start = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        comps.minute = (i + 1) * 60;
        
        event.end = [[NSCalendar currentCalendar] dateFromComponents:comps];
        [retVal addObject:event];
        
    }
    
    
    return retVal;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KTGCalendarDayViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)calendarDayView:(KTGCalendarDayView *)calendarDayView eventViewForEvent:(id<KTGCalendarEvent>)event{
    return nil;
}

@end
