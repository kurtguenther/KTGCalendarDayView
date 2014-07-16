//
//  KTGExampleEvent.h
//  KTGCalendarDayView
//
//  Created by Kurt Guenther on 7/15/14.
//  Copyright (c) 2014 Kurt Guenther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KTGCalendarDayView/KTGCalendarEvent.h>

@interface KTGExampleEvent : NSObject <KTGCalendarEvent>

@property (nonatomic, strong) NSDate* start;
@property (nonatomic, strong) NSDate* end;
@property (nonatomic, strong) NSString* eventName;

@end
