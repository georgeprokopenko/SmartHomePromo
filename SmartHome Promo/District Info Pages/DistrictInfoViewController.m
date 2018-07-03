//
//  DistrictInfoViewController.m
//  DomophoneApp
//
//  Created by George Prokopenko on 24.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "DistrictInfoViewController.h"

#import "DistrictInfoPage.h"
#import "DistrictManagementPage.h"
#import "DocumentsPage.h"

@interface DistrictInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *servicesButton;
@property (weak, nonatomic) IBOutlet UIButton *documentsButton;
@property (weak, nonatomic) IBOutlet UIView *slider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLeadingConstraint;

@property (retain, nonatomic) UITabBarController *tabBarController;
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation DistrictInfoViewController

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.topBarView layoutIfNeeded];
    [self setupContainerView];
    [self tabSelected:self.infoButton];
}

- (void) setupContainerView {
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    [self addChildViewController:self.tabBarController];
    [self.tabBarController.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.tabBarController.view];
    [self.tabBarController didMoveToParentViewController:self];
    [self setupTabPages];
}

- (void) setupTabPages {
    DistrictInfoPage* infoPage = [[DistrictInfoPage alloc] init];
    DistrictManagementPage* managementPage = [[DistrictManagementPage alloc] init];
    DocumentsPage* docsPage = [[DocumentsPage alloc] init];
    self.tabBarController.viewControllers = @[infoPage, managementPage, docsPage];
}

- (IBAction)tabSelected:(UIButton*)button {
    [self.infoButton setSelected:NO];
    [self.servicesButton setSelected:NO];
    [self.documentsButton setSelected:NO];
    [button setSelected:YES];
    [self.tabBarController setSelectedIndex:button.tag];
    
    if (button == self.servicesButton) self.sliderWidthConstraint.constant = 140;
    else self.sliderWidthConstraint.constant = button.frame.size.width;
    self.sliderLeadingConstraint.constant = button.center.x - self.sliderWidthConstraint.constant/2;
    [UIView animateWithDuration:0.3 animations:^{
        [self.topBarView layoutIfNeeded];
    }];
}



@end
