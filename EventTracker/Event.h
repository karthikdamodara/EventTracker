//
//  Event.h
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, assign) NSNumber * eventID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * thumbnail;
@property (nonatomic, strong) NSString * mainImage;

- (NSDictionary *)toDictionary;

@end
