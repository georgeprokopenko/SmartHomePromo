//
//  IntercomDetailViewController.m
//  DomophoneApp
//
//  Created by George Prokopenko on 18.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "IntercomDetailViewController.h"
#import "MyIntercomsViewController.h"
#import "IntercomManager.h"
#import "ActivitySpinner.h"

@interface IntercomDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *videoErrorView;
@property (weak, nonatomic) IBOutlet UIButton *openIntercomButton;

//@property (retain, nonatomic) AVAudioPlayer* player;
@property (assign, nonatomic) BOOL micEnabled;

@end

@implementation IntercomDetailViewController

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (void) viewWillDisappear:(BOOL)animated {
    MyIntercomsViewController* previousVC = (MyIntercomsViewController*) self.navigationController.viewControllers[0];
    [previousVC.mainViewController showTabBar];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.selectedIntercom.humanName];
    self.videoErrorView.hidden = YES;
    [self setupAsOutcomingCall];
}
/*
- (void) viewDidAppear:(BOOL)animated {
    LinphoneCall *currentCall = linphone_core_get_current_call(LC);
    if (currentCall == NULL) [self setupAsOutcomingCall];
    else [self setupAsIncomingCall];
}
*/
#pragma mark Main Methods

- (void) setupAsOutcomingCall {
    self.acceptButton.hidden = YES;
    [self startGettingVideo];
    self.micEnabled = YES;
}

- (void) setupAsIncomingCall {
    [self playMusic:YES];
    self.acceptButton.hidden = NO;
    [self startGettingVideo];
}



#pragma mark Bottom Buttons Actions

- (IBAction)accept:(id)sender {
    [self playMusic:NO];
    self.muteButton.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.acceptButton cache:YES];
    [self.acceptButton setImage:[UIImage imageNamed:@"micOffButton"] forState:UIControlStateNormal];
    [UIView commitAnimations];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.muteButton.hidden = NO;
        self.acceptButton.hidden = YES;
    });
    
}


#pragma mark Actions

- (IBAction)openIntercom:(id)sender {
    [IntercomManager openIntercom:self.selectedIntercom completion:^(BOOL success) {
        if (success) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.openIntercomButton cache:YES];
            [self.openIntercomButton setImage:[UIImage imageNamed:@"openButton"] forState:UIControlStateNormal];
            [UIView commitAnimations];
            self.openIntercomButton.userInteractionEnabled = NO;
        }
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 4.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.openIntercomButton cache:YES];
            [self.openIntercomButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
            [UIView commitAnimations];
            self.openIntercomButton.userInteractionEnabled = YES;
        });
    }];
}


- (IBAction)muteAction:(UIButton*)muteButton  {
    
    if (self.micEnabled) {
        if (muteButton) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:muteButton cache:YES];
            [muteButton setImage:[UIImage imageNamed:@"micButton"] forState:UIControlStateNormal];
            [UIView commitAnimations];
        }
        self.micEnabled = NO;
    }
    else {
        if (muteButton) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:muteButton cache:YES];
            [muteButton setImage:[UIImage imageNamed:@"micOffButton"] forState:UIControlStateNormal];
            [UIView commitAnimations];
        }
        self.micEnabled = YES;
    }
}

- (IBAction)decline:(id)sender {
    [self playMusic:NO];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Setting up


- (void) startGettingVideo {
    [ActivitySpinner showInView:self.videoView];
    
    //if (!linphone_core_video_display_enabled(LC)) { self.videoErrorView.hidden = NO; return; }
    /*
    LinphoneCall *call = linphone_core_get_current_call(LC);
    if (call) {
        LinphoneCallAppData *callAppData = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
        callAppData->videoRequested = TRUE;
     
        LinphoneCallParams *call_params = linphone_core_create_call_params(LC,call);
        linphone_call_params_enable_video(call_params, TRUE);
        linphone_core_update_call(LC, call, call_params);
        linphone_call_params_destroy(call_params);
    }
*/
}

- (void) playMusic:(BOOL)enable {
    /*
    if (!enable) {
        [self.player setVolume:0.0];
        self.player = nil;
        return;
    }
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    resourcePath = [resourcePath stringByAppendingString:@"/incomingCall.m4r"];
    NSError* error;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:
                   [NSURL fileURLWithPath:resourcePath] error:&error];
    
    if(!error){
        self.player.delegate = self;
        [self.player play];
        self.player.numberOfLoops = 0;
        self.player.currentTime = 0;
        self.player.volume = 0.8;
    }
    */
}

- (void) videoStateChanged {
    /*
    bool video_enabled = false;
    LinphoneCall *currentCall = linphone_core_get_current_call(LC);
    if (linphone_core_video_supported(LC)) {
        if (linphone_core_video_display_enabled(LC) && currentCall && !linphone_core_sound_resources_locked(LC) &&
            linphone_call_get_state(currentCall) == LinphoneCallStreamsRunning) {
            video_enabled = TRUE;
            if (linphone_call_params_video_enabled(linphone_call_get_current_params(currentCall))) [ActivitySpinner dismiss];
        }
    }
    
    if (video_enabled) {
        [ActivitySpinner dismiss];
    }
     */
}





@end
