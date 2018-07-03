//
//  DistrictManagementButtonCell.m
//  DomophoneApp
//
//  Created by George Prokopenko on 25.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "DistrictManagementButtonCell.h"

@interface DistrictManagementButtonCell()
@property (weak, nonatomic) IBOutlet UIButton* button;
@end

@implementation DistrictManagementButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = self.button.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void) setButtonText:(NSString*)text {
    [self.button setTitle:text forState:UIControlStateNormal];
}

@end
