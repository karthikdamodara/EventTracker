//
//  CustomCollectionViewCell.h
//  EventTracker
//
//  Copyright (c) 2014 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)IBOutlet UIImageView *img;
@property(nonatomic,strong)IBOutlet UILabel *eventName;

@end
