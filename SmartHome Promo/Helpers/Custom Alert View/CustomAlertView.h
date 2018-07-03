//
//  CustomAlertView.h
//  linphone
//
//  Created by Prokopenko Georgy on 13/06/2018.
//

#import <UIKit/UIKit.h>

typedef enum CustomAlertViewType : NSInteger {
    kCustomAlertTypeExcessiveFavorites,
    kCustomAlertTypeNoInternet,
} CustomAlertViewType;

@protocol CustomAlertViewDelegate <NSObject>
- (void) customAlertButtonTapped;
@end

@interface CustomAlertView : UIViewController

@property (assign, nonatomic) id <CustomAlertViewDelegate> delegate;

- (void) setupWithType:(CustomAlertViewType)type;
- (void) show;
- (void) dismissWithCompletion:(void (^)(BOOL completed))block;

@end
