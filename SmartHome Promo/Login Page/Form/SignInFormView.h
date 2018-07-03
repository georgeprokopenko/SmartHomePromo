//
//  SignInFormView.h
//  DomophoneApp
//
//  Created by George Prokopenko on 10.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSPhoneLibrary.h"
#import "Categories.h"

@protocol SignInFormViewDelegate <NSObject>
- (void) signInForm:(id)form isEditing:(BOOL)editing;
- (void) signInButtonTapped;
- (void) getAccessButtonTapped;
@end

@interface SignInFormView : UIView

@property (assign, nonatomic) id <SignInFormViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet SHSPhoneTextField *accountTextField;
@property (retain, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) setErrorShown:(BOOL)shown;
- (void) resetFormWithCredentials:(BOOL)resetCredentials;
- (void) formWillExtend;
- (void) formWillRetract;

@end
