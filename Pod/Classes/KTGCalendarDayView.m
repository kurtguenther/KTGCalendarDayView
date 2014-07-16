//
//  KTGCalendarDayView.m
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import "KTGCalendarDayView.h"
#import "KTGHourMarkerView.h"
#import "KTGCalendarEventView.h"

@implementation KTGCalendarDayView

#define HOUR_MARKER_HEADER 10.f
#define HOUR_VIEW_MARGIN 1.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];

        [self addObserver:self forKeyPath:@"hourHeight" options:NSKeyValueObservingOptionNew context:nil];
        
        self.hourHeight = 44.f;
        
        [self addSubview:self.scrollView];
        
        self.hourMarkers = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 24.0 * self.hourHeight)];
        [self.scrollView addSubview:self.hourMarkers];
        
        self.eventsContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 24.0 * self.hourHeight)];
        [self.scrollView addSubview:self.eventsContainer];
        
        NSDateFormatter* hourFormatter = [[NSDateFormatter alloc] init];
        hourFormatter.dateFormat = @"hh";
        
        //TODO: make this use NSLocale for times (So Noon is local, and support of 24 hour)
        for(int i = 0; i < 24; i++){
            NSString* hourTitle;
            if(i == 0) {
                hourTitle = @"12";
            } else if(i == 12) {
                hourTitle = @"Noon";
            } else {
                hourTitle = [NSString stringWithFormat:@"%d", i%12];
            }
            
            KTGHourMarkerView* hourMarkerView = [[KTGHourMarkerView alloc] initWithFrame:CGRectMake(0, i * (self.hourHeight + 2 * HOUR_VIEW_MARGIN), 320, self.hourHeight + 2 * HOUR_VIEW_MARGIN) title:hourTitle];
            [self.hourMarkers addSubview:hourMarkerView];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"hourHeight"]) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 24.0 * self.hourHeight);
    }
}

- (void)reloadData{
    for(id<KTGCalendarEvent> event in [self.dataSource events]){
        CGFloat startHeight = [self convertStartTimeToHeight:event.startTime];
        CGFloat endHeight = [self convertEndTimeToHeight:event.endTime];
        CGFloat calculatedLeft = 40.f + 1.f;
        KTGCalendarEventView* eventView = [[KTGCalendarEventView alloc] initWithFrame:CGRectMake(calculatedLeft, startHeight, CGRectGetWidth(self.bounds) - calculatedLeft - 1.f, endHeight - startHeight)];
        eventView.event = event;
        eventView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.8 alpha:0.4];
        [self.eventsContainer addSubview:eventView];
    }
}

- (CGFloat) convertStartTimeToHeight:(NSDate*) time {
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:time];
    return (self.hourHeight) * (comps.hour + comps.minute / 60.f) + HOUR_VIEW_MARGIN * (comps.hour * 2 + 1) + HOUR_MARKER_HEADER;
}

- (CGFloat) convertEndTimeToHeight:(NSDate*) time {
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:time];
    return (self.hourHeight) * (comps.hour + comps.minute / 60.f) + HOUR_VIEW_MARGIN * (comps.hour * 2 - 1) + HOUR_MARKER_HEADER;
}

@end

