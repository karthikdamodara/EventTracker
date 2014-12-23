//
//  Event.m
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import "Event.h"
#import "Constants.h"


@implementation Event

@dynamic  address;
@dynamic  date;
@dynamic  eventID;
@dynamic  name;
@dynamic  type;
@dynamic thumbnail;
@dynamic mainImage;


- (NSDictionary *)toDictionary {
    return @{
             kname: self.name,
             kaddress: self.address,
             kdate:self.date,
             ktype:self.type,
             keventID:self.eventID,
             kthumbnail:self.thumbnail,
             kmainImage:self.mainImage
             };
}



@end
