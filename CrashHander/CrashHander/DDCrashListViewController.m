//
//  ViewController.m
//  DebugTool
//
//  Created by 张桂杨 on 2017/3/21.
//  Copyright © 2017年 DD. All rights reserved.
//

#import "DDCrashListViewController.h"
#import "DDCatchCrash.h"


@interface DDCrashListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation DDCrashListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    
    _dataArray = [NSMutableArray arrayWithArray:[DDCatchCrash crashLogList]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
}

- (IBAction)deleteAll:(id)sender {
    [DDCatchCrash removeAll];
    [self.tableView reloadData];
}
- (void)startRefresh {
    _dataArray = [NSMutableArray arrayWithArray:[DDCatchCrash crashLogList]];
    [self.tableView reloadData];
    [self.tableView.refreshControl endRefreshing];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"CrashContent" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CrashContent"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        segue.destinationViewController.title = [DDCatchCrash crashLogList][indexPath.row];
    }
   
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DDCatchCrash removWithFileName:_dataArray[indexPath.row]];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
