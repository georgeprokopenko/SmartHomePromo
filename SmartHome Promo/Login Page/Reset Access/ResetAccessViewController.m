//
//  ResetAccessViewController.m
//  linphone
//
//  Created by Prokopenko Georgy on 07/06/2018.
//

#import "ResetAccessViewController.h"

#define SetRetryTimer self.counterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countRetryTimer) userInfo:nil repeats:YES]

@interface ResetAccessViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (retain, nonatomic) IBOutlet UIButton* retrySendButton;
@property (retain, nonatomic) IBOutlet UIButton* sendButton;
@property (retain, nonatomic) NSTimer* counterTimer;
@property (retain, nonatomic) IBOutlet UIButton* backButton;

@end

@implementation ResetAccessViewController {
    int counter;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.numberTextField.layer.cornerRadius = 17.5;
    self.sendButton.layer.cornerRadius = 17.5;
    self.numberTextField.delegate = self;
    self.numberTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12.0, 0, 0);
    [self.numberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self resetViews];
}

- (void) resetViews {
    self.errorLabel.hidden = YES;
    self.fieldTitleLabel.hidden = NO;
    self.subtitleLabel.text = @"Введите ваш номер для получения 4-х значного кода";
    self.retrySendButton.hidden = YES;
    self.numberTextField.text = @"+7";
    self.retrySendButton.enabled = NO;
    self.retrySendButton.hidden = YES;
    self.fieldTitleLabel.text = @"Номер телефона";
    self.numberTextField.placeholder = @"Введите ваш телефон";
    [self.retrySendButton setTitle:@"Отправить повторно" forState:UIControlStateNormal];
    self.sendButton.enabled = NO;
    counter = 60;
}

- (void) textFieldDidChange:(UITextField*)textField {
    if (textField.text.length > 9) self.sendButton.enabled = YES;
    else self.sendButton.enabled = NO;
}


#pragma mark Actions

- (IBAction)sendButtonTapped:(id)sender {
    SetRetryTimer;
    self.retrySendButton.enabled = NO;
    self.retrySendButton.hidden = NO;
    self.fieldTitleLabel.text = @"Код";
    self.subtitleLabel.text = @"Мы отправили СМС с 4-х значным кодом, введите его ниже";
    self.numberTextField.text = nil;
    self.numberTextField.placeholder = @"----";
}

- (IBAction)retryButtonTapped:(id)sender {
    counter = 60;
    SetRetryTimer;
}


#pragma mark Retry sending

- (void) countRetryTimer {
    if (counter == 0) [self stopCounter];
    else {
        counter --;
        [UIView setAnimationsEnabled:NO];
        [self.retrySendButton setTitle:[NSString stringWithFormat:@"Отправить повторно (%i)", counter] forState:UIControlStateNormal];
        [UIView setAnimationsEnabled:YES];
    }
}

- (void) stopCounter {
    [self.counterTimer invalidate];
    self.counterTimer = nil;
    [self.retrySendButton setTitle:@"Отправить повторно" forState:UIControlStateNormal];
    self.retrySendButton.enabled = YES;
    self.retrySendButton.hidden = NO;
}


@end
