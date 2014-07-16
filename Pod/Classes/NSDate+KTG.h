//
//  NSDate+KTG.h
//  Pods
//
//  Created by Kurt Guenther on 7/16/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (KTG)

- (BOOL) kg_isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
