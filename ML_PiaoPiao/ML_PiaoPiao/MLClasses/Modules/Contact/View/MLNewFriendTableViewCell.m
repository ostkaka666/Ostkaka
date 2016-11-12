//
//  MLNewFriendTableViewCell.m
//  ML_PiaoPiao
//
//  Created by 胡梦龙 on 16/9/24.
//  Copyright © 2016年 胡梦龙. All rights reserved.
//

#import "MLNewFriendTableViewCell.h"
#import "MLRequestInfo.h"
#import "MLContactViewController.h"
@interface MLNewFriendTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (weak, nonatomic) IBOutlet UIButton *regectButton;

@end

@implementation MLNewFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self ml_setFrontViewDayAndNight];
    [self.username ml_setLabelDayAndNight];
    [self.message ml_setLabelDayAndNight];
    [self.agreeButton jxl_setDayMode:^(UIView *view) {
        view.backgroundColor = [UIColor whiteColor];
        [((UIButton *)view) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } nightMode:^(UIView *view) {
        view.backgroundColor = ColorWithBackGround;
        [((UIButton *)view) setTitleColor:ColorWith243 forState:UIControlStateNormal];
    }];
    [self.regectButton jxl_setDayMode:^(UIView *view) {
        view.backgroundColor = [UIColor whiteColor];
        [((UIButton *)view) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } nightMode:^(UIView *view) {
        view.backgroundColor = ColorWithBackGround;
        [((UIButton *)view) setTitleColor:ColorWith243 forState:UIControlStateNormal];
    }];

}

- (IBAction)agree:(id)sender {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.requestInfo.username error:&error];
    if (isSuccess && !error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[self ml_superController].navigationController popViewControllerAnimated:YES];
            
          
        }];
        [alert addAction:action];
        [[self ml_superController] presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)refuse:(id)sender {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.requestInfo.username reason:@"" error:&error];
    if (isSuccess && !error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拒绝成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[self ml_superController].navigationController popViewControllerAnimated:YES];
            
        }];
        [alert addAction:action];
        [[self ml_superController] presentViewController:alert animated:YES completion:nil];
    }
}

+ (instancetype)ml_newFriendWithTableView:(UITableView *)tableView {
    static NSString *NewFriend = nil;
    if (!NewFriend) {
        NewFriend = @"NewFriend";
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:NewFriend];
    if (!cell) {
        [cell ml_setFrontViewDayAndNight];
        cell = MYXIB;
    }
    return cell;

}

- (void)setRequestInfo:(MLRequestInfo *)requestInfo {
    _requestInfo = requestInfo;
    _username.text = requestInfo.username;
    _message.text = requestInfo.message;
    


}


- (UIViewController *)ml_superController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
    
    
    
}
@end
