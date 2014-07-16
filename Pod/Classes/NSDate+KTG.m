//
//  NSDate+KTG.m
//  Pods
//
//  Created by Kurt Guenther on 7/16/14.
//
//

#import "NSDate+KTG.h"

@implementation NSDate (KTG)

- (BOOL) kg_isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([self compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([self compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

@end
