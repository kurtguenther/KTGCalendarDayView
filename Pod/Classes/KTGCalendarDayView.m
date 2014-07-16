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
#import "NSDate+KTG.h"

@implementation KTGCalendarDayView

#define HOUR_MARKER_HEADER 10.f
#define HOUR_VIEW_MARGIN 2.0f

typedef NS_ENUM(NSInteger, KTGEventConflict) {
    KTGEventConflictNone,
    KTGEventConflictSmall,
    KTGEventConflictLarge
};


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];

        [self addObserver:self forKeyPath:@"hourHeight" options:NSKeyValueObservingOptionNew context:nil];
        
        self.hourHeight = 47.5f;
        
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
            
            KTGHourMarkerView* hourMarkerView = [[KTGHourMarkerView alloc] initWithFrame:CGRectMake(0, i * (self.hourHeight + 2 * HOUR_VIEW_MARGIN), CGRectGetWidth(self.bounds), self.hourHeight + 2 * HOUR_VIEW_MARGIN) title:hourTitle];
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

- (void)setDataSource:(id<KTGCalendarDayViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (KTGEventConflict) calculateConflictBetweenEvent:(id<KTGCalendarEvent>)event1 and:(id<KTGCalendarEvent>)event2 {
    if([event1.startTime kg_isBetweenDate:event2.startTime andDate:event2.endTime] ||
       [event1.endTime kg_isBetweenDate:event2.startTime andDate:event2.endTime]) {
        if([event1.startTime timeIntervalSinceDate:event2.startTime] < 30 * 60) {
            return KTGEventConflictLarge;
        } else {
            return KTGEventConflictSmall;
        }
    }
    return KTGEventConflictNone;
}


- (void)reloadData{
    for(UIView* oldEventView in self.eventsContainer.subviews){
        [oldEventView removeFromSuperview];
    }
    
    NSArray* events = [self.dataSource events];
    events = [events sortedArrayUsingComparator:^NSComparisonResult(id<KTGCalendarEvent> obj1, id<KTGCalendarEvent> obj2) {
        return [obj1.startTime compare: obj2.startTime];
    }];
    
    NSMutableArray* rects = [NSMutableArray arrayWithCapacity:events.count];
    for(int i = 0; i < events.count; i++){
        id<KTGCalendarEvent> event = events[i];
        
        CGFloat startHeight = [self convertStartTimeToHeight:event.startTime];
        CGFloat endHeight = [self convertEndTimeToHeight:event.endTime];
        
        CGFloat calculatedLeft = 40.f + 1.f;
        CGFloat calculatedWidth = CGRectGetWidth(self.bounds) - calculatedLeft - 1.f;
        
        for(int j = 0; j < i; j++){
            KTGEventConflict conflict = [self calculateConflictBetweenEvent:event and:events[j]];
            if(conflict == KTGEventConflictSmall){
                NSLog(@"Small conflict between %@ and %@", event, events[j]);
                //scootch the new one, leave the old untouched
                calculatedLeft = calculatedLeft + 4.f;
            } else if(conflict == KTGEventConflictLarge){
                NSLog(@"Large conflict between %@ and %@", event, events[j]);
                //Split up the time
                calculatedLeft = calculatedLeft + calculatedWidth / 2;
                calculatedWidth = calculatedWidth / 2;
                
                CGRect orig = [rects[j] CGRectValue];
                orig.size.width = calculatedLeft - 2.f - orig.origin.x;
                rects[j] = [NSValue valueWithCGRect:orig];
            } else {
                //NOOP
            }
        }
        
        CGRect calculatedRect = CGRectMake(calculatedLeft, startHeight, calculatedWidth, endHeight - startHeight);
        [rects addObject:[NSValue valueWithCGRect:calculatedRect]];
    }
    
    for(int i = 0; i < events.count; i++){
        CGRect frame = [rects[i] CGRectValue];
        id<KTGCalendarEvent> event = events[i];
        
        KTGCalendarEventView* eventView = [[KTGCalendarEventView alloc] initWithFrame:frame];
        eventView.event = event;
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

