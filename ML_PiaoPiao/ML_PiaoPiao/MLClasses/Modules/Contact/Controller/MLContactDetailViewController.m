//
//  MLContactDetailViewController.m
//  ML_PiaoPiao
//
//  Created by 胡梦龙 on 16/9/25.
//  Copyright © 2016年 胡梦龙. All rights reserved.
//

#import "MLContactDetailViewController.h"
#import "MLDetailChatViewController.h"
#import "MLTabBarViewController.h"
#import "MLReportViewController.h"
@interface MLContactDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *sayLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@property (weak, nonatomic) IBOutlet UILabel *photoLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *SecondCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *thirdCell;

@property (nonatomic, assign) BOOL isBlackName;

@end

@implementation MLContactDetailViewController

+ (instancetype)ml_contactDetailVC {

    return MYSTORYBOARD;

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
 
//    [self.navigationController popViewControllerAnimated:YES];
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [self ml_createButton];
    
    _username.text = self.buddy.username;
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.SecondCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.thirdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tableView ml_setbackViewDayAndNight];
    [self.username ml_setLabelDayAndNight];
    [self.sayLabel ml_setLabelDayAndNight];
    [self.vipLabel ml_setLabelDayAndNight];
    [self.photoLabel ml_setLabelDayAndNight];
    [self.firstCell ml_setFrontViewDayAndNight];
    [self.SecondCell ml_setFrontViewDayAndNight];
    [self.thirdCell ml_setFrontViewDayAndNight];
    
    
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [[EaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
        if (!error) {
            NSLog(@"获取成功 -- %@",blockedList);
            self.thirdCell.textLabel.text = @"添加黑名单";
            self.thirdCell.imageView.image = [UIImage imageNamed:@"BlackName"];
            self.isBlackName = NO;
            for (NSString *userName in blockedList) {
                if ([userName isEqualToString:self.buddy.username]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.thirdCell.textLabel.text = @"移除黑名单";
                        self.thirdCell.imageView.image = [UIImage imageNamed:@"RemoveBlack"];
                        self.isBlackName = YES;
                        
                    });
                    
                }
            }
        }
    } onQueue:nil];
    
    [self.tableView reloadData];

}




#pragma mark - tableView协议方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 1) {
        MLReportViewController *reportVC = [[MLReportViewController alloc] init];
        [self.navigationController pushViewController:reportVC animated:YES];
    }
    
    if (indexPath.section == 2) {
        
        if (_isBlackName) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消黑名单后您将收到对方的消息" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //
                
                EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:self.buddy.username];
                if (!error) {
                    NSLog(@"发送成功");
                    weakSelf.thirdCell.textLabel.text = @"加入黑名单";
                    weakSelf.thirdCell.imageView.image = [UIImage imageNamed:@"BlackName"];
                    weakSelf.isBlackName = NO;

                }
                
                
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        } else {
        
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加入黑名单后将接不到对方的消息" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //
                
                EMError *error = [[EaseMob sharedInstance].chatManager blockBuddy:self.buddy.username 	relationship:eRelationshipFrom];
                if (!error) {
                    NSLog(@"发送成功");
                    weakSelf.thirdCell.textLabel.text = @"取消黑名单";
                    weakSelf.thirdCell.imageView.image = [UIImage imageNamed:@"RemoveBlack"];
                    weakSelf.isBlackName = YES;
                }
                
                
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
        
        
    }

}


#pragma mark - 私有方法
- (void)ml_createButton {
    CGFloat viewW = self.view.bounds.size.width;
  
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, 200)];
    self.tableView.tableFooterView = footView;
    
    UIButton *sendMsgButton = [[UIButton alloc] init];
    [sendMsgButton addTarget:self action:@selector(ml_sendMsg) forControlEvents:UIControlEventTouchUpInside];
    sendMsgButton.backgroundColor = ColorWith48Red;
    [sendMsgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMsgButton setTitle:@"发消息" forState:UIControlStateNormal];
    sendMsgButton.frame = CGRectMake(30, 60, viewW - 60, 60);
    sendMsgButton.layer.cornerRadius = 10;
    [self.view addSubview:sendMsgButton];
    [footView addSubview:sendMsgButton];
    [sendMsgButton jxl_setDayMode:^(UIView *view) {
        view.backgroundColor = ColorWith48Red;
        [((UIButton *)view) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } nightMode:^(UIView *view) {
        view.backgroundColor = ColorWith51Black;
        [((UIButton *)view) setTitleColor:ColorWith243 forState:UIControlStateNormal];
    }];

}

- (void)ml_sendMsg {
    
    [self.navigationController popViewControllerAnimated:NO];
    
    
    MLTabBarViewController *tabBarVC = [[MLTabBarViewController alloc] init];
    tabBarVC = (MLTabBarViewController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    tabBarVC.selectedViewController = tabBarVC.viewControllers[0];
    MLDetailChatViewController *detailChatVC = [[MLDetailChatViewController alloc] init];
    detailChatVC.userName = self.buddy.username;
    [(UINavigationController *)tabBarVC.viewControllers[0] pushViewController:detailChatVC animated:YES];
    
    
    


}


@end
