//
//  SignInFormView.m
//  DomophoneApp
//
//  Created by George Prokopenko on 10.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "SignInFormView.h"

@interface SignInFormView () <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView* view;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (retain, nonatomic) IBOutlet UIButton* signInButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountNumberTitleTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;

@end

@implementation SignInFormView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self customizeObjects];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customizeObjects];
    }
    return self;
}

- (void) customizeObjects {
    [[NSBundle mainBundle] loadNibNamed:@"SignInFormView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    
    self.view.layer.cornerRadius = 10.0;
    self.accountTextField.layer.cornerRadius = 17.5;
    self.accountTextField.delegate = self;
    [self.accountTextField.formatter setDefaultOutputPattern:@"+# (###) ###-##-##"];
    self.passwordTextField.layer.cornerRadius = 17.5;
    self.signInButton.layer.cornerRadius = 17.5;
    [self setButtonEnabled:NO];
    [self setErrorShown:NO];
    
    self.accountTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12.0, 0, 0);
    self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12.0, 0, 0);
    [self.accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) formWillExtend {
    self.view.layer.cornerRadius = 0.0;
    self.titleTopConstraint.constant = 50;
    self.accountNumberTitleTopConstraint.constant = 45;
}

- (void) formWillRetract {
    self.titleTopConstraint.constant = 28;
    self.accountNumberTitleTopConstraint.constant = 18;
}

- (void) setButtonEnabled:(BOOL)enabled {
    self.signInButton.enabled = enabled;
    self.signInButton.alpha = enabled? 1.0 : 0.6;
}

- (void) setErrorShown:(BOOL)shown {
    self.errorLabel.hidden = !shown;
    self.accountNumberLabel.hidden = shown;
    if (shown) {
        [self.errorLabel shake];
        self.accountTextField.layer.borderWidth = 1.0f;
        self.passwordTextField.layer.borderWidth = 1.0f;
        self.accountTextField.layer.borderColor = self.errorLabel.textColor.CGColor;
        self.passwordTextField.layer.borderColor = self.errorLabel.textColor.CGColor;
    } else {
        self.accountTextField.layer.borderWidth = .0f;
        self.passwordTextField.layer.borderWidth = .0f;
    }
}

#pragma mark Text Field Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {    
    [self setErrorShown:NO];
    [self.delegate signInForm:self isEditing:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate signInForm:self isEditing:NO];
}

- (void) textFieldDidChange:(UITextField*)textField {
    if (self.accountTextField.text.length > 9 &&
         self.passwordTextField.text.length > 2) [self setButtonEnabled:YES];
    else [self setButtonEnabled:NO];
}


#pragma mark Actions

- (IBAction) signInButtonAction:(id)sender {
    self.accountTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    [self.delegate signInButtonTapped];
}

- (void) resetFormWithCredentials:(BOOL)resetCredentials {
    [self setButtonEnabled:NO];
    if (resetCredentials) self.accountTextField.text = @"";
    self.passwordTextField.text = @"";
    self.accountTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
}

- (IBAction) getAccess:(id)sender {
    [self.delegate getAccessButtonTapped];
}

@end
