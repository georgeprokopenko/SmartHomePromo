//
//  SettingsTextFieldCell.m
//  DomophoneApp
//
//  Created by George Prokopenko on 14.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "SettingsTextFieldCell.h"
#import "AccountManager.h"

@interface SettingsTextFieldCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation SettingsTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCell];
}

- (void) setupCell {
    self.textField.layer.cornerRadius = self.textField.bounds.size.height/2;
    self.textField.layer.sublayerTransform = CATransform3DMakeTranslation(12.0, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) setupCellWithType:(SettingsTextFieldCellType)type {
    if (type == SettingsTextFieldCellTypeAccount) {
        self.title.text = @"Лицевой счет";
        self.textField.secureTextEntry = NO;
        self.textField.text = [AccountManager shared].userAccount.accountNumber;
        self.textField.enabled = NO;
    }
    if (type == SettingsTextFieldCellTypePassword) {
        self.title.text = @"Пароль";
        self.textField.secureTextEntry = YES;
        self.textField.placeholder = @"Введите пароль";
    }
    if (type == SettingsTextFieldCellTypeNewPassword) {
        self.title.text = @"Новый пароль";
        self.textField.secureTextEntry = YES;
        self.textField.placeholder = @"Введите новый пароль";
    }
}


@end
