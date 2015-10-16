//
//  ViewController.m
//  exNation TO-DO list
//
//  Created by Виктор Суржок on 15.10.15.
//  Copyright © 2015 Виктор Суржок. All rights reserved.
//

#import "DeteilViewController.h"

@interface DeteilViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFild;
@property (weak, nonatomic) IBOutlet UIDatePicker *data;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@end

@implementation DeteilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonSave.userInteractionEnabled = NO;
    self.data.minimumDate = [NSDate date];
    [self.data addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.buttonSave addTarget:(self) action:@selector(save) forControlEvents:(UIControlEventTouchUpInside)];
    
    UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:
                                          self action:@selector(handleEndEditing)];
    [self.view addGestureRecognizer:handleTap];
}

- (void) handleEndEditing {

    if([self.textFild.text length] != 0) {
        [self.view endEditing:YES];
        self.buttonSave.userInteractionEnabled = YES;
    }
    else {
        [self showAlertWithMassage:@"Для сохранения события введите значение в текстовое поле"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) datePickerValueChanged {
    self.eventDate = self.data.date;
    NSLog(@"data %@", self.eventDate);
}

- (void) save {
    
    if (self.eventDate) {
        
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
            [self showAlertWithMassage:@"ДДата будушего события не может совпадать с текущей датой"];

        }
        
        if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending) {
            [self showAlertWithMassage:@"Дата будушего события не может быть ранее текущей даты"];

        }
        
        else {
            [self setNotification];
        }
        
        [self setNotification];
    }
    else{
        [self showAlertWithMassage:@"Для сохранения события введите значение даты на более поднее"];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.textFild]) {
        if([self.textFild.text length] != 0) {
        [self.textFild resignFirstResponder];
        self.buttonSave.userInteractionEnabled = YES;
        return YES;
        }
        else {
            [self showAlertWithMassage:@"Для сохранения события введите значение в текстовое поле"];
        }
        
    }
         return NO;
    
}

- (void) setNotification {
    NSString * eventInfo = self.textFild.text;
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"HH:mm dd.MMMM.yyyy";
    NSString * eventDate = [formater stringFromDate:self.eventDate];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                           eventInfo, @"eventInfo",
                           eventDate, @"eventDate", nil];
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.userInfo = dict;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    NSLog(@"save");
    
}

- (void) showAlertWithMassage : (NSString *) message {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Внимания!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
