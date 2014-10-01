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
#import "KTGCalendarNewEventView.h"
#import "Masonry.h"

@interface KTGCalendarDayView ()

@property (nonatomic, strong) NSMutableDictionary* viewEventDictionary;

@property (nonatomic, strong) UIView* createdEventView;
@property (nonatomic) CGPoint newEventAnchorPoint;
@end

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
        [self addSubview:self.scrollView];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addObserver:self forKeyPath:@"hourHeight" options:NSKeyValueObservingOptionNew context:nil];
        
        self.hourHeight = 47.5f;
        
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
                hourTitle = @"12 AM";
            } else if(i == 12) {
                hourTitle = @"Noon";
            } else if(i < 12){
                hourTitle = [NSString stringWithFormat:@"%d AM", i%12];
            } else {
                hourTitle = [NSString stringWithFormat:@"%d PM", i%12];
            }
            
            KTGHourMarkerView* hourMarkerView = [[KTGHourMarkerView alloc] initWithFrame:CGRectMake(0, i * (self.hourHeight + 2 * HOUR_VIEW_MARGIN), CGRectGetWidth(self.bounds), self.hourHeight + 2 * HOUR_VIEW_MARGIN) title:hourTitle];
            [self.hourMarkers addSubview:hourMarkerView];
        }
        
        UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"hourHeight"]) {
        //HACK - this should be 24, why is it 26?
        //self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 26.0 * self.hourHeight);
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 26.0 * self.hourHeight);
        ;
    }
}

- (void)setDataSource:(id<KTGCalendarDayViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (KTGEventConflict) calculateConflictBetweenEvent:(id<KTGCalendarEvent>)event1 and:(id<KTGCalendarEvent>)event2 {
    if([event1.startTime ktg_isBetweenDate:event2.startTime andDate:event2.endTime] ||
       [event1.endTime ktg_isBetweenDate:event2.startTime andDate:event2.endTime]) {
        if([event1.startTime timeIntervalSinceDate:event2.startTime] < 30 * 60) {
            return KTGEventConflictLarge;
        } else {
            return KTGEventConflictSmall;
        }
    }
    return KTGEventConflictNone;
}


- (void)reloadData {
    //Remove all the old events
    for(UIView* oldEventView in self.eventsContainer.subviews){
        [oldEventView removeFromSuperview];
    }
    
    self.viewEventDictionary = [NSMutableDictionary dictionary];
    
    NSArray* events = [self.dataSource eventsForDayView:self];
    events = [events sortedArrayUsingComparator:^NSComparisonResult(id<KTGCalendarEvent> obj1, id<KTGCalendarEvent> obj2) {
        return [obj1.startTime compare: obj2.startTime];
    }];
    
    NSMutableArray* rects = [NSMutableArray arrayWithCapacity:events.count];
    for(int i = 0; i < events.count; i++){
        id<KTGCalendarEvent> event = events[i];
        
        CGFloat startHeight = [self convertStartTimeToHeight:event.startTime];
        CGFloat endHeight = [self convertEndTimeToHeight:event.endTime];
        
        CGFloat calculatedLeft = 50.f + 1.f;
        CGFloat calculatedWidth = CGRectGetWidth(self.bounds) - calculatedLeft - 1.f;
        
        //TODO really need to bulletproof this.
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
        
        self.viewEventDictionary[[NSValue valueWithNonretainedObject:eventView]] = event;
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

- (void)scrollToTime:(NSDate *)time position:(UITableViewScrollPosition)position animated:(BOOL)animated {
    CGFloat timePosition = [self convertStartTimeToHeight:time];
    CGRect frame = CGRectMake(0, timePosition, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    switch(position) {
        case UITableViewScrollPositionNone:
        case UITableViewScrollPositionTop:
            //Do nothing since we assume top
            break;
        case UITableViewScrollPositionBottom:
            frame.size.height = 1.f; //0 causes the scroll view not to scroll.
            break;
        case UITableViewScrollPositionMiddle:
            frame.size.height = CGRectGetHeight(self.scrollView.bounds) / 2.f;
            break;
    }
    [self.scrollView scrollRectToVisible:frame animated:animated];
}

- (void)scrollToEvent:(id<KTGCalendarEvent>)event position:(UITableViewScrollPosition)position animated:(BOOL)animated{
    [self scrollToTime:event.startTime position:position animated:animated];
}

- (UIView*)newEventViewAtPoint:(CGPoint)point {
    CGFloat height = self.hourHeight;
    CGFloat left = 41.f;
    CGFloat top = point.y - height / 2;
    CGFloat width = 320.f - left;
    
    UIView* retVal = [[KTGCalendarNewEventView alloc] initWithFrame:CGRectMake(left, top, width, height)];
    return retVal;
}

- (void) scrollToLogicalPoint {
    NSArray* events = [self.dataSource eventsForDayView:self];
    NSArray* sorted = [events sortedArrayUsingComparator:^NSComparisonResult(id<KTGCalendarEvent> obj1, id<KTGCalendarEvent> obj2) {
        return [obj1.startTime compare:obj2.startTime];
    }];
    
    if(sorted.count > 0){
        id<KTGCalendarEvent> first = [sorted firstObject];
        CGFloat firstOffset = [self convertStartTimeToHeight:first.startTime];
        if(self.scrollView.contentOffset.y < firstOffset){
            [self scrollToEvent:[sorted firstObject] position:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}


- (void)longPress:(UILongPressGestureRecognizer*)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"Long Press Start");
        CGPoint location = [recognizer locationInView:self];
        self.newEventAnchorPoint = location;
        
        UIView* matchedView = nil;
        for(UIView* eventView in self.eventsContainer.subviews){
            if([eventView pointInside:[eventView convertPoint:location fromView:self] withEvent:nil]){
                matchedView = eventView;
            }
        }
        
        if(matchedView == nil){
            NSLog(@"Creating a new event");
            //TODO turn on and off allowing new events
            self.createdEventView = [self newEventViewAtPoint:location];
            [self addSubview:self.createdEventView];
        } else {
            id<KTGCalendarEvent> event = self.viewEventDictionary[[NSValue valueWithNonretainedObject:matchedView]];
            NSLog(@"Editing event %@", event);
        }
        return;
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"Long Press End");
        
        //inform delegate that a new event has been placed
        if([self.delegate respondsToSelector:@selector(newEventPlacedAtStartTime:endTime:)]){
            NSDate* startTime = [NSDate date]; //TODO make this dynamic based on touch
            NSDate* endTime = [NSDate dateWithTimeInterval:60*60 sinceDate:startTime]; //TODO make this configurable via delegate
            [self.delegate newEventPlacedAtStartTime:startTime endTime:endTime];
        }
        
        [self.createdEventView removeFromSuperview];
        self.createdEventView = nil;
        self.newEventAnchorPoint = CGPointZero; //probably should make something better
        
        return;
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        //Move the event along with the touch
        //update the hour markers to show / extra minute markers
    }

}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"hourHeight"];
}

@end

