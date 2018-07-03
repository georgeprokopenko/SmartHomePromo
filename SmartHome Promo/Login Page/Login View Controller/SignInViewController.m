//
//  SignInViewController.m
//  DomophoneApp
//
//  Created by George Prokopenko on 10.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInFormView.h"
#import "AccountManager.h"
#import "Constants.h"
#import "MainViewController.h"
#import "Mapper.h"
#import "Reachability.h"

@interface SignInViewController () <SignInFormViewDelegate>
@property (retain, nonatomic) SignInFormView* formView;
@property (assign, nonatomic) BOOL isInternetExists;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForm];
    [self checkInternetConnection];
}

- (void) setupForm {
    [self.navigationController setNavigationBarHidden:YES];
    if (!self.formView) self.formView = [[SignInFormView alloc] initWithFrame:CGRectMake(0, 0, 310, 320)];
    self.formView.delegate = self;
    self.formView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                       [UIScreen mainScreen].bounds.size.height/2);
    [self.view addSubview:self.formView];
    [self.view layoutIfNeeded];
}

- (void) setNotificators {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInDone) name:kAuthDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInTimedOut) name:kProcessTimedOut object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wrongSignInCredentials) name:kWrongSignInCredentials object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linphoneAccountRegistered) name:kLinphoneAccountRegistered object:nil];
}

- (void) removeNotificators {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAuthDone object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProcessTimedOut object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWrongSignInCredentials object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLinphoneAccountRegistered object:nil];
}



#pragma mark Sign In Form Delegate

- (void)signInForm:(id)form isEditing:(BOOL)editing {
    if (editing) [self extendForm];
}

- (void) extendForm {
    [self.formView formWillExtend];
    [UIView animateWithDuration:0.5 animations:^{
        self.formView.frame = self.view.bounds;
        [self.formView setNeedsLayout];
        [self.formView layoutIfNeeded];
    }];
}



#pragma mark Signing In

- (void) signInButtonTapped {
    if (!self.isInternetExists) {
        [self noInternetConnection];
        return;
    }

    [self allowSignIn];

}

- (void) signInDone {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) linphoneAccountRegistered {
    [self removeNotificators];
    [self.formView.activityIndicator stopAnimating];
    [AccountManager shared].shouldCheckIfDeviceIsRegistered = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) signInTimedOut {
    [self removeNotificators];
    [self.formView.activityIndicator stopAnimating];
    [self.formView setErrorShown:YES];
    [self.formView resetFormWithCredentials:NO];
}

- (void) wrongSignInCredentials {
    [self removeNotificators];
    [self.formView.activityIndicator stopAnimating];
    [self.formView setErrorShown:YES];
    [self.formView resetFormWithCredentials:NO];
}


- (void) allowSignIn {
    [self.formView.activityIndicator startAnimating];
    [self setNotificators];
    
    NSCharacterSet *chars = [NSCharacterSet characterSetWithCharactersInString:@"- ()"];
    NSString* accountNumber = [[self.formView.accountTextField.text componentsSeparatedByCharactersInSet: chars] componentsJoinedByString: @""];
    [AccountManager signInWithLogin:accountNumber
                           password:self.formView.passwordTextField.text];
}

- (void) noInternetConnection {
   [Mapper showCustomAlertWithType:kCustomAlertTypeNoInternet];
}



- (void)checkInternetConnection {
    
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.ya.ru"];
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isInternetExists = YES;
        });
    };

    
    reachability.unreachableBlock = ^(Reachability*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isInternetExists = NO;
        });
    };
    
    [reachability startNotifier];
    
}




#pragma mark Access Page

- (void) getAccessButtonTapped {
    [Mapper pushCustomViewController:kAccessResetPage from:self animated:YES];
}





@end
