//
//  ABTest.h
//  Vinted
//
//  Created by Sarunas Kazlauskas on 16/06/14.
//  Copyright (c) 2014 Vinted. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "VNTABTestVariant.h"

@protocol VNTABTestVariant @end;

@interface VNTABTest : JSONModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate<Optional> *startAt;
@property (nonatomic, strong) NSDate<Optional> *endAt;
@property (nonatomic, strong) NSString *seed;
@property (nonatomic, strong) NSArray<Optional> *buckets;
@property (nonatomic, assign) BOOL allBuckets;
@property (nonatomic, strong) NSArray<VNTABTestVariant> *variants;

- (BOOL)isRunning;

@end
