//
//  KTGViewController.m
//  KTGCalendarDayView
//
//  Created by Kurt Guenther on 07/15/2014.
//  Copyright (c) 2014 Kurt Guenther. All rights reserved.
//

#import "KTGViewController.h"
#import "KTGExampleEvent.h"
#import <EventKit/EventKit.h>

@interface KTGViewController ()

@property (nonatomic, strong) KTGCalendarDayView* dayView;
@property (nonatomic, strong) NSDate* currentDate;

@property (nonatomic, strong) NSArray* exampleEvents;


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
    
    NSMutableArray* retVal = [NSMutableArray array];
    
    NSDate* today = [NSDate date];
    for (int i = 0; i < 10; i++){
        KTGExampleEvent* event = [[KTGExampleEvent alloc] init];
        event.eventName = [NSString stringWithFormat:@"Event #%d", i];
        
        NSDateComponents* comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
        comps.hour = 0;
        comps.minute = i % 2 == 0 ? i * 60 : (i-1) * 60 + 30;
        event.start = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        if(i % 2 == 1){
            event.location = [NSString stringWithFormat:@"Location %d", i];
        }
        
        comps.minute = i % 2 == 0 ? (i + 1) * 60 : (i-1) * 60 + 60 ;
        
        event.end = [[NSCalendar currentCalendar] dateFromComponents:comps];
        [retVal addObject:event];
        
    }
    
    self.exampleEvents = retVal;
    
    self.dayView.delegate = self;
    self.dayView.dataSource = self;
    
    [[EKEventStore alloc] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(!granted){
            //WHAT DID YOU THINK WOULD HAPPEN?
        } else {
            [self fetchLocalEvents];
        }
    }];
}

- (void)fetchLocalEvents {
    EKEventStore* store = [[EKEventStore alloc] init];
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    comps.hour = 0;
    comps.minute = 0;
    
    NSDate* begin = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    comps.hour = 11;
    comps.minute = 59;
    
    NSDate* end = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSArray* calendarEvents = [store eventsMatchingPredicate:[store predicateForEventsWithStartDate:begin endDate:end calendars:nil]];
    
    NSMutableArray* retVal = [NSMutableArray array];
    
    for(EKEvent* ev in calendarEvents){
        KTGExampleEvent* event = [[KTGExampleEvent alloc] init];
        event.eventName = ev.title;
        event.location = ev.location;
        event.start = ev.startDate;
        event.end = ev.endDate;
        [retVal addObject:event];
    }
    self.exampleEvents = retVal;
    
    //Must be called on the main thread
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dayView reloadData];
    });
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KTGCalendarDayViewDataSource
///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)events {
    return self.exampleEvents;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KTGCalendarDayViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)calendarDayView:(KTGCalendarDayView *)calendarDayView eventViewForEvent:(id<KTGCalendarEvent>)event{
    return nil;
}

@end
