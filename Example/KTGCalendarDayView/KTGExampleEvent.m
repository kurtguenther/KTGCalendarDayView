//
//  KTGExampleEvent.m
//  KTGCalendarDayView
//
//  Created by Kurt Guenther on 7/15/14.
//  Copyright (c) 2014 Kurt Guenther. All rights reserved.
//

#import "KTGExampleEvent.h"

@implementation KTGExampleEvent



- (NSString *)description {
    return self.eventName;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KTGCalendarEvent
///////////////////////////////////////////////////////////////////////////////////////////////////


-(NSString*)title {
    return self.eventName;
}

-(NSDate*)startTime {
    return self.start;
}
-(NSDate*)endTime {
    return self.end;
}

-(NSString*)subtitle {
    return self.location;
}



@end
