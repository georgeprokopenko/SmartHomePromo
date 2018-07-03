//
//  DocumentsPage.m
//  DomophoneApp
//
//  Created by George Prokopenko on 26.04.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

#import "DocumentsPage.h"
#import "DocumentCell.h"

@interface DocumentsPage () <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) UITableView* tableView;
@end

@implementation DocumentsPage

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
    UINib* cellNib = [UINib nibWithNibName:@"DocumentCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"DocumentCell"];
}



#pragma mark Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentCell* documentCell; //= [tableView dequeueReusableCellWithIdentifier:@"DistrictInfoNewsCell" forIndexPath:indexPath];
    //[infoCell setBottomLabelText:@"Сегодня 29.01.2018 в 19.45 - пройдёт собрание собственников Варшавское шоссе дом 141 корпуса 6 (строительный номер 5) и корпуса 7 ..."];
    return documentCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
