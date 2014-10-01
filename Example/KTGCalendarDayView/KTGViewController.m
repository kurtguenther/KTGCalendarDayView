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
#import <KTGCalendarDayView/NSDate+KTG.h>

@interface KTGViewController ()

@property (nonatomic, strong) NSArray* exampleEvents;


@end

@implementation KTGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray* retVal = [NSMutableArray array];
    
    self.exampleEvents = retVal;
    
//    self.dayView.delegate = self;
//    self.dayView.dataSource = self;
    
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
    const double secondsInAYear = (60.0*60.0*24.0)*365.0;
    NSPredicate* predicate = [store predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-secondsInAYear] endDate:[NSDate dateWithTimeIntervalSinceNow:secondsInAYear] calendars:nil];
  
    NSArray* calendarEvents = [store eventsMatchingPredicate:predicate];
    
    
    if(calendarEvents.count == 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"No events found" message:@"Add some events in Calendar.app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
        return;
    }
    
    
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
        self.currentDate = nil;
        self.currentDate = [NSDate date];
//        [self.dayView reloadData];
//        [self.dayView scrollToEvent:[self.exampleEvents firstObject] position:UITableViewScrollPositionMiddle animated:YES];
    });

}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KTGCalendarDayViewDataSource
///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)eventsForDayView:(KTGCalendarDayView*) dayView {
    NSArray* retVal = [self.exampleEvents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        id<KTGCalendarEvent> ev = evaluatedObject;
        return [ev.startTime ktg_isSameDay:dayView.date] || [ev.endTime ktg_isSameDay:dayView.date];
    }]];
    NSLog(@"Returning %d dates for %@", retVal.count, dayView.date);
    return retVal;
}

- (id<KTGCalendarDayViewDataSource>)datasource {
    return self;
}

@end
