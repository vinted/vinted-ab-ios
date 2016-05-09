//
//  ABTestVariant.m
//  Vinted
//
//  Created by Sarunas Kazlauskas on 16/06/14.
//  Copyright (c) 2014 Vinted. All rights reserved.
//

#import "VNTABTestVariant.h"

@implementation VNTABTestVariant

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"name" : @"name",
                                                       @"chance_weight" : @"chanceWeight",
                                                     }];
}

@end
