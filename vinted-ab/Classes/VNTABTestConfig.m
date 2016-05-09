//
//  ABTestConfig.m
//  Vinted
//
//  Created by Sarunas Kazlauskas on 16/06/14.
//  Copyright (c) 2014 Vinted. All rights reserved.
//

#import "VNTABTestConfig.h"
#import "VNTABTest.h"
#import "VNTABTestVariant.h"
#import <CommonCrypto/CommonDigest.h>
#import <JKBigInteger/JKBigInteger.h>

@implementation VNTABTestConfig

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"salt": @"salt",
                                                       @"bucket_count": @"bucketCount",
                                                       @"ab_tests": @"abTests",
                                                       }];
}

- (NSInteger)bucketIdForIdentifier:(NSString *)identifier
{
    NSString *digestedString = [self hexDigestedString:[self.salt stringByAppendingString:identifier]];
    JKBigInteger *bigInteger = [[JKBigInteger alloc] initWithString:digestedString andRadix:16];
    JKBigInteger *bucketCount = [[JKBigInteger alloc] initWithUnsignedLong:self.bucketCount];
    JKBigInteger *remainder = [bigInteger remainder:bucketCount];
    return [remainder unsignedIntValue];
}

- (NSInteger)weightIdForTest:(VNTABTest *)test identifier:(NSString *)identifier
{
    NSString *digestedString = [self hexDigestedString:[test.seed stringByAppendingString:identifier]];
    NSInteger variantWeightSum = [self variantWeightSumOfTest:test];
    JKBigInteger *bigInteger = [[JKBigInteger alloc] initWithString:digestedString andRadix:16];
    JKBigInteger *variantWeightSumBigInteger = [[JKBigInteger alloc] initWithUnsignedLong:(variantWeightSum > 0 ? variantWeightSum : 1)];
    JKBigInteger *remainder = [bigInteger remainder:variantWeightSumBigInteger];
    return [remainder unsignedIntValue];
}

- (NSArray *)assignedTestsForIdentifier:(NSString *)identifier
{
    NSInteger bucketId = [self bucketIdForIdentifier:identifier];
    NSMutableArray *assignedTests = [NSMutableArray array];
    for (VNTABTest *test in self.abTests) {
        if (test.allBuckets || (test.buckets && [test.buckets containsObject:@(bucketId)])) {
            if ([test isRunning]) {
                [assignedTests addObject:test];
            }
        }
    }
    return assignedTests;
}

- (BOOL)testInBucket:(VNTABTest *)test identifier:(NSString *)identifier
{
    NSInteger bucketId = [self bucketIdForIdentifier:identifier];
    return (test.allBuckets || (test.buckets && [test.buckets containsObject:@(bucketId)]));
}

- (VNTABTestVariant *)assignedVariantForTest:(VNTABTest *)test identifier:(NSString *)identifier
{
    if (![test isRunning] || ![self testInBucket:test identifier:identifier]) {
        return nil;
    }
    NSInteger weightId = [self weightIdForTest:test identifier:identifier];
    NSInteger sum = 0;
    for (VNTABTestVariant *variant in test.variants) {
        sum += variant.chanceWeight;
        if (sum > weightId) {
            return variant;
        }
    }
    return nil;
}

- (VNTABTestVariant *)assignedVariantForTestName:(NSString *)testName identifier:(NSString *)identifier
{
    VNTABTest *test = [self testForName:testName];
    return test ? [self assignedVariantForTest:test identifier:identifier] : nil;
}

- (NSString *)hexDigestedString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    const char* str = [string UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);

    NSMutableString *digestedString = [NSMutableString new];
    for (NSInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [digestedString appendFormat:@"%02x", result[i]];
    }
    return [NSString stringWithString:digestedString];
}

- (NSInteger)variantWeightSumOfTest:(VNTABTest *)test
{
    NSInteger weightSum = 0;
    for (VNTABTestVariant *variant in test.variants) {
        weightSum += variant.chanceWeight;
    }
    return weightSum;
}

- (VNTABTest *)testForName:(NSString *)name
{
    for (VNTABTest *test in self.abTests) {
        if ([test.name isEqualToString:name]) {
            return test;
        }
    }
    return nil;
}

@end
