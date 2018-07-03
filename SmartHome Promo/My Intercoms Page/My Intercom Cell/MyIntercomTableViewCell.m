//
//  MyIntercomTableViewCell.m
//  DomophoneApp
//
//  Created by George Prokopenko on 12.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "MyIntercomTableViewCell.h"
#import "IntercomManager.h"

@interface MyIntercomTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *intercomeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *intercomeImageView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isFavoriteStarView;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (assign, nonatomic) BOOL cellIsSwipedOut;
@property (strong, nonatomic) IntercomObject* intercom;
@end

@implementation MyIntercomTableViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.intercomeImageView.layer.cornerRadius = 10.0;
    self.mainView.layer.cornerRadius = 10.0;
    [self.lockButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [self.mainView setBackgroundColor:[UIColor colorWithRed:38/255.0f green:45/255.0f blue:55/255.0f alpha:1.0f]];
    self.cellIsSwipedOut = NO;
    [self.isFavoriteStarView hide];
    
    UISwipeGestureRecognizer* leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCellLeft)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer* rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCellRight)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mainView addGestureRecognizer:leftSwipeGR];
    [self.mainView addGestureRecognizer:rightSwipeGR];
}

- (void) customize:(IntercomObject*)intercom {
    self.intercom = intercom;
    self.intercomeNameLabel.text = intercom.name;
    self.isFavoriteStarView.hidden = !intercom.isFavorite;
}

- (void) setCellWillMove:(BOOL)moving {
    UIColor* newColor;
    if (moving) {
        newColor = [UIColor colorWithRed:64/255.0f green:74/255.0f blue:82/255.0f alpha:1.0f];
        self.mainView.layer.masksToBounds = NO;
        self.mainView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.mainView.layer.shadowRadius = 15.0;
        self.mainView.layer.shadowOpacity = 0.3;
    } else {
        newColor = [UIColor colorWithRed:38/255.0f green:45/255.0f blue:55/255.0f alpha:1.0f];
        self.mainView.layer.shadowRadius = 0.0;
        self.mainView.layer.shadowOpacity = 0.0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainView setBackgroundColor:newColor];
    }];
}

#pragma mark Swiping Cell

- (void) swipeCellLeft {
    if (self.cellIsSwipedOut) return;
    [self.delegate cellWillBeSwipedLeft:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.mainView.transform = CGAffineTransformMakeTranslation(-100, 0);
        self.cellIsSwipedOut = YES;
    }];
}

- (void) swipeCellRight {
    if (!self.cellIsSwipedOut) return;
    [UIView animateWithDuration:0.4 animations:^{
        self.mainView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.cellIsSwipedOut = NO;
    }];
}


#pragma mark Cell Actions

- (IBAction)unlockDoorAction:(id)sender {
    [IntercomManager openIntercom:self.intercom completion:^(BOOL success) {
        if (success) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.lockButton cache:YES];
            [self.lockButton setImage:[UIImage imageNamed:@"openButton"] forState:UIControlStateNormal];
            [UIView commitAnimations];
            self.lockButton.userInteractionEnabled = NO;
        }
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.lockButton cache:YES];
            [self.lockButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
            [UIView commitAnimations];
            self.lockButton.userInteractionEnabled = YES;
        });
    }];
}

- (IBAction)favoriteButtonClicked:(id)sender {
    if (!self.intercom.isFavorite) {
        if (![self.delegate canEditFavoritesWithCoeff:1]) return;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.favoriteButton cache:YES];
        [self.favoriteButton setImage:[UIImage imageNamed:@"unfavoriteButton"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        
        [self.isFavoriteStarView show];
        [self setIntercomFavorited:NO];
        self.favoriteLabel.text = @"Открепить";
    } else {
        [self.delegate canEditFavoritesWithCoeff:-1];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.favoriteButton cache:YES];
        [self.favoriteButton setImage:[UIImage imageNamed:@"favoriteButton"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        
        [self.isFavoriteStarView hide];
        [self setIntercomFavorited:NO];
        self.favoriteLabel.text = @"В избранное";
    }
    
    if (self.cellIsSwipedOut) [self swipeCellRight];
}

- (void) setIntercomFavorited:(BOOL)favorite {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.intercom.isFavorite = favorite;
    [realm commitWriteTransaction];
}


@end
