//
//  SettingsViewController.m
//  DomophoneApp
//
//  Created by George Prokopenko on 14.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTextFieldCell.h"
#import "SettingsButtonCell.h"
#import "AccountManager.h"
#import "Mapper.h"
#import "Constants.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UISwitch *disturbSlider;
@property (weak, nonatomic) IBOutlet UILabel *disturbLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;
@property (weak, nonatomic) IBOutlet UIButton *trafficButton;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation SettingsViewController {
    UITapGestureRecognizer* dismissTapGR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void) viewWillAppear:(BOOL)animated {
    if ([AccountManager shared].userAccount.phone) {
        self.telephoneTextField.text = [AccountManager shared].userAccount.phone;
    }
}

- (void) setupViews {
    self.navigationItem.title = @"Настройки";
    self.telephoneTextField.layer.cornerRadius = 17.5;
    self.logoutButton.layer.cornerRadius = 17.5;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9, 16)];
    backButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

- (IBAction)disturbSliderChanged:(UISwitch*)sender {
    self.disturbLabel.text = sender.isOn? @"Включено" : @"Выключено";
}


- (IBAction) logoutButtonClicked {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Выйти из учетной записи?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Выйти" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [AccountManager logout];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) backAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMainTabBarSelectIndexOne object:nil];
}



@end
