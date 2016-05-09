//
//  ABTestVariant.h
//  Vinted
//
//  Created by Sarunas Kazlauskas on 16/06/14.
//  Copyright (c) 2014 Vinted. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VNTABTestVariant : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger chanceWeight;

@end
