//
//  MyMapAnnotation.m
//  SwiftDemo
//
//  Created by Jren on 15/12/21.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

#import "MyMapAnnotation.h"

@implementation MyMapAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        _coordinate = coordinate;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
{
    _coordinate = newCoordinate;
}

@end
