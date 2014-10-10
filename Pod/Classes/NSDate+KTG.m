//
//  NSDate+KTG.m
//  Pods
//
//  Created by Kurt Guenther on 7/16/14.
//
//

#import "NSDate+KTG.h"

@implementation NSDate (KTG)

- (BOOL) ktg_isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([self compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([self compare:endDate] == NSOrderedDescending || [self compare:endDate] == NSOrderedSame)
    	return NO;
    
    return YES;
}

- (BOOL)ktg_isSameDay:(NSDate *)otherDay {
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:self];
    NSDateComponents* other = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:otherDay];
    
    BOOL retVal = comps.day == other.day && comps.year == other.year && comps.month == other.month;
    return retVal;
}


@end
