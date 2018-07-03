//
//  MyIntercomsViewController.m
//  DomophoneApp
//
//  Created by George Prokopenko on 12.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "MyIntercomsViewController.h"
#import "MyIntercomTableViewCell.h"
#import "Mapper.h"
#import "Constants.h"
#import "NetworkLoader.h"
#import "AccountManager.h"
#import "ActivitySpinner.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "ErrorHandler.h"

typedef enum : NSInteger {
    kTableViewCellTypeFull,
    kTableViewCellTypeShort,
} kTableViewCellType;

@interface MyIntercomsViewController () <UITableViewDelegate, UITableViewDataSource, MyIntercomTableViewCellDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIButton *reloadDataButton;


@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (retain, nonatomic) NSMutableArray<IntercomObject*>* intercoms;
@property int favoriteCounter;
@end

@implementation MyIntercomsViewController

static kTableViewCellType cellType = kTableViewCellTypeShort;
static NSString* cellIdentifier;

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkInternetConnection];
    [self setupTableView];
    [self setupNavigationBar];
    self.favoriteCounter = 0;
    
    self.intercoms = [[NetworkLoader allIntercomsInLocal] mutableCopy];
}

- (void) setupTableView {
    cellIdentifier = (cellType == kTableViewCellTypeShort)? @"MyIntercomCellShort" : @"MyIntercomCell";
    NSString* nibIdentifier = (cellType == kTableViewCellTypeShort)? @"MyIntercomTableViewCellShort" : @"MyIntercomTableViewCell";
    UINib* cellNib = [UINib nibWithNibName:nibIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 78, 0);
    
    UILongPressGestureRecognizer* lpGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureDetected:)];
    [self.tableView addGestureRecognizer:lpGR];
}

- (void) setupNavigationBar {
    self.navigationItem.title = @"Двери";
    self.reloadDataButton.layer.cornerRadius = self.reloadDataButton.bounds.size.height/2;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9, 16)];
    settingsButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [settingsButton setImage:[UIImage imageNamed:@"settingsIcon"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
}



#pragma mark Data Loading

- (IBAction) loadIntercoms {
    self.noDataView.hidden = YES;
    self.tableView.hidden = NO;
    [ActivitySpinner showWithTimout:10 completionHandler:nil];
    
    [NetworkLoader loadIntercomsListWithCompletion:^(NSMutableArray *intercomsList, NSError *error) {
        if (error) [ErrorHandler handleError:error];
        else {
            if (!intercomsList || intercomsList.count == 0) {[self noIntercomsData]; return;}
            else {
                [ActivitySpinner dismiss];
                self.intercoms = intercomsList;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }];
}

- (void) noIntercomsData {
    [ActivitySpinner dismiss];
    self.tableView.hidden = YES;
    self.noDataView.hidden = NO;
}



#pragma mark Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyIntercomTableViewCell* cell;
    if (!cell) cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell customize:[self.intercoms objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _intercoms.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellType == kTableViewCellTypeShort? 108 : UITableViewAutomaticDimension;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (APPMODE == AppModeDebug) {
        IntercomDetailViewController* detailPage = (IntercomDetailViewController*)[Mapper customViewController:kIntercomDetailPage];
        detailPage.selectedIntercom = [self.intercoms objectAtIndex:indexPath.row];
        detailPage.mainViewController = self.mainViewController;
        [self.mainViewController hideTabBar];
        [Mapper pushViewController:(UIViewController*)detailPage from:self animated:YES];
    }
    
}


#pragma mark Favorite selecting

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self slideAllCellsRightExcepting:nil];
}

- (void) cellWillBeSwipedLeft:(id)cell {
    [self slideAllCellsRightExcepting:(MyIntercomTableViewCell*)cell];
}

- (void) slideAllCellsRightExcepting:(MyIntercomTableViewCell*)cell {
    for (int count = 0; count < self.intercoms.count; count++) {
        MyIntercomTableViewCell* cellForIndex = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0]];
        if (!(cell && count == [self.tableView indexPathForCell:cell].row)) [cellForIndex swipeCellRight];
    }
}

- (BOOL) canEditFavoritesWithCoeff:(int)coeff {
    if (self.favoriteCounter < 5) {
        self.favoriteCounter += coeff;
        return YES;
    }
    else {
        [Mapper showCustomAlertWithType:kCustomAlertTypeExcessiveFavorites];
        return NO;
    }
    return YES;
}


#pragma mark Moving Cells

- (void) longPressGestureDetected:(id)sender {
    UILongPressGestureRecognizer* longPress = (UILongPressGestureRecognizer*)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    
    CGPoint point = [longPress locationInView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    static UIView* snapshot = nil;
    static NSIndexPath* sourceIndexPath = nil;
    
    switch (longPressState) {
        case UIGestureRecognizerStatePossible: {break;}
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                MyIntercomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [cell setCellWillMove:YES];
                snapshot = [self customSnapshotFromView:cell];
                
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                
                [UIView animateWithDuration:0.35 animations:^{
                    snapshot.center = center;
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = point.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.intercoms exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default: {
            MyIntercomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.35 animations:^{
                [cell setCellWillMove:NO];
                snapshot.center = cell.center;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            break;
        }
    }

}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}


#pragma mark Settings (v.1 only)

- (void) openSettings {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMainTabBarSelectIndexTwo object:nil];
}



#pragma mark Calling

- (void) openCallPageWith:(NSString *)name {
    if (self.intercoms.count > 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"sipNumber == %@", name];
        IntercomObject* neededIntercom = [[self.intercoms filteredArrayUsingPredicate:predicate] firstObject];
        
        IntercomDetailViewController* detailPage = (IntercomDetailViewController*)[Mapper customViewController:kIntercomDetailPage];
        detailPage.selectedIntercom = neededIntercom;
        detailPage.mainViewController = self.mainViewController;
        [Mapper pushViewController:(UIViewController*)detailPage from:self animated:YES];
    }
}


#pragma mark Checking Internet

- (void)checkInternetConnection {
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.ya.ru"];
    reachability.reachableBlock = ^(Reachability* reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.hidden = NO;
            self.noDataView.hidden = YES;
        });
    };
    
    reachability.unreachableBlock = ^(Reachability* reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.hidden = YES;
            self.noDataView.hidden = NO;
        });
    };
    [reachability startNotifier];
}


@end
