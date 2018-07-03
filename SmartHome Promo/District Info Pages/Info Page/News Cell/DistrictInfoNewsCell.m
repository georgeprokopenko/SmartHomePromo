//
//  DistrictInfoNewsCell.m
//  DomophoneApp
//
//  Created by George Prokopenko on 25.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "DistrictInfoNewsCell.h"

@interface DistrictInfoNewsCell()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation DistrictInfoNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainView.layer.cornerRadius = 9.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) setBottomLabelText:(NSString*)text {
    self.bottomLabel.text = text;
}

@end
