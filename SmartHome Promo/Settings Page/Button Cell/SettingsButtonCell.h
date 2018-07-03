//
//  SettingsButtonCell.h
//  DomophoneApp
//
//  Created by George Prokopenko on 14.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum : NSUInteger {
//    SettingsTextFieldCellTypeAccount,
//    SettingsTextFieldCellTypePassword,
//    SettingsTextFieldCellTypeNewPassword,
//} SettingsTextFieldCellType;

@protocol SettingsButtonCellDelegate <NSObject>
- (void) logoutButtonClicked;
@end

@interface SettingsButtonCell : UITableViewCell

@property (weak, nonatomic) id <SettingsButtonCellDelegate> delegate;

@end
