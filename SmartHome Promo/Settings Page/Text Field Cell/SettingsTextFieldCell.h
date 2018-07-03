//
//  SettingsTextFieldCell.h
//  DomophoneApp
//
//  Created by George Prokopenko on 14.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SettingsTextFieldCellTypeAccount,
    SettingsTextFieldCellTypePassword,
    SettingsTextFieldCellTypeNewPassword,
} SettingsTextFieldCellType;

@interface SettingsTextFieldCell : UITableViewCell

- (void) setupCellWithType:(SettingsTextFieldCellType)type;

@end
