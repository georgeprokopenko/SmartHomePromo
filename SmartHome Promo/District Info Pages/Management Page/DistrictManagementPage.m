//
//  DistrictManagementPage.m
//  DomophoneApp
//
//  Created by George Prokopenko on 25.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "DistrictManagementPage.h"
#import "DistrictManagementButtonCell.h"

@interface DistrictManagementPage () <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) UITableView* tableView;
@end

@implementation DistrictManagementPage

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self registerCells];
}

- (void) setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:self.tableView];
}


- (void) registerCells {
    UINib* cellNib = [UINib nibWithNibName:@"DistrictManagementButtonCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"DistrictManagementButtonCell"];
}


#pragma mark Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DistrictManagementButtonCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:@"DistrictManagementButtonCell" forIndexPath:indexPath];
    [buttonCell setButtonText:@"Оплатить ЖКХ"];
    return buttonCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
