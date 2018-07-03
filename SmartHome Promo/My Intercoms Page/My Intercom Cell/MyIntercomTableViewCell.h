//
//  MyIntercomTableViewCell.h
//  DomophoneApp
//
//  Created by George Prokopenko on 12.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntercomObject.h"
#import "Constants.h"

@protocol MyIntercomTableViewCellDelegate <NSObject>
- (BOOL) canEditFavoritesWithCoeff:(int)coeff;
- (void) cellWillBeSwipedLeft:(id)cell;
@end

@interface MyIntercomTableViewCell : UITableViewCell

@property (assign, nonatomic) id <MyIntercomTableViewCellDelegate> delegate;
- (void) customize:(IntercomObject*)intercom;
- (void) setCellWillMove:(BOOL)moving;
- (void) swipeCellRight;

@end
