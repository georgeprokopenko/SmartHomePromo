//
//  CustomAlertView.m
//  linphone
//
//  Created by Prokopenko Georgy on 13/06/2018.
//

#import "CustomAlertView.h"
#import "Mapper.h"
#import "Constants.h"

@interface CustomAlertView ()

@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UILabel *dialogLabel;
@property (weak, nonatomic) IBOutlet UIButton *dialogButton;

@end

@implementation CustomAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.alpha = 0;
    self.view.hidden = YES;
    self.dialogView.alpha = 0;
    self.dialogView.hidden = YES;
    self.dialogView.layer.cornerRadius = 6.0;
    self.dialogView.transform = CGAffineTransformMakeScale(0.7, 0.7);
}

- (void) setupWithType:(CustomAlertViewType)type {
    if (type == kCustomAlertTypeExcessiveFavorites) {
        self.dialogLabel.text = onlyFiveDoors;
        [self.dialogButton setTitle:okButton forState:UIControlStateNormal];
    }
    
    if (type == kCustomAlertTypeNoInternet) {
        self.dialogLabel.text = noInternet;
        [self.dialogButton setTitle:okButton forState:UIControlStateNormal];
    }
}

- (void) show {
    self.view.hidden = NO;
    self.dialogView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
        self.dialogView.alpha = 1.0;
        self.dialogView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void) dismissWithCompletion:(void (^)(BOOL completed))block {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.0;
        self.dialogView.alpha = 0;
        self.dialogView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        if (block) block(YES);
    }];
}

- (IBAction)dismissSelf:(id)sender {
    [self dismissWithCompletion:^(BOOL completed) {
        [self.delegate customAlertButtonTapped];
    }];
}



@end
