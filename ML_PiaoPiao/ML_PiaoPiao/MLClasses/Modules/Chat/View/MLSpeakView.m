//
//  MLSpeakView.m
//  ML_PiaoPiao
//
//  Created by 胡梦龙 on 16/9/30.
//  Copyright © 2016年 胡梦龙. All rights reserved.
//

#import "MLSpeakView.h"


@interface MLSpeakView ()

@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@end

@implementation MLSpeakView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self = MYXIB;
    }
    return self;
}

- (IBAction)touchDown:(UIButton *)sender {
    self.labelStatus.text = @"松手发送";
    
}
- (IBAction)touchUpInside {
    self.labelStatus.text = @"按住说话";
    
    
}
- (IBAction)touchDragOutside {
    self.labelStatus.text = @"松手取消发送";
    
    
}
- (IBAction)touchUpOutside {
    self.labelStatus.text = @"按住说话";
    
    
}


@end
