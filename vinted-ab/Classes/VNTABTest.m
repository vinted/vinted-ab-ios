//
//  ABTest.m
//  Vinted
//
//  Created by Sarunas Kazlauskas on 16/06/14.
//  Copyright (c) 2014 Vinted. All rights reserved.
//

#import "VNTABTest.h"
#import "VNTABTestVariant.h"

@implementation VNTABTest

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identifier",
                                                       @"name": @"name",
                                                       @"start_at": @"startAt",
                                                       @"end_at": @"endAt",
                                                       @"seed": @"seed",
                                                       @"buckets": @"buckets",
                                                       @"all_buckets": @"allBuckets",
                                                       @"variants": @"variants",
                                                       }];
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(allBuckets))]) {
        return YES;
    }
    return NO;
}

#pragma mark - Public instance methods

- (BOOL)isRunning
{
    if (!self.startAt && !self.endAt) {
        return YES;
    }
    
    NSDate *date = [NSDate date];
    BOOL afterStartDate = [date compare:self.startAt] == NSOrderedDescending;
    BOOL beforeEndDate = (self.endAt == nil || [date compare:self.endAt] == NSOrderedAscending);
    
    return afterStartDate && beforeEndDate;
}

@end
