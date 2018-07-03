//
//  SettingsButtonCell.m
//  DomophoneApp
//
//  Created by George Prokopenko on 14.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "SettingsButtonCell.h"

@interface SettingsButtonCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SettingsButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = self.button.bounds.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(id)sender {
    [self.delegate logoutButtonClicked];
}


@end
