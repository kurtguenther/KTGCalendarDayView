//
//  KTGCalendarEvent.h
//  Pods
//
//  Created by Kurt Guenther on 7/15/14.
//
//

#import <Foundation/Foundation.h>

@protocol KTGCalendarEvent <NSObject>

@required
-(NSString*)title;
-(NSDate*)startTime;
-(NSDate*)endTime;

@optional
-(NSString*)description;
-(UIColor*)color;

@end
