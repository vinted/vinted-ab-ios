//
//  ABTestConfig.h
//  Vinted
//
//  Created by Sarunas Kazlauskas on 16/06/14.
//  Copyright (c) 2014 Vinted. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "VNTABTest.h"

@protocol VNTABTest @end;

@interface VNTABTestConfig : JSONModel

@property (nonatomic, strong) NSString<Ignore> *identifier;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, assign) NSInteger bucketCount;
@property (nonatomic, strong) NSArray<VNTABTest, Optional> *abTests;

- (NSArray *)assignedTestsForIdentifier:(NSString *)identifier;
- (VNTABTestVariant *)assignedVariantForTestName:(NSString *)testName identifier:(NSString *)identifier;

@end
