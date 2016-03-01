//
//  MyMapAnnotation.h
//  SwiftDemo
//
//  Created by Jren on 15/12/21.
//  Copyright © 2015年 jr-wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>

@interface MyMapAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy  ) NSString               *title;
@property (nonatomic, copy  ) NSString               *subtitle;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
