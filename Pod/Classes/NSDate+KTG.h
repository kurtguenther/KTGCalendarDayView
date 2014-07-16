//
//  NSDate+KTG.h
//  Pods
//
//  Created by Kurt Guenther on 7/16/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (KTG)

/**
 *  Returns YES if the date falls between (not inclusive) the two specified dates
 *  Lifted directly from http://stackoverflow.com/questions/1072848/how-to-check-if-an-nsdate-occurs-between-two-other-nsdates
 */
- (BOOL) ktg_isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
