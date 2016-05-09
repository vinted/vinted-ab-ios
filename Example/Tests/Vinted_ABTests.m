//
//  ABSystemTests.m
//  Vinted
//
//  Created by Sarunas Kazlauskas on 16/06/14.
//  Copyright (c) 2014 Vinted. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VNTABTestConfig.h"

@interface ABSystemTests : XCTestCase

@property (nonatomic, strong) VNTABTestConfig *testConfig;
@property (nonatomic, strong) NSArray *examples;

@end

@interface VNTABTestConfig (ABSystemTests)

- (VNTABTest *)testForName:(NSString *)name;

@end

@implementation ABSystemTests

- (void)setUp
{
    [super setUp];
    self.testConfig = nil;
    self.examples = @[@"examples/all_buckets",
                      @"examples/already_finished",
                      @"examples/big_weights",
                      @"examples/explicit_times",
                      @"examples/few_buckets",
                      @"examples/has_not_started",
                      @"examples/multiple_tests",
                      @"examples/multiple_variants",
                      @"examples/no_buckets",
                      @"examples/no_variants",
                      @"examples/zero_buckets",
                      @"examples/zero_weight",
                      @"examples/no_end_date"
                      ];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testConfigInitializationFromJSONString
{
    
    for (NSString *example in self.examples) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"input" ofType:@"json" inDirectory:example];
        NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        self.testConfig = [[VNTABTestConfig alloc] initWithString:jsonString error:nil];
        XCTAssertNotNil(self.testConfig, @"self.testConfig can't be nil. (input = %@)", example);
    }
}

- (void)testVariantAssignment
{
    for (NSString *example in self.examples) {
        NSString *outputPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"output.json"
                                                                                ofType:nil
                                                                           inDirectory:example];
        NSString *inputPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"input.json"
                                                                               ofType:nil
                                                                          inDirectory:example];
        NSString *jsonString = [NSString stringWithContentsOfFile:inputPath encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [NSData dataWithContentsOfFile:outputPath];
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
        NSString *testName = results[@"test"];
        NSDictionary *variants = results[@"variants"];
        for (NSString *variantName in [variants allKeys]) {
            for (NSNumber *identifier in variants[variantName]) {
                self.testConfig = [[VNTABTestConfig alloc] initWithString:jsonString error:nil];
                VNTABTestVariant *variant = [self.testConfig assignedVariantForTestName:testName
                                                                             identifier:identifier.stringValue];
                
                if ([variantName isEqualToString:@""]) {
                    XCTAssertNil(variant.name, @"variant.name should be nil in this case. (test.name = %@, identifier = %ld",
                                 testName, (long)identifier.integerValue);
                } else {
                    XCTAssertTrue([variantName isEqualToString:variant.name],
                                  @"self.testConfig should assign right test variant. (test.name = %@, identifier = %ld",
                                  testName, (long)identifier.integerValue);
                }
                
            }
        }
        
    }
}

@end
