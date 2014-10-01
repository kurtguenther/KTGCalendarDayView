//
//  KTGCalendarDayView.h
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import <UIKit/UIKit.h>
#import "KTGCalendarEvent.h"

@class KTGCalendarDayView;

@protocol KTGCalendarDayViewDelegate <NSObject>
- (BOOL) allowNewEvent;
- (BOOL) allowModifyEvent:(id<KTGCalendarEvent>)event;
- (BOOL) newEventPlacedAtStartTime:(NSDate*)startTime endTime:(NSDate*)endTime;
@end

@protocol KTGCalendarDayViewDataSource <NSObject>
@required
- (NSArray *)eventsForDayView:(KTGCalendarDayView*) dayView;
//- (UIView*)calendarDayView:(KTGCalendarDayView*)calendarDayView eventViewForEvent:(id<KTGCalendarEvent>)event;
@end


@interface KTGCalendarDayView : UIView

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* hourMarkers;
@property (nonatomic, strong) UIView* eventsContainer;

@property (nonatomic) CGFloat hourHeight;

@property (nonatomic, strong) id<KTGCalendarDayViewDataSource> dataSource;
@property (nonatomic, strong) id<KTGCalendarDayViewDelegate> delegate;

@property (nonatomic, strong) NSDate* date;

-(void)reloadData;

-(void)scrollToTime:(NSDate*)time position:(UITableViewScrollPosition)position animated:(BOOL)animated;
-(void)scrollToEvent:(id<KTGCalendarEvent>)event position:(UITableViewScrollPosition)position animated:(BOOL)animated;

//TODO this should be more robust in logic
//And define this
-(void)scrollToLogicalPoint;

@end
